## HPC Workflow: Network Estimation for 100K model
##
##

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


# Process ----------------------------------------------------------------------
wf <- make_em_workflow("networks", override = TRUE)


#Estimate main, casual and one-off networks  -------------------------------
wf <- add_workflow_step(
  wf_summary = wf,
  step_tmpl = step_tmpl_do_call_script(
    r_script = "R/A-networks/1-estimation.R",
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





# to send workflows to the HPC (Run in R terminal)
# scp -r workflows/networks sph:projects/epimodel/uonwubi/StigmaDepressionHIV_real/workflows

# # to execute jobs
# chmod +x workflows/networks/start_workflow.sh
# ./workflows/networks/start_workflow.sh
