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
prep_start <- 0.5 * year_steps
source("R/netsim_settings.R", local = TRUE)
est      <- readRDS("data/intermediate/estimates/netest-local.rds")


#update param
param <- param.net(
  data.frame.params   = read.csv("data/input/params.csv"),
  netstats            = netstats,
  epistats            = epistats,
  prep.start          = prep_start,
  riskh.start         = prep_start - year_steps - 1,

  #newly added
  sexstigma.memdist = c(0.119, 0.133, 0.336, 0.412),

  mddcoef.stigma = c(5.947530777, 2.348486854, 2.687909524, 1),
  mddcoef.race = c(1.066135463, 1.446118104, 1),
  mddcoef.hiv = c(1, 1.086847192),

  mde.start.prob = c(0.33, 0.47),                  #mde start prob of 33% in hiv- and 47% in hiv+
  mde.symsevgrp.dist = c(0.105, 0.386, 0.380, 0.129),
  mde.sevimp.symgrp.dist = c(0.196, 0.415, 0.773, 0.90),
  mde.spontres.int  = c(15.3, 13.8, 16.6, 23.1),    #median num of weeks to mde resolution (by symptom severity group)
  mde.recurr.int  = c(30/7 * 19, 30/7 * 32.9),    #median well interval untreated and treated (19 mos/ 32.9 mos)


  mdd.diag.gen.prob = c(0.47, 0.45),               #prob of diagnosis hiv neg/hiv pos
  mdd.diag.prep.prob = 0,

  mdd.txinit.prob = c(0.397, 0.336, 0.540),
  mde.txremiss.prob = 0.65,
  mdd.txltfu.prob = 0.145,

  mdd.suitry.prob = 0.068,
  mdd.suicompl.prob = 0.0322

)
#print(param)

#control
pkgload::load_all("C:/Users/Uonwubi/OneDrive - Emory University/Desktop/Personal/RSPH EPI Docs/RA2/GitRepos/EpiModelHIV-p")
control <- control_msm(
  nsteps = prep_start + year_steps * 5.5
); #print(control)



# Epidemic simulation (1 sim interactive) ------------------------------------------------
#debug(initialize_msm)
#debug(arrival_msm)
#debug(mddassign_msm)
#debug(mde_msm)
#debug(mddcare_msm)
#debug(mddsuitry_msm)
sim <- netsim(est, param, init, control)
#undebug(initialize_msm)
#undebug(arrival_msm)
#undebug(mddassign_msm)
#undebug(mde_msm)
#undebug(mddcare_msm)
#undebug(mddsuitry_msm)


#convert sim object to df
df <- as.data.frame(sim)

output_dir <- "C:/Users/Uonwubi/OneDrive - Emory University/Desktop/Personal/RSPH EPI Docs/RA2/GitRepos/StigmaDepressionHIV_real/data/output/local"
saveRDS(df, paste0(output_dir,"/df.rds"))


#Examine epi measures in sim object
print(sim) # Examine the model object output

#plots
par(mar = c(3, 3, 2, 2), mgp = c(2, 1, 0))
# plot(sim, y = "i.num", main = "Prevalence")
# plot(sim, y = "ir100", main = "Incidence")
plot(sim, y = c("stigma.1.prpall",
                "stigma.2.prpall",
                "stigma.3.prpall",
                "stigma.4.prpall"),
     main = "sex stigma memberships")

plot(sim, y = c("stigma.1.prphiv1",
                "stigma.2.prphiv1",
                "stigma.3.prphiv1",
                "stigma.4.prphiv1"),
     main = "sex stigma memberships: hiv pos")

plot(sim, y = c("mdd.prpall", "mdd.prphiv1", "mdd.prphiv0"))

legend(x=1, y=0.20, legend=c("all", "hiv pos", "hiv neg"),
       col=c("black","red", "blue"), lty=1:3, cex=0.8)







# Define test scenarios
scenarios_df <- tibble(
  .scenario.id    = c("scenario_1", "scenario_2"),
  .at             = 1,
  hiv.test.rate_1 = c(0.004, 0.005),
  hiv.test.rate_2 = c(0.004, 0.005),
  hiv.test.rate_3 = c(0.007, 0.008)
)

glimpse(scenarios_df)
scenarios_list <- EpiModel::create_scenario_list(scenarios_df)

# Here 2 scenarios will be used "scenario_1" and "scenario_2".
# This will generate 6 files (3 per scenarios)
EpiModelHPC::netsim_scenarios(
  path_to_est, param, init, control,
  scenarios_list = scenarios_list, # set to NULL to run with default params
  n_rep = 3,
  n_cores = 2,
  output_dir = scenarios_dir,
  save_pattern = "all"
)
fs::dir_ls(sc_test_dir)

# merge the simulations. Keeping one `tibble` per scenario
EpiModelHPC::merge_netsim_scenarios_tibble(
  sim_dir = sc_test_dir,
  output_dir = fs::path(scenarios_dir, "merged_tibbles"),
  steps_to_keep = year_steps * 1
)
