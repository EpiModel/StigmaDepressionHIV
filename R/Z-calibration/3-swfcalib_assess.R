## 3. swfcalib Assessment
##
## interactive script to evaluate why an swfcalib process did not returned the
## expected results. It creates the assessment report and interactively look
## into the `results.rds` object found in the calibration folder.

# Restart R before running this script (Ctrl_Shift_F10 / Cmd_Shift_0)

# Setup ------------------------------------------------------------------------
library(dplyr)
library(tidyr)
library(ggplot2)
theme_set(theme_light())

source("R/shared_variables.R", local = TRUE)
source("R/Z-calibration/z-context.R", local = TRUE)

# Process ----------------------------------------------------------------------

swfcalib_dir <- fs::path("data", "intermediate", "swfcalib")
theme_set(theme_light())

# Assessment -------------------------------------------------------------------
swfcalib::render_assessment(fs::path(swfcalib_dir, "assessments.rds"))

# Results ----------------------------------------------------------------------
# results <- readRDS(fs::path(swfcalib_dir, "results.rds"))
results <- readRDS(fs::path(swfcalib_dir, "results.rds"))
proposals <- readRDS(fs::path(swfcalib_dir, "proposals.rds"))

pu <- results |>
  filter(abs(ir100.gc - 12.81) < 0.1) |>
  pull(ugc.prob) |> median()

pgc <- results |>
  filter(abs(ugc.prob - 0.2584717) < 0.001) |>
  select(ugc.prob, ir100.gc)



results |>
  filter(.iteration == max(.iteration)) |>
  pull(hiv.test.rate_1) |>
  range()

# targets = paste0("cc.linked1m.", c("B", "H", "W")),
# targets_val = c(0.829, 0.898, 0.881),
# params = paste0("tx.init.rate_", 1:3),
ggplot(results, aes(
    x = mdd.diag.gen.prob_2,
    y = mdd.diag.prphiv1,
    col = as.factor(.iteration)
  )) +
  geom_point() +
  geom_hline(yintercept = c(0.47, 0.45))

ggplot(results, aes(
    x = hiv.test.rate_1,
    y = cc.dx.B,
    col = as.factor(.iteration)
  )) +
  geom_point() +
  geom_hline(yintercept = 0.847) +
  geom_vline(xintercept = 0.002688045)


# range at each iteration
results |>
  group_by(.iteration) |>
  summarize(
    lo = min(hiv.trans.scale_3),
    hi = max(hiv.trans.scale_3)
  )




results |>
  select(starts_with("hiv.trans"), starts_with("i.prev.dx")) |>
  mutate(
    i.prev.dx.B = i.prev.dx.B - 0.33,
    i.prev.dx.H = i.prev.dx.H - 0.127,
    i.prev.dx.W = i.prev.dx.W - 0.09,
    se = i.prev.dx.B^2 + i.prev.dx.H^2 + i.prev.dx.W^2,
    B = abs(i.prev.dx.B),
    H = abs(i.prev.dx.H),
    W = abs(i.prev.dx.W),
  ) |>
  select(se, everything()) |>
  arrange(se) |>
  filter(B < 0.02, H < 0.02, W < 0.01) |>
  summarise(across(starts_with("hiv.trans"), median))

co <- readRDS("./calib_object.rds")


results |>
  filter(ir100.gc > 0) |>
ggplot(aes(
    x = ugc.prob,
    y = ir100.gc,
    col = as.factor(.iteration)
  )) +
  geom_point() +
  geom_hline(yintercept = 12.81) +
  geom_smooth()


r0 <- results |> filter(ir100.gc > 0)

mod <- lm(ir100.gc ~ ugc.prob, data = r0)

plot(mod)



loss_fun <- function(par, t)  abs(predict(mod, data.frame(ugc.prob = par)) - t)
optimize(interval = c(0.24, 0.3), f = loss_fun, t = 12.81)

