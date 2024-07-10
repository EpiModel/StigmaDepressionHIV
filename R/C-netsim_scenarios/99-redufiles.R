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
wf <- make_em_workflow("redufile", override = TRUE)



#Table 2A ----------------------------------------------------------------------
# ~~~~~~~~~~~~~~~~~~~~~~  part 1

# Process calibrations
wf <- add_workflow_step(
  wf_summary = wf,
  step_tmpl = step_tmpl_merge_netsim_scenarios_tibble(
    sim_dir = "data/intermediate/scenarios_mddtbl2",
    output_dir = fs::path("data/intermediate/scenarios_mddtbl2", "merged_tibbles"),
    steps_to_keep = year_steps * 15, # keep the last 15 years
    cols = dplyr::everything(),
    n_cores = max_cores,
    setup_lines = hpc_node_setup
  ),
  sbatch_opts = list(
    "mail-type" = "END",
    "cpus-per-task" = max_cores,
    "time" = "02:00:00",
    "mem-per-cpu" = "5G"
  )
)
