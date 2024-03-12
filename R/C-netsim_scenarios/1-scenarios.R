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
prep_start <- 2 * year_steps
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
  mddcoef.hiv = c(1, 1.086847192)

)
#print(param)

#control
pkgload::load_all("C:/Users/Uonwubi/OneDrive - Emory University/Desktop/Personal/RSPH EPI Docs/RA2/GitRepos/EpiModelHIV-p")
control <- control_msm(
  nsteps = prep_start + year_steps * 1
); #print(control)



# Epidemic simulation (1 sim interactive) ------------------------------------------------
#debug(initialize_msm)
#debug(arrival_msm)
#debug(mdd_msm)
sim <- netsim(est, param, init, control)
#undebug(initialize_msm)
#undebug(arrival_msm)
#undebug(mdd_msm)



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


#convert to df
df <- as.data.frame(sim)

output_dir <- "C:/Users/Uonwubi/OneDrive - Emory University/Desktop/Personal/RSPH EPI Docs/RA2/GitRepos/StigmaDepressionHIV_real/data/output/local"
saveRDS(df, paste0(output_dir,"/df.rds"))





#Old script
# #param
# param <- param.net(
#   data.frame.params = readr::read_csv("data/input/params.csv"),
#   netstats          = netstats,
#   epistats          = epistats,
#   prep.start        = prep_start,
#   riskh.start       = prep_start - 53,
#
#   #missing params in csv DOC
#   #sti epi
#   gc.ntx.int = 16.8,
#   gc.tx.int = 1.4,
#   ct.ntx.int = 32,
#   ct.tx.int = 1.4,
#
#   # STI Screening
#   sti.screening.dist = "stochastic",
#   gc.screen.hivneg.rate = 1 / 123,
#   gc.screen.hivpos.rate = 1 / 67,
#   ct.screen.hivneg.rate = 1 / 123,
#   ct.screen.hivpos.rate = 1 / 67,
#   sti.screen.prep.rate = 1 / 13,
#   sti.screen.prep.start = 1,
#   sti.screen.rect.hivneg.prob = 0.48,
#   sti.screen.rect.hivpos.prob = 0.63,
#   sti.screen.rect.prep.prob = 1,
#   gc.dx.window = 0,
#   gc.dx.threshold = Inf,
#   ct.dx.window = 0,
#   ct.dx.threshold = Inf,
#
#   #PrEP
#   sti.prep.tx.prob = 1,
#
#   sexstigma.mem.dist = c(0.119, 0.133, 0.336, 0.412)
# )
# # # See full listing of parameters
# # # See ?param_msm for definitions
# # print(param)


# # Control settings
# control <- control_msm(
#   nsteps = 250,
#   nsims = 1,
#   ncores = 1
# )
#See listing of modules and other control settings. Module function defaults defined in ?control_msm
#print(control)











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
