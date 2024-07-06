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
#partition <- "preemptable" #change partition in the R/hpc_configs.R script


source("R/shared_variables.R", local = TRUE)
source("R/C-netsim_scenarios/z-context.R", local = TRUE)
source("R/hpc_configs.R", local = TRUE)


max_cores <- 32
numsims <- 2 * max_cores
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
wf <- make_em_workflow("mddtbl2", override = TRUE)



#Table 2A ----------------------------------------------------------------------
# # ~~~~~~~~~~~~~~~~~~~~~~  scenarios 1 - 5
# scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl2A01.csv")
# scenarios_list <- EpiModel::create_scenario_list(scenarios_df)
#
# # HIV epidemic simulation
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_netsim_scenarios(
#     path_to_est, param, init, control,
#     scenarios_list = scenarios_list,
#     output_dir = "data/intermediate/scenarios_mddtbl2",
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
# # process output
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_do_call_script(
#     r_script = "R/C-netsim_scenarios/52.1-processsims_mddtbl2.R",
#     args = list(
#       ncores = max_cores,
#       nsteps = 52
#     ),
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "cpus-per-task" = max_cores,
#     "time" = "04:00:00",
#     "mem-per-cpu" = "4G",
#     "mail-type" = "END"
#   )
# )

# clear files (sims except those for 001 scenarios and log)
wf <- add_workflow_step(
  wf_summary = wf,
  step_tmpl = step_tmpl_do_call_script(
    r_script = "R/C-netsim_scenarios/52.3-removefiles_mddtbl2.R",
    args = list(
      ncores = max_cores),
    setup_lines = hpc_node_setup
  ),
  sbatch_opts = list(
    "cpus-per-task" = max_cores,
    "time" = "04:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)



# ~~~~~~~~~~~~~~~~~~~~~~ scenarios 6 - 10
scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl2A02.csv")
scenarios_list <- EpiModel::create_scenario_list(scenarios_df)

# HIV epidemic simulation
wf <- add_workflow_step(
  wf_summary = wf,
  step_tmpl = step_tmpl_netsim_scenarios(
    path_to_est, param, init, control,
    scenarios_list = scenarios_list,
    output_dir = "data/intermediate/scenarios_mddtbl2",
    save_pattern = "all",
    n_rep = numsims,
    n_cores = max_cores,
    max_array_size = 500,
    setup_lines = hpc_node_setup
  ),
  sbatch_opts = list(
    "mail-type" = "FAIL,TIME_LIMIT,END",
    "cpus-per-task" = max_cores,
    "time" = "04:00:00",
    "mem-per-cpu" = "5G"
  )
)

# process output
wf <- add_workflow_step(
  wf_summary = wf,
  step_tmpl = step_tmpl_do_call_script(
    r_script = "R/C-netsim_scenarios/52.1-processsims_mddtbl2.R",
    args = list(
      ncores = max_cores,
      nsteps = 52
    ),
    setup_lines = hpc_node_setup
  ),
  sbatch_opts = list(
    "cpus-per-task" = max_cores,
    "time" = "04:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)

# clear files (sims and log)
wf <- add_workflow_step(
  wf_summary = wf,
  step_tmpl = step_tmpl_do_call_script(
    r_script = "R/C-netsim_scenarios/52.3-removefiles_mddtbl2.R",
    args = list(
      ncores = max_cores),
    setup_lines = hpc_node_setup
  ),
  sbatch_opts = list(
    "cpus-per-task" = max_cores,
    "time" = "04:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)


# # clear ALL Sim files (prior to starting next interv model table run)
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_do_call_script(
#     r_script = "R/C-netsim_scenarios/52.4-removefiles_AllSims_mddtbl2.R",
#     args = list(
#       ncores = max_cores),
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "cpus-per-task" = max_cores,
#     "time" = "04:00:00",
#     "mem-per-cpu" = "4G",
#     "mail-type" = "END"
#   )
# )

# # Table 2B ----------------------------------------------------------------------
# # scenarios
# scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl2B.csv")
# scenarios_list <- EpiModel::create_scenario_list(scenarios_df)
#
# # HIV epidemic simulation
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_netsim_scenarios(
#     path_to_est, param, init, control,
#     scenarios_list = scenarios_list,
#     output_dir = "data/intermediate/scenarios_mddtbl2",
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
# # process output
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_do_call_script(
#     r_script = "R/C-netsim_scenarios/52.1-processsims_mddtbl2.R",
#     args = list(
#       ncores = max_cores,
#       nsteps = 52
#     ),
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "cpus-per-task" = max_cores,
#     "time" = "04:00:00",
#     "mem-per-cpu" = "4G",
#     "mail-type" = "END"
#   )
# )
#
# # clear files (sims and log)
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_do_call_script(
#     r_script = "R/C-netsim_scenarios/52.3-removefiles_mddtbl2.R",
#     args = list(
#       ncores = max_cores),
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "cpus-per-task" = max_cores,
#     "time" = "04:00:00",
#     "mem-per-cpu" = "4G",
#     "mail-type" = "END"
#   )
# )
#
#
#
# # Table 2C ----------------------------------------------------------------------
# # scenarios
# scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl2C.csv")
# scenarios_list <- EpiModel::create_scenario_list(scenarios_df)
#
# # HIV epidemic simulation
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_netsim_scenarios(
#     path_to_est, param, init, control,
#     scenarios_list = scenarios_list,
#     output_dir = "data/intermediate/scenarios_mddtbl2",
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
# # process output
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_do_call_script(
#     r_script = "R/C-netsim_scenarios/52.1-processsims_mddtbl2.R",
#     args = list(
#       ncores = max_cores,
#       nsteps = 52
#     ),
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "cpus-per-task" = max_cores,
#     "time" = "04:00:00",
#     "mem-per-cpu" = "4G",
#     "mail-type" = "END"
#   )
# )
#
# # clear files (sims and log)
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_do_call_script(
#     r_script = "R/C-netsim_scenarios/52.3-removefiles_mddtbl2.R",
#     args = list(
#       ncores = max_cores),
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "cpus-per-task" = max_cores,
#     "time" = "04:00:00",
#     "mem-per-cpu" = "4G",
#     "mail-type" = "END"
#   )
# )
#
#
#
# # Table 2D ----------------------------------------------------------------------
# # scenarios
# scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl2D.csv")
# scenarios_list <- EpiModel::create_scenario_list(scenarios_df)
#
# # HIV epidemic simulation
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_netsim_scenarios(
#     path_to_est, param, init, control,
#     scenarios_list = scenarios_list,
#     output_dir = "data/intermediate/scenarios_mddtbl2",
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
# # process output
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_do_call_script(
#     r_script = "R/C-netsim_scenarios/52.1-processsims_mddtbl2.R",
#     args = list(
#       ncores = max_cores,
#       nsteps = 52
#     ),
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "cpus-per-task" = max_cores,
#     "time" = "04:00:00",
#     "mem-per-cpu" = "4G",
#     "mail-type" = "END"
#   )
# )
#
# # clear files (sims and log)
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_do_call_script(
#     r_script = "R/C-netsim_scenarios/52.3-removefiles_mddtbl2.R",
#     args = list(
#       ncores = max_cores),
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "cpus-per-task" = max_cores,
#     "time" = "04:00:00",
#     "mem-per-cpu" = "4G",
#     "mail-type" = "END"
#   )
# )
#
#
#
# # Table 2E ----------------------------------------------------------------------
# # scenarios
# scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl2E.csv")
# scenarios_list <- EpiModel::create_scenario_list(scenarios_df)
#
# # HIV epidemic simulation
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_netsim_scenarios(
#     path_to_est, param, init, control,
#     scenarios_list = scenarios_list,
#     output_dir = "data/intermediate/scenarios_mddtbl2",
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
# # process output
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_do_call_script(
#     r_script = "R/C-netsim_scenarios/52.1-processsims_mddtbl2.R",
#     args = list(
#       ncores = max_cores,
#       nsteps = 52
#     ),
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "cpus-per-task" = max_cores,
#     "time" = "04:00:00",
#     "mem-per-cpu" = "4G",
#     "mail-type" = "END"
#   )
# )
#
# # clear files (sims and log)
# wf <- add_workflow_step(
#   wf_summary = wf,
#   step_tmpl = step_tmpl_do_call_script(
#     r_script = "R/C-netsim_scenarios/52.3-removefiles_mddtbl2.R",
#     args = list(
#       ncores = max_cores),
#     setup_lines = hpc_node_setup
#   ),
#   sbatch_opts = list(
#     "cpus-per-task" = max_cores,
#     "time" = "04:00:00",
#     "mem-per-cpu" = "4G",
#     "mail-type" = "END"
#   )
# )



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
# scp -r workflows/psy3tbl2 sph:projects/epimodel/uonwubi/PartnerServiceYr3/workflows

# # to execute jobs
# chmod +x workflows/mddtbl2/start_workflow.sh
# ./workflows/mddtbl2/start_workflow.sh
