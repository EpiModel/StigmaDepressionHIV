## HPC Workflow: Epidemic Model Scenarios Playground
##
## Define a workflow to run `netsim` via the scenario API on the HPC

# Restart R before running this script (Ctrl_Shift_F10 / Cmd_Shift_0)


# Setup ------------------------------------------------------------------------
library(slurmworkflow)
library(EpiModelHPC)
library(EpiModelHIV)
library(dplyr)


hpc_context <- TRUE



source("R/shared_variables.R", local = TRUE)
source("R/C-netsim_scenarios/z-context.R", local = TRUE)
source("R/hpc_configs.R", local = TRUE)


max_cores <- 32
numsims <- 16 * max_cores
nsteps <- intervention_end



# Process ----------------------------------------------------------------------
#wf <- make_em_workflow("networks", override = TRUE)


# Necessary files
#prep_start <- 2 * year_steps
source("R/netsim_settings.R", local = TRUE)


#Control settings
control <- control_msm(
  nsteps = nsteps
)


#Create workflow
wf <- make_em_workflow("mddtbl3", override = TRUE)



#Table 3A ----------------------------------------------------------------------
# # ~~~~~~~~~~~~~~~~~~~~~~  part 1
# scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl3A01.csv")
# scenarios_list <- EpiModel::create_scenario_list(scenarios_df)
#
# # HIV epidemic simulation
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_netsim_scenarios(
#     path_to_est, param, init, control,
#     scenarios_list = scenarios_list,
#     output_dir = "data/intermediate/scenarios_mddtbl3/rawsims",
#     save_pattern = "all",
#     n_rep = numsims,
#     n_cores = max_cores,
#     max_array_size = 500,
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "mail-type" = "FAIL,TIME_LIMIT,END",
#     "cpus-per-task" = max_cores,
#     "time" = "04:00:00",
#     "mem-per-cpu" = "5G"
#   )
#  )
#
# # reduce sim files (also removes raw sim files)
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_do_call_script(
#     r_script = "R/C-netsim_scenarios/53.1-reducesim_mddtbl3.R",
#     args = list(
#       ncores = max_cores,
#       nsteps = 52
#     ),
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "cpus-per-task" = max_cores,
#     "time" = "08:00:00",
#     "mem-per-cpu" = "4G",
#     "mail-type" = "FAIL,END"
#   )
# )
#
# # process output (also removes reduced sim files except 001)
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_do_call_script(
#     r_script = "R/C-netsim_scenarios/53.2-processsims_mddtbl3.R",
#     args = list(
#       ncores = max_cores,
#       nsteps = 52
#     ),
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "cpus-per-task" = max_cores,
#     "time" = "08:00:00",
#     "mem-per-cpu" = "4G",
#     "mail-type" = "FAIL,END"
#   )
# )
#
#
#
# # ~~~~~~~~~~~~~~~~~~~~~~  part 2
# scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl3A02.csv")
# scenarios_list <- EpiModel::create_scenario_list(scenarios_df)
#
# # HIV epidemic simulation
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_netsim_scenarios(
#     path_to_est, param, init, control,
#     scenarios_list = scenarios_list,
#     output_dir = "data/intermediate/scenarios_mddtbl3/rawsims",
#     save_pattern = "all",
#     n_rep = numsims,
#     n_cores = max_cores,
#     max_array_size = 500,
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "mail-type" = "FAIL,TIME_LIMIT,END",
#     "cpus-per-task" = max_cores,
#     "time" = "04:00:00",
#     "mem-per-cpu" = "5G"
#   )
# )
#
# # reduce sim files (also removes raw sim files)
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_do_call_script(
#     r_script = "R/C-netsim_scenarios/53.1-reducesim_mddtbl3.R",
#     args = list(
#       ncores = max_cores,
#       nsteps = 52
#     ),
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "cpus-per-task" = max_cores,
#     "time" = "08:00:00",
#     "mem-per-cpu" = "4G",
#     "mail-type" = "FAIL,END"
#   )
# )
#
# # process output (also removes reduced sim files except 001)
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_do_call_script(
#     r_script = "R/C-netsim_scenarios/53.2-processsims_mddtbl3.R",
#     args = list(
#       ncores = max_cores,
#       nsteps = 52
#     ),
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "cpus-per-task" = max_cores,
#     "time" = "08:00:00",
#     "mem-per-cpu" = "4G",
#     "mail-type" = "FAIL,END"
#   )
# )
#
#
#
# # ~~~~~~~~~~~~~~~~~~~~~~  part 3
# scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl3A03.csv")
# scenarios_list <- EpiModel::create_scenario_list(scenarios_df)
#
# # HIV epidemic simulation
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_netsim_scenarios(
#     path_to_est, param, init, control,
#     scenarios_list = scenarios_list,
#     output_dir = "data/intermediate/scenarios_mddtbl3/rawsims",
#     save_pattern = "all",
#     n_rep = numsims,
#     n_cores = max_cores,
#     max_array_size = 500,
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "mail-type" = "FAIL,TIME_LIMIT,END",
#     "cpus-per-task" = max_cores,
#     "time" = "04:00:00",
#     "mem-per-cpu" = "5G"
#   )
# )
#
# # reduce sim files (also removes raw sim files)
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_do_call_script(
#     r_script = "R/C-netsim_scenarios/53.1-reducesim_mddtbl3.R",
#     args = list(
#       ncores = max_cores,
#       nsteps = 52
#     ),
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "cpus-per-task" = max_cores,
#     "time" = "08:00:00",
#     "mem-per-cpu" = "4G",
#     "mail-type" = "FAIL,END"
#   )
# )
#
# # process output (also removes reduced sim files except 001)
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_do_call_script(
#     r_script = "R/C-netsim_scenarios/53.2-processsims_mddtbl3.R",
#     args = list(
#       ncores = max_cores,
#       nsteps = 52
#     ),
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "cpus-per-task" = max_cores,
#     "time" = "08:00:00",
#     "mem-per-cpu" = "4G",
#     "mail-type" = "FAIL,END"
#   )
# )
#
#
#
# # ~~~~~~~~~~~~~~~~~~~~~~  part 4
# scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl3A04.csv")
# scenarios_list <- EpiModel::create_scenario_list(scenarios_df)
#
# # HIV epidemic simulation
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_netsim_scenarios(
#     path_to_est, param, init, control,
#     scenarios_list = scenarios_list,
#     output_dir = "data/intermediate/scenarios_mddtbl3/rawsims",
#     save_pattern = "all",
#     n_rep = numsims,
#     n_cores = max_cores,
#     max_array_size = 500,
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "mail-type" = "FAIL,TIME_LIMIT,END",
#     "cpus-per-task" = max_cores,
#     "time" = "04:00:00",
#     "mem-per-cpu" = "5G"
#   )
# )
#
# # reduce sim files (also removes raw sim files)
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_do_call_script(
#     r_script = "R/C-netsim_scenarios/53.1-reducesim_mddtbl3.R",
#     args = list(
#       ncores = max_cores,
#       nsteps = 52
#     ),
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "cpus-per-task" = max_cores,
#     "time" = "08:00:00",
#     "mem-per-cpu" = "4G",
#     "mail-type" = "FAIL,END"
#   )
# )
#
# # process output (also removes reduced sim files except 001)
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_do_call_script(
#     r_script = "R/C-netsim_scenarios/53.2-processsims_mddtbl3.R",
#     args = list(
#       ncores = max_cores,
#       nsteps = 52
#     ),
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "cpus-per-task" = max_cores,
#     "time" = "08:00:00",
#     "mem-per-cpu" = "4G",
#     "mail-type" = "FAIL,END"
#   )
# )
#
#
#
# # *******************clear ALL Sim files (prior to starting next interv model table run)
# # *******************
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_do_call_script(
#     r_script = "R/C-netsim_scenarios/53.4-removefiles_AllSims_mddtbl3.R",
#     args = list(
#       ncores = max_cores),
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "cpus-per-task" = max_cores,
#     "time" = "08:00:00",
#     "mem-per-cpu" = "4G",
#     "mail-type" = "FAIL,END"
#   )
# )
# # *************************************************
# # *************************************************
#
#
#
# #Table 3B ----------------------------------------------------------------------
# # ~~~~~~~~~~~~~~~~~~~~~~  part 1
# scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl3B01.csv")
# scenarios_list <- EpiModel::create_scenario_list(scenarios_df)
#
# # HIV epidemic simulation
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_netsim_scenarios(
#     path_to_est, param, init, control,
#     scenarios_list = scenarios_list,
#     output_dir = "data/intermediate/scenarios_mddtbl3/rawsims",
#     save_pattern = "all",
#     n_rep = numsims,
#     n_cores = max_cores,
#     max_array_size = 500,
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "mail-type" = "FAIL,TIME_LIMIT,END",
#     "cpus-per-task" = max_cores,
#     "time" = "04:00:00",
#     "mem-per-cpu" = "5G"
#   )
# )
#
# # reduce sim files (also removes raw sim files)
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_do_call_script(
#     r_script = "R/C-netsim_scenarios/53.1-reducesim_mddtbl3.R",
#     args = list(
#       ncores = max_cores,
#       nsteps = 52
#     ),
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "cpus-per-task" = max_cores,
#     "time" = "08:00:00",
#     "mem-per-cpu" = "4G",
#     "mail-type" = "FAIL,END"
#   )
# )
#
# # process output (also removes reduced sim files except 001)
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_do_call_script(
#     r_script = "R/C-netsim_scenarios/53.2-processsims_mddtbl3.R",
#     args = list(
#       ncores = max_cores,
#       nsteps = 52
#     ),
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "cpus-per-task" = max_cores,
#     "time" = "08:00:00",
#     "mem-per-cpu" = "4G",
#     "mail-type" = "FAIL,END"
#   )
# )
#
#
#
# # ~~~~~~~~~~~~~~~~~~~~~~  part 2
# scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl3B02.csv")
# scenarios_list <- EpiModel::create_scenario_list(scenarios_df)
#
# # HIV epidemic simulation
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_netsim_scenarios(
#     path_to_est, param, init, control,
#     scenarios_list = scenarios_list,
#     output_dir = "data/intermediate/scenarios_mddtbl3/rawsims",
#     save_pattern = "all",
#     n_rep = numsims,
#     n_cores = max_cores,
#     max_array_size = 500,
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "mail-type" = "FAIL,TIME_LIMIT,END",
#     "cpus-per-task" = max_cores,
#     "time" = "04:00:00",
#     "mem-per-cpu" = "5G"
#   )
# )
#
# # reduce sim files (also removes raw sim files)
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_do_call_script(
#     r_script = "R/C-netsim_scenarios/53.1-reducesim_mddtbl3.R",
#     args = list(
#       ncores = max_cores,
#       nsteps = 52
#     ),
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "cpus-per-task" = max_cores,
#     "time" = "08:00:00",
#     "mem-per-cpu" = "4G",
#     "mail-type" = "FAIL,END"
#   )
# )
#
# # process output (also removes reduced sim files except 001)
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_do_call_script(
#     r_script = "R/C-netsim_scenarios/53.2-processsims_mddtbl3.R",
#     args = list(
#       ncores = max_cores,
#       nsteps = 52
#     ),
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "cpus-per-task" = max_cores,
#     "time" = "08:00:00",
#     "mem-per-cpu" = "4G",
#     "mail-type" = "FAIL,END"
#   )
# )
#
#
#
# # ~~~~~~~~~~~~~~~~~~~~~~  part 3
# scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl3B03.csv")
# scenarios_list <- EpiModel::create_scenario_list(scenarios_df)
#
# # HIV epidemic simulation
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_netsim_scenarios(
#     path_to_est, param, init, control,
#     scenarios_list = scenarios_list,
#     output_dir = "data/intermediate/scenarios_mddtbl3/rawsims",
#     save_pattern = "all",
#     n_rep = numsims,
#     n_cores = max_cores,
#     max_array_size = 500,
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "mail-type" = "FAIL,TIME_LIMIT,END",
#     "cpus-per-task" = max_cores,
#     "time" = "04:00:00",
#     "mem-per-cpu" = "5G"
#   )
# )
#
# # reduce sim files (also removes raw sim files)
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_do_call_script(
#     r_script = "R/C-netsim_scenarios/53.1-reducesim_mddtbl3.R",
#     args = list(
#       ncores = max_cores,
#       nsteps = 52
#     ),
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "cpus-per-task" = max_cores,
#     "time" = "08:00:00",
#     "mem-per-cpu" = "4G",
#     "mail-type" = "FAIL,END"
#   )
# )
#
# # process output (also removes reduced sim files except 001)
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_do_call_script(
#     r_script = "R/C-netsim_scenarios/53.2-processsims_mddtbl3.R",
#     args = list(
#       ncores = max_cores,
#       nsteps = 52
#     ),
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "cpus-per-task" = max_cores,
#     "time" = "08:00:00",
#     "mem-per-cpu" = "4G",
#     "mail-type" = "FAIL,END"
#   )
# )
#
#
#
# # ~~~~~~~~~~~~~~~~~~~~~~  part 4
# scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl3B04.csv")
# scenarios_list <- EpiModel::create_scenario_list(scenarios_df)
#
# # HIV epidemic simulation
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_netsim_scenarios(
#     path_to_est, param, init, control,
#     scenarios_list = scenarios_list,
#     output_dir = "data/intermediate/scenarios_mddtbl3/rawsims",
#     save_pattern = "all",
#     n_rep = numsims,
#     n_cores = max_cores,
#     max_array_size = 500,
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "mail-type" = "FAIL,TIME_LIMIT,END",
#     "cpus-per-task" = max_cores,
#     "time" = "04:00:00",
#     "mem-per-cpu" = "5G"
#   )
# )
#
# # reduce sim files (also removes raw sim files)
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_do_call_script(
#     r_script = "R/C-netsim_scenarios/53.1-reducesim_mddtbl3.R",
#     args = list(
#       ncores = max_cores,
#       nsteps = 52
#     ),
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "cpus-per-task" = max_cores,
#     "time" = "08:00:00",
#     "mem-per-cpu" = "4G",
#     "mail-type" = "FAIL,END"
#   )
# )
#
# # process output (also removes reduced sim files except 001)
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_do_call_script(
#     r_script = "R/C-netsim_scenarios/53.2-processsims_mddtbl3.R",
#     args = list(
#       ncores = max_cores,
#       nsteps = 52
#     ),
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "cpus-per-task" = max_cores,
#     "time" = "08:00:00",
#     "mem-per-cpu" = "4G",
#     "mail-type" = "FAIL,END"
#   )
# )
#
#
#
# # *******************clear ALL Sim files (prior to starting next interv model table run)
# # *******************
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_do_call_script(
#     r_script = "R/C-netsim_scenarios/53.4-removefiles_AllSims_mddtbl3.R",
#     args = list(
#       ncores = max_cores),
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "cpus-per-task" = max_cores,
#     "time" = "08:00:00",
#     "mem-per-cpu" = "4G",
#     "mail-type" = "FAIL,END"
#   )
# )
# # *************************************************
# # *************************************************
#
#
#
#
# #Table 3C ----------------------------------------------------------------------
# # ~~~~~~~~~~~~~~~~~~~~~~  part 1
# scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl3C01.csv")
# scenarios_list <- EpiModel::create_scenario_list(scenarios_df)
#
# # HIV epidemic simulation
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_netsim_scenarios(
#     path_to_est, param, init, control,
#     scenarios_list = scenarios_list,
#     output_dir = "data/intermediate/scenarios_mddtbl3/rawsims",
#     save_pattern = "all",
#     n_rep = numsims,
#     n_cores = max_cores,
#     max_array_size = 500,
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "mail-type" = "FAIL,TIME_LIMIT,END",
#     "cpus-per-task" = max_cores,
#     "time" = "04:00:00",
#     "mem-per-cpu" = "5G"
#   )
# )
#
# # reduce sim files (also removes raw sim files)
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_do_call_script(
#     r_script = "R/C-netsim_scenarios/53.1-reducesim_mddtbl3.R",
#     args = list(
#       ncores = max_cores,
#       nsteps = 52
#     ),
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "cpus-per-task" = max_cores,
#     "time" = "08:00:00",
#     "mem-per-cpu" = "4G",
#     "mail-type" = "FAIL,END"
#   )
# )
#
# # process output (also removes reduced sim files except 001)
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_do_call_script(
#     r_script = "R/C-netsim_scenarios/53.2-processsims_mddtbl3.R",
#     args = list(
#       ncores = max_cores,
#       nsteps = 52
#     ),
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "cpus-per-task" = max_cores,
#     "time" = "08:00:00",
#     "mem-per-cpu" = "4G",
#     "mail-type" = "FAIL,END"
#   )
# )
#
#
#
# # ~~~~~~~~~~~~~~~~~~~~~~  part 2
# scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl3C02.csv")
# scenarios_list <- EpiModel::create_scenario_list(scenarios_df)
#
# # HIV epidemic simulation
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_netsim_scenarios(
#     path_to_est, param, init, control,
#     scenarios_list = scenarios_list,
#     output_dir = "data/intermediate/scenarios_mddtbl3/rawsims",
#     save_pattern = "all",
#     n_rep = numsims,
#     n_cores = max_cores,
#     max_array_size = 500,
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "mail-type" = "FAIL,TIME_LIMIT,END",
#     "cpus-per-task" = max_cores,
#     "time" = "04:00:00",
#     "mem-per-cpu" = "5G"
#   )
# )
#
# # reduce sim files (also removes raw sim files)
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_do_call_script(
#     r_script = "R/C-netsim_scenarios/53.1-reducesim_mddtbl3.R",
#     args = list(
#       ncores = max_cores,
#       nsteps = 52
#     ),
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "cpus-per-task" = max_cores,
#     "time" = "08:00:00",
#     "mem-per-cpu" = "4G",
#     "mail-type" = "FAIL,END"
#   )
# )
#
# # process output (also removes reduced sim files except 001)
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_do_call_script(
#     r_script = "R/C-netsim_scenarios/53.2-processsims_mddtbl3.R",
#     args = list(
#       ncores = max_cores,
#       nsteps = 52
#     ),
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "cpus-per-task" = max_cores,
#     "time" = "08:00:00",
#     "mem-per-cpu" = "4G",
#     "mail-type" = "FAIL,END"
#   )
# )
#
#
#
# # ~~~~~~~~~~~~~~~~~~~~~~  part 3
# scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl3C03.csv")
# scenarios_list <- EpiModel::create_scenario_list(scenarios_df)
#
# # HIV epidemic simulation
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_netsim_scenarios(
#     path_to_est, param, init, control,
#     scenarios_list = scenarios_list,
#     output_dir = "data/intermediate/scenarios_mddtbl3/rawsims",
#     save_pattern = "all",
#     n_rep = numsims,
#     n_cores = max_cores,
#     max_array_size = 500,
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "mail-type" = "FAIL,TIME_LIMIT,END",
#     "cpus-per-task" = max_cores,
#     "time" = "04:00:00",
#     "mem-per-cpu" = "5G"
#   )
# )
#
# # reduce sim files (also removes raw sim files)
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_do_call_script(
#     r_script = "R/C-netsim_scenarios/53.1-reducesim_mddtbl3.R",
#     args = list(
#       ncores = max_cores,
#       nsteps = 52
#     ),
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "cpus-per-task" = max_cores,
#     "time" = "08:00:00",
#     "mem-per-cpu" = "4G",
#     "mail-type" = "FAIL,END"
#   )
# )
#
# # process output (also removes reduced sim files except 001)
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_do_call_script(
#     r_script = "R/C-netsim_scenarios/53.2-processsims_mddtbl3.R",
#     args = list(
#       ncores = max_cores,
#       nsteps = 52
#     ),
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "cpus-per-task" = max_cores,
#     "time" = "08:00:00",
#     "mem-per-cpu" = "4G",
#     "mail-type" = "FAIL,END"
#   )
# )
#
#
#
# # ~~~~~~~~~~~~~~~~~~~~~~  part 4
# scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl3C04.csv")
# scenarios_list <- EpiModel::create_scenario_list(scenarios_df)
#
# # HIV epidemic simulation
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_netsim_scenarios(
#     path_to_est, param, init, control,
#     scenarios_list = scenarios_list,
#     output_dir = "data/intermediate/scenarios_mddtbl3/rawsims",
#     save_pattern = "all",
#     n_rep = numsims,
#     n_cores = max_cores,
#     max_array_size = 500,
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "mail-type" = "FAIL,TIME_LIMIT,END",
#     "cpus-per-task" = max_cores,
#     "time" = "04:00:00",
#     "mem-per-cpu" = "5G"
#   )
# )
#
# # reduce sim files (also removes raw sim files)
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_do_call_script(
#     r_script = "R/C-netsim_scenarios/53.1-reducesim_mddtbl3.R",
#     args = list(
#       ncores = max_cores,
#       nsteps = 52
#     ),
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "cpus-per-task" = max_cores,
#     "time" = "08:00:00",
#     "mem-per-cpu" = "4G",
#     "mail-type" = "FAIL,END"
#   )
# )
#
# # process output (also removes reduced sim files except 001)
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_do_call_script(
#     r_script = "R/C-netsim_scenarios/53.2-processsims_mddtbl3.R",
#     args = list(
#       ncores = max_cores,
#       nsteps = 52
#     ),
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "cpus-per-task" = max_cores,
#     "time" = "08:00:00",
#     "mem-per-cpu" = "4G",
#     "mail-type" = "FAIL,END"
#   )
# )
#
#
#
# # *******************clear ALL Sim files (prior to starting next interv model table run)
# # *******************
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_do_call_script(
#     r_script = "R/C-netsim_scenarios/53.4-removefiles_AllSims_mddtbl3.R",
#     args = list(
#       ncores = max_cores),
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "cpus-per-task" = max_cores,
#     "time" = "08:00:00",
#     "mem-per-cpu" = "4G",
#     "mail-type" = "FAIL,END"
#   )
# )
# # *************************************************
# # *************************************************
#
#
#
# #Table 3D ----------------------------------------------------------------------
# # ~~~~~~~~~~~~~~~~~~~~~~  part 1
# scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl3D01.csv")
# scenarios_list <- EpiModel::create_scenario_list(scenarios_df)
#
# # HIV epidemic simulation
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_netsim_scenarios(
#     path_to_est, param, init, control,
#     scenarios_list = scenarios_list,
#     output_dir = "data/intermediate/scenarios_mddtbl3/rawsims",
#     save_pattern = "all",
#     n_rep = numsims,
#     n_cores = max_cores,
#     max_array_size = 500,
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "mail-type" = "FAIL,TIME_LIMIT,END",
#     "cpus-per-task" = max_cores,
#     "time" = "04:00:00",
#     "mem-per-cpu" = "5G"
#   )
# )
#
# # reduce sim files (also removes raw sim files)
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_do_call_script(
#     r_script = "R/C-netsim_scenarios/53.1-reducesim_mddtbl3.R",
#     args = list(
#       ncores = max_cores,
#       nsteps = 52
#     ),
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "cpus-per-task" = max_cores,
#     "time" = "08:00:00",
#     "mem-per-cpu" = "4G",
#     "mail-type" = "FAIL,END"
#   )
# )
#
# # process output (also removes reduced sim files except 001)
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_do_call_script(
#     r_script = "R/C-netsim_scenarios/53.2-processsims_mddtbl3.R",
#     args = list(
#       ncores = max_cores,
#       nsteps = 52
#     ),
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "cpus-per-task" = max_cores,
#     "time" = "08:00:00",
#     "mem-per-cpu" = "4G",
#     "mail-type" = "FAIL,END"
#   )
# )
#
#
#
# # ~~~~~~~~~~~~~~~~~~~~~~  part 2
# scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl3D02.csv")
# scenarios_list <- EpiModel::create_scenario_list(scenarios_df)
#
# # HIV epidemic simulation
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_netsim_scenarios(
#     path_to_est, param, init, control,
#     scenarios_list = scenarios_list,
#     output_dir = "data/intermediate/scenarios_mddtbl3/rawsims",
#     save_pattern = "all",
#     n_rep = numsims,
#     n_cores = max_cores,
#     max_array_size = 500,
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "mail-type" = "FAIL,TIME_LIMIT,END",
#     "cpus-per-task" = max_cores,
#     "time" = "04:00:00",
#     "mem-per-cpu" = "5G"
#   )
# )
#
# # reduce sim files (also removes raw sim files)
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_do_call_script(
#     r_script = "R/C-netsim_scenarios/53.1-reducesim_mddtbl3.R",
#     args = list(
#       ncores = max_cores,
#       nsteps = 52
#     ),
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "cpus-per-task" = max_cores,
#     "time" = "08:00:00",
#     "mem-per-cpu" = "4G",
#     "mail-type" = "FAIL,END"
#   )
# )
#
# # process output (also removes reduced sim files except 001)
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_do_call_script(
#     r_script = "R/C-netsim_scenarios/53.2-processsims_mddtbl3.R",
#     args = list(
#       ncores = max_cores,
#       nsteps = 52
#     ),
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "cpus-per-task" = max_cores,
#     "time" = "08:00:00",
#     "mem-per-cpu" = "4G",
#     "mail-type" = "FAIL,END"
#   )
# )
#
#
#
# # ~~~~~~~~~~~~~~~~~~~~~~  part 3
# scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl3D03.csv")
# scenarios_list <- EpiModel::create_scenario_list(scenarios_df)
#
# # HIV epidemic simulation
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_netsim_scenarios(
#     path_to_est, param, init, control,
#     scenarios_list = scenarios_list,
#     output_dir = "data/intermediate/scenarios_mddtbl3/rawsims",
#     save_pattern = "all",
#     n_rep = numsims,
#     n_cores = max_cores,
#     max_array_size = 500,
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "mail-type" = "FAIL,TIME_LIMIT,END",
#     "cpus-per-task" = max_cores,
#     "time" = "04:00:00",
#     "mem-per-cpu" = "5G"
#   )
# )
#
# # reduce sim files (also removes raw sim files)
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_do_call_script(
#     r_script = "R/C-netsim_scenarios/53.1-reducesim_mddtbl3.R",
#     args = list(
#       ncores = max_cores,
#       nsteps = 52
#     ),
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "cpus-per-task" = max_cores,
#     "time" = "08:00:00",
#     "mem-per-cpu" = "4G",
#     "mail-type" = "FAIL,END"
#   )
# )
#
# # process output (also removes reduced sim files except 001)
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_do_call_script(
#     r_script = "R/C-netsim_scenarios/53.2-processsims_mddtbl3.R",
#     args = list(
#       ncores = max_cores,
#       nsteps = 52
#     ),
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "cpus-per-task" = max_cores,
#     "time" = "08:00:00",
#     "mem-per-cpu" = "4G",
#     "mail-type" = "FAIL,END"
#   )
# )
#
#
#
# # ~~~~~~~~~~~~~~~~~~~~~~  part 4
# scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl3D04.csv")
# scenarios_list <- EpiModel::create_scenario_list(scenarios_df)
#
# # HIV epidemic simulation
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_netsim_scenarios(
#     path_to_est, param, init, control,
#     scenarios_list = scenarios_list,
#     output_dir = "data/intermediate/scenarios_mddtbl3/rawsims",
#     save_pattern = "all",
#     n_rep = numsims,
#     n_cores = max_cores,
#     max_array_size = 500,
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "mail-type" = "FAIL,TIME_LIMIT,END",
#     "cpus-per-task" = max_cores,
#     "time" = "04:00:00",
#     "mem-per-cpu" = "5G"
#   )
# )
#
# # reduce sim files (also removes raw sim files)
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_do_call_script(
#     r_script = "R/C-netsim_scenarios/53.1-reducesim_mddtbl3.R",
#     args = list(
#       ncores = max_cores,
#       nsteps = 52
#     ),
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "cpus-per-task" = max_cores,
#     "time" = "08:00:00",
#     "mem-per-cpu" = "4G",
#     "mail-type" = "FAIL,END"
#   )
# )
#
# # process output (also removes reduced sim files except 001)
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_do_call_script(
#     r_script = "R/C-netsim_scenarios/53.2-processsims_mddtbl3.R",
#     args = list(
#       ncores = max_cores,
#       nsteps = 52
#     ),
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "cpus-per-task" = max_cores,
#     "time" = "08:00:00",
#     "mem-per-cpu" = "4G",
#     "mail-type" = "FAIL,END"
#   )
# )
#
#
# # *******************clear ALL Sim files (prior to starting next interv model table run)
# # *******************
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_do_call_script(
#     r_script = "R/C-netsim_scenarios/53.4-removefiles_AllSims_mddtbl3.R",
#     args = list(
#       ncores = max_cores),
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "cpus-per-task" = max_cores,
#     "time" = "08:00:00",
#     "mem-per-cpu" = "4G",
#     "mail-type" = "FAIL,END"
#   )
# )
# # *************************************************
# # *************************************************
#
#
#
#
# #Table 3E ----------------------------------------------------------------------
# # ~~~~~~~~~~~~~~~~~~~~~~  part 1
# scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl3E01.csv")
# scenarios_list <- EpiModel::create_scenario_list(scenarios_df)
#
# # HIV epidemic simulation
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_netsim_scenarios(
#     path_to_est, param, init, control,
#     scenarios_list = scenarios_list,
#     output_dir = "data/intermediate/scenarios_mddtbl3/rawsims",
#     save_pattern = "all",
#     n_rep = numsims,
#     n_cores = max_cores,
#     max_array_size = 500,
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "mail-type" = "FAIL,TIME_LIMIT,END",
#     "cpus-per-task" = max_cores,
#     "time" = "04:00:00",
#     "mem-per-cpu" = "5G"
#   )
# )
#
# # reduce sim files (also removes raw sim files)
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_do_call_script(
#     r_script = "R/C-netsim_scenarios/53.1-reducesim_mddtbl3.R",
#     args = list(
#       ncores = max_cores,
#       nsteps = 52
#     ),
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "cpus-per-task" = max_cores,
#     "time" = "08:00:00",
#     "mem-per-cpu" = "4G",
#     "mail-type" = "FAIL,END"
#   )
# )
#
# # process output (also removes reduced sim files except 001)
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_do_call_script(
#     r_script = "R/C-netsim_scenarios/53.2-processsims_mddtbl3.R",
#     args = list(
#       ncores = max_cores,
#       nsteps = 52
#     ),
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "cpus-per-task" = max_cores,
#     "time" = "08:00:00",
#     "mem-per-cpu" = "4G",
#     "mail-type" = "FAIL,END"
#   )
# )
#
#
#
# # ~~~~~~~~~~~~~~~~~~~~~~  part 2
# scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl3E02.csv")
# scenarios_list <- EpiModel::create_scenario_list(scenarios_df)
#
# # HIV epidemic simulation
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_netsim_scenarios(
#     path_to_est, param, init, control,
#     scenarios_list = scenarios_list,
#     output_dir = "data/intermediate/scenarios_mddtbl3/rawsims",
#     save_pattern = "all",
#     n_rep = numsims,
#     n_cores = max_cores,
#     max_array_size = 500,
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "mail-type" = "FAIL,TIME_LIMIT,END",
#     "cpus-per-task" = max_cores,
#     "time" = "04:00:00",
#     "mem-per-cpu" = "5G"
#   )
# )
#
# # reduce sim files (also removes raw sim files)
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_do_call_script(
#     r_script = "R/C-netsim_scenarios/53.1-reducesim_mddtbl3.R",
#     args = list(
#       ncores = max_cores,
#       nsteps = 52
#     ),
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "cpus-per-task" = max_cores,
#     "time" = "08:00:00",
#     "mem-per-cpu" = "4G",
#     "mail-type" = "FAIL,END"
#   )
# )
#
# # process output (also removes reduced sim files except 001)
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_do_call_script(
#     r_script = "R/C-netsim_scenarios/53.2-processsims_mddtbl3.R",
#     args = list(
#       ncores = max_cores,
#       nsteps = 52
#     ),
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "cpus-per-task" = max_cores,
#     "time" = "08:00:00",
#     "mem-per-cpu" = "4G",
#     "mail-type" = "FAIL,END"
#   )
# )
#
#
#
# # ~~~~~~~~~~~~~~~~~~~~~~  part 3
# scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl3E03.csv")
# scenarios_list <- EpiModel::create_scenario_list(scenarios_df)
#
# # HIV epidemic simulation
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_netsim_scenarios(
#     path_to_est, param, init, control,
#     scenarios_list = scenarios_list,
#     output_dir = "data/intermediate/scenarios_mddtbl3/rawsims",
#     save_pattern = "all",
#     n_rep = numsims,
#     n_cores = max_cores,
#     max_array_size = 500,
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "mail-type" = "FAIL,TIME_LIMIT,END",
#     "cpus-per-task" = max_cores,
#     "time" = "04:00:00",
#     "mem-per-cpu" = "5G"
#   )
# )
#
# # reduce sim files (also removes raw sim files)
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_do_call_script(
#     r_script = "R/C-netsim_scenarios/53.1-reducesim_mddtbl3.R",
#     args = list(
#       ncores = max_cores,
#       nsteps = 52
#     ),
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "cpus-per-task" = max_cores,
#     "time" = "08:00:00",
#     "mem-per-cpu" = "4G",
#     "mail-type" = "FAIL,END"
#   )
# )
#
# # process output (also removes reduced sim files except 001)
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_do_call_script(
#     r_script = "R/C-netsim_scenarios/53.2-processsims_mddtbl3.R",
#     args = list(
#       ncores = max_cores,
#       nsteps = 52
#     ),
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "cpus-per-task" = max_cores,
#     "time" = "08:00:00",
#     "mem-per-cpu" = "4G",
#     "mail-type" = "FAIL,END"
#   )
# )
#
#
#
# # ~~~~~~~~~~~~~~~~~~~~~~  part 4
# scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl3E04.csv")
# scenarios_list <- EpiModel::create_scenario_list(scenarios_df)
#
# # HIV epidemic simulation
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_netsim_scenarios(
#     path_to_est, param, init, control,
#     scenarios_list = scenarios_list,
#     output_dir = "data/intermediate/scenarios_mddtbl3/rawsims",
#     save_pattern = "all",
#     n_rep = numsims,
#     n_cores = max_cores,
#     max_array_size = 500,
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "mail-type" = "FAIL,TIME_LIMIT,END",
#     "cpus-per-task" = max_cores,
#     "time" = "04:00:00",
#     "mem-per-cpu" = "5G"
#   )
# )
#
# # reduce sim files (also removes raw sim files)
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_do_call_script(
#     r_script = "R/C-netsim_scenarios/53.1-reducesim_mddtbl3.R",
#     args = list(
#       ncores = max_cores,
#       nsteps = 52
#     ),
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "cpus-per-task" = max_cores,
#     "time" = "08:00:00",
#     "mem-per-cpu" = "4G",
#     "mail-type" = "FAIL,END"
#   )
# )

# process output (also removes reduced sim files except 001)
wf <- add_workflow_step(
  wf_summary = wf,
  step_tmpl = step_tmpl_do_call_script(
    r_script = "R/C-netsim_scenarios/53.2-processsims_mddtbl3.R",
    args = list(
      ncores = max_cores,
      nsteps = 52
    ),
    setup_lines = hpc_node_setup
  ),
  sbatch_opts = list(
    "cpus-per-task" = max_cores,
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "FAIL,END"
  )
)


# *******************clear ALL Sim files (prior to starting next interv model table run)
# *******************
wf <- add_workflow_step(
  wf_summary = wf,
  step_tmpl = step_tmpl_do_call_script(
    r_script = "R/C-netsim_scenarios/53.4-removefiles_AllSims_mddtbl3.R",
    args = list(
      ncores = max_cores),
    setup_lines = hpc_node_setup
  ),
  sbatch_opts = list(
    "cpus-per-task" = max_cores,
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "FAIL,END"
  )
)
# *************************************************
# *************************************************


# # Process output
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_merge_netsim_scenarios_tibble(
#       sim_dir = scenarios_dir,
#       output_dir = fs::path(scenarios_dir, "merged_tibbles"),
#       steps_to_keep = year_steps * 3, # keep the last 3 years
#       cols = dplyr::everything(),
#       n_cores = max_cores,
#       setup_lines = hpc_node_setup
#     ),
#     sbatch_opts = list(
#       "mail-type" = "END",
#       "cpus-per-task" = max_cores,
#       "time" = "02:00:00",
#       "mem-per-cpu" = "5G"
#     )
# )




# to send restart file to the HPC (Run in R terminal)
# scp -r data/intermediate/hpc/estimates sph: /projects/epimodel/uonwubi/PartnerServiceYr3/data/intermediate/hpc/
# scp -r data/intermediate/hpc/estimates sph:projects/epimodel/uonwubi/PartnerServiceYr3/data/intermediate/hpc/

# to send workflows to the HPC (Run in R terminal)
# scp -r workflows/mddtbl3 sph:projects/epimodel/uonwubi/PartnerServiceYr3/workflows

# # to execute jobs
# chmod +x workflows/mddtbl3/start_workflow.sh
# ./workflows/mddtbl3/start_workflow.sh
