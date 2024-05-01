## 1. Epidemic Model Scenarios Playground
##
## Run `netsim` via the scenario API. This mimics how things will be run on the
## HPC later on and ensure a smooth transition to the HPC setup.
##
## This script only runs the simulation. The outputs are explored in the script
## 2-scenarios_assess.R

# Restart R before running this script (Ctrl_Shift_F10 / Cmd_Shift_0)




# Setup 1 (environment) ------------------------------------------------------------------------
library(EpiModelHIV)
library(dplyr)

source("R/shared_variables.R", local = TRUE)
source("R/C-netsim_scenarios/z-context.R", local = TRUE)




# Setup (model setup) ----------------------------------------------------------------------
#get epistats, netstats, param, init & time settings
prep_start <- 1 * year_steps
source("R/netsim_settings.R", local = TRUE)
est      <- readRDS("data/intermediate/estimates/netest-local.rds")


#update param
param <- param.net(
  data.frame.params   = read.csv("data/input/params.csv"),
  netstats            = netstats,
  epistats            = epistats,
  prep.start          = prep_start,
  riskh.start         = prep_start, # - year_steps - 1,
  part.ident.start    = prep_start,

  #newly added
  sexstigma.memdist = c(0.119, 0.133, 0.336, 0.412),

  mddcoef.stigma = c(5.947530777, 2.348486854, 2.687909524, 1),
  mddcoef.race = c(1.066135463, 1.446118104, 1),
  mddcoef.hiv = c(1, 1.086847192),

  mde.start.prob = c(0.33, 0.47),                   #mde start prob of 33% in hiv- and 47% in hiv+
  mde.symsevgrp.dist = c(0.104, 0.386, 0.380, 0.129),
  mde.sevimp.symgrp.dist = c(0.196, 0.415, 0.773, 0.90),
  mde.spontres.int  = c(13.8, 15.3, 16.6, 23.1),    #median num of weeks to mde resolution (by symptom severity group)
  mde.recurr.int  = c(76, 131.6),                   #median well interval untreated and treated (19 mos/ 32.9 mos)

  mdd.diag.gen.prob = c(0.47, 0.45),                #prob of diagnosis hiv neg/hiv pos
  mdd.txinit.prob.reg = c(0.397, 0.336, 0.540),
  mdd.txinit.prob.prep = c(0.397, 0.336, 0.540),
  mde.txremiss.prob = 0.65,
  mdd.txltfu.prob = 0.145,

  mdd.suitry.prob = 0.068,
  mdd.suicompl.prob = 0.0322,

  mhefx.start = 0, #Inf,
  ai.rate.mult = c(1, 1.5, 2, 0.5),                #turned up by a factor of ...
  cond.prob.mult = c(1, 2, 8, 4),                  #turned down by a factor of ...
  stigma.hivtest.mult = c(1, 0.975, 1.022, 1),
  minadeq_txdur = 4,
  stigcounse_efxdur = 4 * 6,                       #effects of stigma interv post discontinuation
  txinit.rate.mult = c(1, 0.84),
  txhalt.rate.mult = c(1, 1.39),
  prepinit.prob.mult = c(0.65, 0.60, 0.88, 0.81, 1, 0.86, 1.16, 1),
  prephalt.prob.mult = c(1, 1.12),

  mh.scrninterv.start = 0, #Inf,
  mddscrnuptk.pstat.prob = 0,                       #mdd screening uptake prob among prep starters
  mddscrnuptk.pind.prob = 0.5,                      #mdd screening uptake prob among all with prep indications

  mh.txinterv.start = 0,
  mh.stigtxefx.prepinit = 1.5,
  mh.stigtxefx.prephalt = 0.5,
  mh.stigtxefx.hivtst = 1.5,
  mh.stigtxefx.uai = 0.5,
)
#print(param)

#control
# pkgload::load_all("C:/Users/Uonwubi/OneDrive - Emory University/Desktop/Personal/RSPH EPI Docs/RA2/GitRepos/EpiModelHIV-p")
control <- control_msm(
  nsteps = prep_start + year_steps * 10 #intervention_start + 10 * year_steps
); #print(control)



# Epidemic simulation (1 sim interactive) ------------------------------------------------
#debug(initialize_msm)
#debug(arrival_msm)
#debug(mddassign_msm)
#debug(mde_msm)
#debug(mddcare_msm)
#debug(mddsuitry_msm)
#debug(departure_msm)
#debug(condoms_msm)
#debug(acts_msm)
#debug(hivtest_msm)
#debug(hivtx_msm)
#debug(hivtrans_msm)
#debug(prevalence_msm)
#debug(prep_msm)
#debug(partident_msm)
sim <- netsim(est, param, init, control)
#undebug(initialize_msm)
#undebug(arrival_msm)
#undebug(mddassign_msm)
#undebug(mde_msm)
#undebug(mddcare_msm)
#undebug(mddsuitry_msm)
#undebug(departure_msm)
#undebug(condoms_msm)
#undebug(acts_msm)
#undebug(hivtest_msm)
#undebug(hivtx_msm)
#undebug(hivtrans_msm)
#undebug(prevalence_msm)
#undebug(prep_msm)
#undebug(partident_msm)


# #convert sim object to df
# df <- as.data.frame(sim)
#
# output_dir <- "C:/Users/Uonwubi/OneDrive - Emory University/Desktop/Personal/RSPH EPI Docs/RA2/GitRepos/StigmaDepressionHIV_real/data/output/local"
# saveRDS(df, paste0(output_dir,"/df.rds"))
df <- as.data.frame(sim)
sims_dir <- paste0("C:/Users/Uonwubi/OneDrive - Emory University/Desktop/Personal/RSPH EPI Docs/RA2/GitRepos/StigmaDepressionHIV_real/data/intermediate/scenarios")


#saveRDS(df, paste0(sims_dir,"/sim__sc1_base__1.rds"))
#
#saveRDS(df, paste0(sims_dir,"/sim__sc2_efxall__1.rds"))
#
# saveRDS(df, paste0(sims_dir,"/sim__sc3_scrn1__1.rds"))
#
#saveRDS(df, paste0(sims_dir,"/sim__sc4_scrn2__1.rds"))
#
saveRDS(df, paste0(sims_dir,"/sim__sc8_txinterv__1.rds"))



# Epidemic simulation (> 1 sim) ----------------------------------------------------------
# Define test scenarios
scenarios_df <- tibble(
  .scenario.id    = c("sc0_base", "sc1_scrn1", "sc2_scrn2", "sc3_txinterv1", "sc4_txinterv2"),
  .at             = 0,
  mhefx.start              = c(1,    1,    1,    1,   1),
  mh.scrninterv.start      = c(Inf,  1,    1,    1,   1),
  mddscrnuptk.pstat.prob   = c(0,    0.5,  0,    0,   0),
  mddscrnuptk.pind.prob    = c(0,    0,    0.5,  0.5, 0.5),
  mh.txinterv.start        = c(Inf,  Inf,  Inf,  1,   1),
  mh.stigtxefx.prepinit    = c(0,    0,    0,    1.5, 2),
  mh.stigtxefx.prephalt    = c(0,    0,    0,    0.5, 0.125),
  mh.stigtxefx.hivtst      = c(0,    0,    0,    1.5, 2),
  mh.stigtxefx.uai         = c(0,    0,    0,    0.5, 0.125)
)

glimpse(scenarios_df)
scenarios_list <- EpiModel::create_scenario_list(scenarios_df)

# Here scenarios are being used (4 scenarios)
# This will generate 4 scenarios * num of sims files
EpiModelHPC::netsim_scenarios(
  path_to_est, param, init, control,
  scenarios_list = scenarios_list, # set to NULL to run with default params
  n_rep = 5,
  n_cores = 5,
  output_dir = scenarios_dir,
  save_pattern = "all"
)
#fs::dir_ls(sc_test_dir)
#list.files("data/intermediate/scenarios")


# # merge the simulations. Keeping one `tibble` per scenario
# EpiModelHPC::merge_netsim_scenarios_tibble(
#   sim_dir = scenarios_dir,
#   output_dir = fs::path(scenarios_dir, "merged_tibbles"),
#   steps_to_keep = year_steps * 6
# )



#process sim files
source("R/C-netsim_scenarios/3.0-functions_scenarios_process.R")

sims_dir <- paste0("data/intermediate/scenarios")
save_dir <- paste0("data/output/local")

#get batch info
batches_infos <- EpiModelHPC::get_scenarios_batches_infos(
  paste0("data/intermediate/scenarios")
)


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
  ts = 0 #3901 - (5 * 52) + 1   #gets all data (only 6 years of model run)
)


#Merge all batches
alldata <- bind_rows(intervds)
saveRDS(alldata, paste0(save_dir, "/alldata_",Sys.Date(),".rds"))


#get sim-level results
outcomes_sims <- get_outcome_sims(alldata) %>%
  select(tbl, scenario.num, scenario.new, scenario_name, sim,

         #Distal impacts: HIV incidence measures
         incid.cum, incid.yr10, ir100.yr10,

         incid.mdd0.cum, incid.mdd0.yr10, mdd.ir100.0.yr10,
         incid.mdd1.cum, incid.mdd1.yr10, mdd.ir100.1.yr10,

         incid.stigma1.cum, incid.stigma1.yr10, stigma.ir100.1.yr10,
         incid.stigma2.cum, incid.stigma2.yr10, stigma.ir100.2.yr10,
         incid.stigma3.cum, incid.stigma3.yr10, stigma.ir100.3.yr10,
         incid.stigma4.cum, incid.stigma4.yr10, stigma.ir100.4.yr10,


         #Intermediate impacts: PrEP & ART coverage
         #PrEP
         prepElig, prepCurr, prepCov,
         prepCov.mdd0, prepCov.mdd1,
         prepCov.stigma1, prepCov.stigma2, prepCov.stigma3, prepCov.stigma4,

         #ART
         i.num, hivdiag, hivdiagCov.yr10,
         hivdiagCov.mdd0.yr10, hivdiagCov.mdd1.yr10,
         hivdiagCov.stigma1.yr10, hivdiagCov.stigma2.yr10, hivdiagCov.stigma3.yr10, hivdiagCov.stigma4.yr10,

         artCurr, artCov.yr10,
         artCov.mdd0.yr10, artCov.mdd1.yr10,
         artCov.stigma1.yr10, artCov.stigma2.yr10, artCov.stigma3.yr10, artCov.stigma4.yr10,

         vSupp, vSuppCov.yr10,


         #Proximal measures: stigma & mde cascade
         #stigma-related
         stigma.1.prphiv1, stigma.2.prphiv1, stigma.3.prphiv1, stigma.4.prphiv1,
         stigma.1.prphiv0, stigma.2.prphiv0, stigma.3.prphiv0, stigma.4.prphiv0,

         #mdd-related
         mdd.prpall,
         mdd.prphiv1, mdd.prphiv0,
         mdd.prpstigma1, mdd.prpstigma2, mdd.prpstigma3, mdd.prpstigma4,
         mdd.prprace1, mdd.prprace2, mdd.prprace3,

         #mde-related
         mde.ever.prpmdd,
         mde.ever.prpmddhiv0, mde.ever.prpmddhiv1,
         mde.active.prpmdd,

         mde.start.numall,
         mde.start.new.numall, mde.start.recurr.numall,

         mde.stop.numall,
         mde.stop.numspontres, mde.stop.numtxremiss, mde.stop.numendmainte, mde.stop.numdth,
         mde.epidur.median, mde.epidur.max,

         mde.active.numall, mde.active.prpmdd,

         #mdd care-related
         mdd.diagever.prpmddall,
         mdd.diagever.prpmddhiv0, mdd.diagever.prpmddhiv1,

         mdd.eligdiagat.numgen, mdd.diagat.numgen,
         mdd.eligdiagat.numprep, mdd.diagat.numprep,
         mdd.diagat.numall,

         mdd.eligtxstart.numall, mdd.txstart.numall,
         mdd.txstart.prpofeverdiag, mdd.txstart.prpofactivemde, mdd.txstart.prpofactivemdediag,
         mdd.txstart.prpeverdiag.race1, mdd.txstart.prpeverdiag.race2, mdd.txstart.prpeverdiag.race3,

         mdd.txstop.numall, mdd.txstop.numremiss, mdd.txstop.numendmainte, mdd.txstop.numltfu, mdd.txstop.numdth,


         #suicide-related
         mdd.eligsuitry.numall, mdd.suitry.numall,
         mdd.suitry.numhiv0, mdd.suitry.numhiv1,
         mdd.suitry.numsev1, mdd.suitry.numsev2, mdd.suitry.numsev3, mdd.suitry.numsev4,
         mdd.suitry.nummed, mdd.suitry.nummax,

         mdd.eligsuicompl.numall, mdd.suicompl.numall, mdd.suicompl.prpdepall,


         #Proximal impacts - HIV transmission dynamics & services engagement
         #hiv trans dynamics
         mdd.ai.numall,
         mdd.ai.totmain, mdd.ai.totcas, mdd.ai.totoof,
         mdd.ai.totcas.sev1, mdd.ai.totcas.sev2, mdd.ai.totcas.sev3, mdd.ai.totcas.sev4,

         mdd.uai.numall,
         mdd.uai.totmain, mdd.uai.totcas, mdd.uai.totoof,
         mdd.uai.totcasoof.sev1, mdd.uai.totcasoof.sev2, mdd.uai.totcasoof.sev3, mdd.uai.totcasoof.sev4,

         #hiv screening
         tot.tests,
         tot.tests.ibt, tot.tests.pbt,

         #hiv tx
         all.init.tx,
         elig.gen.start.tx, gen.start.tx,
         elig.part.start.tx, part.start.tx,

         all.reinit.tx,
         gen.elig.for.reinit, gen.reinit.tx,
         part.elig.for.reinit, part.reinit.tx,

         txStop,

         #prep
         elig.prepStartGen, prepStartGen,
         elig.prepStartPart, prepStartPart,

         prep.all.stop, prep.rand.stop
  )
saveRDS(outcomes_sims, paste0(save_dir, "/outcomes_sims_",Sys.Date(),".rds"))


#scenario-level results
outcomes_sce <- outcomes_sims %>%
  select(- c(sim)) %>%
  group_by(tbl, scenario.num, scenario.new, scenario_name) %>%
  summarise(across(everything(),list(
    ll = ~ quantile(.x, 0.025, na.rm = TRUE),
    med = ~ quantile(.x, 0.50, na.rm = TRUE),
    ul = ~ quantile(.x, 0.975, na.rm = TRUE)
  ),
  .names = "{.col}__{.fn}"
  )) %>%
  mutate(across(where(is.numeric), ~round (., 3))) %>% ungroup()%>%
  arrange(tbl, scenario.num, scenario.new, scenario_name)
saveRDS(outcomes_sce, paste0(save_dir, "/outcomes_scenarios_",Sys.Date(),".rds"))
