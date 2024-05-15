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
partition <- "epimodel"

source("R/shared_variables.R", local = TRUE)
source("R/C-netsim_scenarios/z-context.R", local = TRUE)
source("R/hpc_configs.R", local = TRUE)

max_cores <- 32
numsims <- 14 * max_cores
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
wf <- make_em_workflow("mddfig", override = TRUE)



#Grid: Base scenario, other parms at base p1 ---------------------------------------------
# scenarios
scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl3A.csv")
scenarios_list <- EpiModel::create_scenario_list(scenarios_df)

# HIV epidemic simulation
wf <- add_workflow_step(
  wf_summary = wf,
  step_tmpl = step_tmpl_netsim_scenarios(
    path_to_est, param, init, control,
    scenarios_list = scenarios_list,
    output_dir = "data/intermediate/scenarios_mddtbl3",
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
    r_script = "R/C-netsim_scenarios/43.2-processsims_mddtbl3.R",
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
    r_script = "R/C-netsim_scenarios/43.3-removefiles_mddtbl3.R",
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




