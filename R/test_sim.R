library(EpiModelHIV)
library(dplyr)

source("R/shared_variables.R", local = TRUE)
hpc_context <- TRUE
source("R/C-netsim_scenarios/z-context.R", local = TRUE)

prep_start <- calibration_end
source("R/netsim_settings.R", local = TRUE)
est      <- readRDS("data/intermediate/estimates/netest-local.rds")

#update param
param <- param.net(
  data.frame.params   = read.csv("data/input/params.csv"),
  netstats            = netstats,
  epistats            = epistats,
  prep.start          = 0,
  riskh.start         = 0, # - year_steps - 1,
  part.ident.start    = Inf,
  mdd.prob.base = 0.3,
  mdd.diag.gen.prob = c(0.1, 0.2)
)

control <- control_msm(
  .tracker.list = EpiModelHIV::make_calibration_trackers(),
  nsteps = 2000, #calibration_end
  verbose = TRUE
)

sim <- netsim(est, param, init, control)
saveRDS(sim, "sim.rds")

library(EpiModelHIV)
library(dplyr)
library(tidyr)
library(ggplot2)
theme_set(theme_light())

sim <- readRDS("sim.rds")
d <- as_tibble(sim)

d |> select(
  time,
  mdd.prphiv1, mdd.prphiv0, mdd.diag.prphiv1, mdd.diag.prphiv0
) |> pivot_longer(-time) |>
ggplot(aes(x = time, y = value, col = name)) +
  geom_line()


