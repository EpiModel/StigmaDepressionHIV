# Scratchpad for interactive testing before integration in a script

library(dplyr)
source("R/utils-seed.R")

# get attributes from the network esitmate
est <- readRDS("./data/intermediate/estimates/netest-hpc.rds")
nw <- est[[1]][["newnetwork"]]
otha <- network::list.vertex.attributes(nw)
otha <- setdiff(
  otha,
  c("na", "vertex.names", "active", "testatus.active", "tergm_pid")
)

d_attrs <- lapply(
  otha, network::get.vertex.attribute,
  x = nw, na.omit = FALSE, null.na = TRUE, unlist = TRUE
)
names(d_attrs) <- otha
d_attrs <- as_tibble(d_attrs)

# prepare the "target" population
sim <- readRDS("./data/intermediate/calibration/sim__empty_scenario__1.rds")
d_tar <- as_tibble(sim$attr[[1]])

d_tar <- select(d_tar, -c(starts_with("deg_"))) |>
  mutate(across(
    c(ends_with(".time"), ends_with("infTime"), starts_with("prep.ind."),
      last.neg.test),
    function(x) x - sim$last_timestep
  ))

# format `diag.status` to be able to join the dfs
d_attrs$dg2 <- d_attrs$diag.status
d_tar$dg2 <- ifelse(is.na(d_tar$diag.status), 0, d_tar$diag.status)

# sample join and save
d_final <- sample_join(d_attrs, d_tar, by = c("race", "dg2", "role.class"))
d_final$dg2 <- NULL
d_final <- select(
  d_final,
  -c(
    prepClass ,prepElig ,prepStat ,prepStartTime ,prepLastRisk ,
    prep.start.counter ,part.scrnd ,part.ident ,part.ident.counter ,
    sexStigmaClass ,mdd.status ,mdd.diag.status ,mdd.diag.time ,
    mdd.scrn.counter ,mdd.lastscrn.time ,mdd.tx.status ,mdd.txepi.counter ,
    mdd.txinit.time ,mdd.currtx.tottime ,mdd.currtx.stage ,mdd.lasttx.cumlt ,
    mdd.suitry.status ,mdd.suitry.counter ,mdd.suitry.time ,mdd.suicompl.status ,
    mdd.suicompl.time ,mdd.txintv.status ,mdd.txintvinit.time ,mdd.txintv.last.endtime ,
    mdeCurr ,mdeCurr.starttime ,mde.last.endtime ,mde.counter ,mde.symseverity ,
    mde.roleimpair ,mdd.everdiag.time ,prep.ind.uai.mono ,prep.ind.uai.nmain ,
    prep.ind.sti ,prep.ind.uai.conc
  )
)

saveRDS(d_final, "d_init_attr.rds")

# d_final |>
#   group_by(race) |>
#   summarise(
#     cc.dx.prev = sum(diag.status, na.rm = TRUE) / n(),
#     cc.prev = sum(status) / n(),
#     prop_dx = sum(diag.status, na.rm = TRUE) / sum(status)
#   )
#
#
# d_tar |>
#   group_by(race) |>
#   summarise(
#     cc.dx.prev = sum(diag.status, na.rm = TRUE) / n(),
#     cc.prev = sum(status) / n(),
#     prop_dx = sum(diag.status, na.rm = TRUE) / sum(status)
#   )
#

library(dplyr)
library(ggplot2)
d  <- readRDS("d_init_attr.rds")

d |>
  group_by(race) |>
  summarise(
    cc.prep = sum(prepStat, na.rm = TRUE) / sum(prepElig, na.rm = TRUE)
  )
