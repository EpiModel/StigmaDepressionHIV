##
## Processing counterfactual scenarios - Table 2
##


# Setup ----------------------------------------------------------------------------------

source("R/C-netsim_scenarios/3.0-functions_scenarios_process.R")


sims_dir <- paste0("data/intermediate/scenarios")
save_dir <- paste0("data/output/local")


#get batch info
batches_infos <- EpiModelHPC::get_scenarios_batches_infos(
  paste0("data/intermediate/scenarios")
)





#A. Process intervdata -------------------------------------------------------------------
#install.packages("future.apply")
suppressMessages({
  library("EpiModelHIV")
  library("future.apply")
  library("tidyr")
  library("dplyr")
  library("ggplot2")
})


#get sim files
sim_files <- list.files(
  sims_dir,
  pattern = "^sim__.*rds$",
  full.names = TRUE
)


#Process each batch in parallel
intervds <- future.apply::future_lapply(
  sim_files,
  process_fulldata,
  ts = 0 #3901 - (5 * 52) + 1   #gets data from 5 years prior to intervention start
)


#Merge all batches
alldata <- bind_rows(intervds)
saveRDS(alldata, paste0(save_dir, "/alldata_",Sys.Date(),".rds"))




#B. Process outcome_sims and outcome_scenario data----------------------------------------
outcomes_sims <- get_outcome_sims(alldata) %>%
  select(tbl, scenario.num, scenario.new, scenario_name, sim,
         starts_with("incid"),
         prepCov.yr10, diagCov.yr10, artCov.yr10, vSuppCov.yr10,
         i.num.yr10, diag.yr10, artCurr.yr10, vSupp.yr10,
         diagCov2.yr10, artCov2.yr10, vSuppCov2.yr10,
         prepStartAll,

         # elig.indexes.nd, found.indexes.nd, prp.indexes.found.nd,
         # elig.indexes.pp, found.indexes.pp, prp.indexes.found.pp,
         # elig.indexes.all, found.indexes.all, prp.indexes.found.all,

         elig.indexes.nd, found.indexes.nd, prp.indexes.found.nd,
         numPP.1, eligPP.for.retest, prp.allPP.eligandnic1,
         eligPPforRetest.rxnaive, prp.eligPP.rxnaive, eligPPforRetest.ooc, prp.eligPP.ooc, recent.ppretested, recent.ppretested2,
         elig.indexes.pp, found.indexes.pp, prp.indexes.found.pp,
         elig.indexes.all, found.indexes.all, prp.indexes.found.all,

         elig.partners, found.partners, prp.partners.found.gen1, posPart.indexes, negunkPart.indexes,
         elig.partners.gen2, found.partners.gen2, prp.partners.found.gen2, posPart.gen2, negunkPart.gen2,
         elig.partners.all, found.partners.all, prp.partners.found.all, posPart.indexes.all, negunkPart.indexes.all,

         partners.per.index,

         tot.part.ident, elig.for.scrn,
         part.scrnd.tst, positive.part, negative.part,

         part.scrnd.prep, scrnd.neg, scrnd.pos, diff.scrnd.pos,
         scrnd.prepon, scrnd.noprep, scrnd.noprepnorisk,
         elig.prepStartPart, prepStartPart,

         part.start.tx,
         part.reinit.tx,
         gen.start.tx,
         pp.reinit.tx)
saveRDS(outcomes_sims, paste0(save_dir, "/outcomes_sims_",Sys.Date(),".rds"))



outcomes_sce <- outcomes_sims %>%
  select(- c(sim)) %>%
  group_by(tbl, scenario.num, scenario.new, scenario_name) %>%
  summarise(across(everything(),list(
    low = ~ quantile(.x, 0.025, na.rm = TRUE),
    med = ~ quantile(.x, 0.50, na.rm = TRUE),
    high = ~ quantile(.x, 0.975, na.rm = TRUE)
  ),
  .names = "{.col}__{.fn}"
  )) %>%
  mutate(across(where(is.numeric), ~round (., 5))) %>% ungroup()%>%
  arrange(tbl, scenario.num, scenario.new, scenario_name)
saveRDS(outcomes_sce, paste0(save_dir, "/outcomes_scenarios_",Sys.Date(),".rds"))









