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
wf <- make_em_workflow("mddtbl2", override = TRUE)



#Table 2A ----------------------------------------------------------------------
# ~~~~~~~~~~~~~~~~~~~~~~  part 1
scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl2A01.csv")
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
    "time" = "08:00:00",
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)

# clear files (sims except those for 001 scenarios and log) *****
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)



# ~~~~~~~~~~~~~~~~~~~~~~ part 2
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
    "time" = "08:00:00",
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)

# clear files (sims except those for 001 scenarios and log) *****
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)


# ~~~~~~~~~~~~~~~~~~~~~~ part 3
scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl2A03.csv")
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
    "time" = "08:00:00",
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)

# clear files (sims except those for 001 scenarios and log) *****
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)


# ~~~~~~~~~~~~~~~~~~~~~~ part 4
scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl2A04.csv")
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
    "time" = "08:00:00",
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)

# clear files (sims except those for 001 scenarios and log) *****
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)



# ~~~~~~~~~~~~~~~~~~~~~~ part 5
scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl2A05.csv")
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
    "time" = "08:00:00",
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)

# clear files (sims except those for 001 scenarios and log) *****
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)



# ~~~~~~~~~~~~~~~~~~~~~~ part 6
scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl2A06.csv")
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
    "time" = "08:00:00",
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)

# clear files (sims except those for 001 scenarios and log) *****
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)



# ~~~~~~~~~~~~~~~~~~~~~~ part 7
scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl2A07.csv")
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
    "time" = "08:00:00",
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)

# clear files (sims except those for 001 scenarios and log) *****
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)



# ~~~~~~~~~~~~~~~~~~~~~~ part 8
scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl2A08.csv")
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
    "time" = "08:00:00",
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)

# clear files (sims except those for 001 scenarios and log) *****
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)



# ~~~~~~~~~~~~~~~~~~~~~~ part 9
scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl2A09.csv")
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
    "time" = "08:00:00",
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)

# clear files (sims except those for 001 scenarios and log) *****
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)



# ~~~~~~~~~~~~~~~~~~~~~~ part 10
scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl2A010.csv")
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
    "time" = "08:00:00",
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)

# clear files (sims except those for 001 scenarios and log) *****
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)





# *******************clear ALL Sim files (prior to starting next interv model table run)
# *******************
wf <- add_workflow_step(
  wf_summary = wf,
  step_tmpl = step_tmpl_do_call_script(
    r_script = "R/C-netsim_scenarios/52.4-removefiles_AllSims_mddtbl2.R",
    args = list(
      ncores = max_cores),
    setup_lines = hpc_node_setup
  ),
  sbatch_opts = list(
    "cpus-per-task" = max_cores,
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)
# *************************************************
# *************************************************




#Table 2B ----------------------------------------------------------------------
# ~~~~~~~~~~~~~~~~~~~~~~  part 1
scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl2B01.csv")
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
    "time" = "08:00:00",
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)

# clear files (sims except those for 001 scenarios and log) *****
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)



# ~~~~~~~~~~~~~~~~~~~~~~ part 2
scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl2B02.csv")
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
    "time" = "08:00:00",
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)

# clear files (sims except those for 001 scenarios and log) *****
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)


# ~~~~~~~~~~~~~~~~~~~~~~ part 3
scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl2B03.csv")
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
    "time" = "08:00:00",
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)

# clear files (sims except those for 001 scenarios and log) *****
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)


# ~~~~~~~~~~~~~~~~~~~~~~ part 4
scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl2B04.csv")
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
    "time" = "08:00:00",
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)

# clear files (sims except those for 001 scenarios and log) *****
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)



# ~~~~~~~~~~~~~~~~~~~~~~ part 5
scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl2B05.csv")
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
    "time" = "08:00:00",
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)

# clear files (sims except those for 001 scenarios and log) *****
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)



# ~~~~~~~~~~~~~~~~~~~~~~ part 6
scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl2B06.csv")
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
    "time" = "08:00:00",
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)

# clear files (sims except those for 001 scenarios and log) *****
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)



# ~~~~~~~~~~~~~~~~~~~~~~ part 7
scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl2B07.csv")
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
    "time" = "08:00:00",
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)

# clear files (sims except those for 001 scenarios and log) *****
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)



# ~~~~~~~~~~~~~~~~~~~~~~ part 8
scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl2B08.csv")
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
    "time" = "08:00:00",
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)

# clear files (sims except those for 001 scenarios and log) *****
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)



# ~~~~~~~~~~~~~~~~~~~~~~ part 9
scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl2B09.csv")
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
    "time" = "08:00:00",
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)

# clear files (sims except those for 001 scenarios and log) *****
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)



# ~~~~~~~~~~~~~~~~~~~~~~ part 10
scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl2B010.csv")
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
    "time" = "08:00:00",
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)

# clear files (sims except those for 001 scenarios and log) *****
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)



# *******************clear ALL Sim files (prior to starting next interv model table run)
# *******************
wf <- add_workflow_step(
  wf_summary = wf,
  step_tmpl = step_tmpl_do_call_script(
    r_script = "R/C-netsim_scenarios/52.4-removefiles_AllSims_mddtbl2.R",
    args = list(
      ncores = max_cores),
    setup_lines = hpc_node_setup
  ),
  sbatch_opts = list(
    "cpus-per-task" = max_cores,
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)
# *************************************************
# *************************************************








#Table 2C ----------------------------------------------------------------------
# ~~~~~~~~~~~~~~~~~~~~~~  part 1
scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl2C01.csv")
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
    "time" = "08:00:00",
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)

# clear files (sims except those for 001 scenarios and log) *****
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)



# ~~~~~~~~~~~~~~~~~~~~~~ part 2
scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl2C02.csv")
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
    "time" = "08:00:00",
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)

# clear files (sims except those for 001 scenarios and log) *****
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)


# ~~~~~~~~~~~~~~~~~~~~~~ part 3
scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl2C03.csv")
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
    "time" = "08:00:00",
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)

# clear files (sims except those for 001 scenarios and log) *****
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)


# ~~~~~~~~~~~~~~~~~~~~~~ part 4
scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl2C04.csv")
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
    "time" = "08:00:00",
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)

# clear files (sims except those for 001 scenarios and log) *****
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)



# ~~~~~~~~~~~~~~~~~~~~~~ part 5
scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl2C05.csv")
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
    "time" = "08:00:00",
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)

# clear files (sims except those for 001 scenarios and log) *****
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)



# ~~~~~~~~~~~~~~~~~~~~~~ part 6
scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl2C06.csv")
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
    "time" = "08:00:00",
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)

# clear files (sims except those for 001 scenarios and log) *****
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)



# ~~~~~~~~~~~~~~~~~~~~~~ part 7
scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl2C07.csv")
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
    "time" = "08:00:00",
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)

# clear files (sims except those for 001 scenarios and log) *****
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)



# ~~~~~~~~~~~~~~~~~~~~~~ part 8
scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl2C08.csv")
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
    "time" = "08:00:00",
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)

# clear files (sims except those for 001 scenarios and log) *****
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)



# ~~~~~~~~~~~~~~~~~~~~~~ part 9
scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl2C09.csv")
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
    "time" = "08:00:00",
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)

# clear files (sims except those for 001 scenarios and log) *****
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)



# ~~~~~~~~~~~~~~~~~~~~~~ part 10
scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl2C010.csv")
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
    "time" = "08:00:00",
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)

# clear files (sims except those for 001 scenarios and log) *****
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)




# *******************clear ALL Sim files (prior to starting next interv model table run)
# *******************
wf <- add_workflow_step(
  wf_summary = wf,
  step_tmpl = step_tmpl_do_call_script(
    r_script = "R/C-netsim_scenarios/52.4-removefiles_AllSims_mddtbl2.R",
    args = list(
      ncores = max_cores),
    setup_lines = hpc_node_setup
  ),
  sbatch_opts = list(
    "cpus-per-task" = max_cores,
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)
# *************************************************
# *************************************************





#Table 2D ----------------------------------------------------------------------
# ~~~~~~~~~~~~~~~~~~~~~~  part 1
scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl2D01.csv")
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
    "time" = "08:00:00",
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)

# clear files (sims except those for 001 scenarios and log) *****
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)



# ~~~~~~~~~~~~~~~~~~~~~~ part 2
scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl2D02.csv")
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
    "time" = "08:00:00",
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)

# clear files (sims except those for 001 scenarios and log) *****
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)


# ~~~~~~~~~~~~~~~~~~~~~~ part 3
scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl2D03.csv")
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
    "time" = "08:00:00",
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)

# clear files (sims except those for 001 scenarios and log) *****
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)


# ~~~~~~~~~~~~~~~~~~~~~~ part 4
scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl2D04.csv")
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
    "time" = "08:00:00",
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)

# clear files (sims except those for 001 scenarios and log) *****
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)



# ~~~~~~~~~~~~~~~~~~~~~~ part 5
scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl2D05.csv")
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
    "time" = "08:00:00",
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)

# clear files (sims except those for 001 scenarios and log) *****
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)



# ~~~~~~~~~~~~~~~~~~~~~~ part 6
scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl2D06.csv")
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
    "time" = "08:00:00",
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)

# clear files (sims except those for 001 scenarios and log) *****
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)



# ~~~~~~~~~~~~~~~~~~~~~~ part 7
scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl2D07.csv")
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
    "time" = "08:00:00",
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)

# clear files (sims except those for 001 scenarios and log) *****
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)




# ~~~~~~~~~~~~~~~~~~~~~~ part 8
scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl2D08.csv")
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
    "time" = "08:00:00",
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)

# clear files (sims except those for 001 scenarios and log) *****
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)



# ~~~~~~~~~~~~~~~~~~~~~~ part 9
scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl2D09.csv")
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
    "time" = "08:00:00",
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)

# clear files (sims except those for 001 scenarios and log) *****
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)



# ~~~~~~~~~~~~~~~~~~~~~~ part 10
scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl2D010.csv")
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
    "time" = "08:00:00",
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)

# clear files (sims except those for 001 scenarios and log) *****
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)





# *******************clear ALL Sim files (prior to starting next interv model table run)
# *******************
wf <- add_workflow_step(
  wf_summary = wf,
  step_tmpl = step_tmpl_do_call_script(
    r_script = "R/C-netsim_scenarios/52.4-removefiles_AllSims_mddtbl2.R",
    args = list(
      ncores = max_cores),
    setup_lines = hpc_node_setup
  ),
  sbatch_opts = list(
    "cpus-per-task" = max_cores,
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)
# *************************************************
# *************************************************






#Table 2E ----------------------------------------------------------------------
# ~~~~~~~~~~~~~~~~~~~~~~  part 1
scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl2E01.csv")
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
    "time" = "08:00:00",
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)

# clear files (sims except those for 001 scenarios and log) *****
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)



# ~~~~~~~~~~~~~~~~~~~~~~ part 2
scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl2E02.csv")
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
    "time" = "08:00:00",
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)

# clear files (sims except those for 001 scenarios and log) *****
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)


# ~~~~~~~~~~~~~~~~~~~~~~ part 3
scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl2E03.csv")
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
    "time" = "08:00:00",
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)

# clear files (sims except those for 001 scenarios and log) *****
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)


# ~~~~~~~~~~~~~~~~~~~~~~ part 4
scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl2E04.csv")
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
    "time" = "08:00:00",
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)

# clear files (sims except those for 001 scenarios and log) *****
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)



# ~~~~~~~~~~~~~~~~~~~~~~ part 5
scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl2E05.csv")
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
    "time" = "08:00:00",
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)

# clear files (sims except those for 001 scenarios and log) *****
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)



# ~~~~~~~~~~~~~~~~~~~~~~ part 6
scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl2E06.csv")
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
    "time" = "08:00:00",
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)

# clear files (sims except those for 001 scenarios and log) *****
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)



# ~~~~~~~~~~~~~~~~~~~~~~ part 7
scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl2E07.csv")
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
    "time" = "08:00:00",
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)

# clear files (sims except those for 001 scenarios and log) *****
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)



# ~~~~~~~~~~~~~~~~~~~~~~ part 8
scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl2E08.csv")
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
    "time" = "08:00:00",
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)

# clear files (sims except those for 001 scenarios and log) *****
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)



# ~~~~~~~~~~~~~~~~~~~~~~ part 9
scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl2E09.csv")
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
    "time" = "08:00:00",
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)

# clear files (sims except those for 001 scenarios and log) *****
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)



# ~~~~~~~~~~~~~~~~~~~~~~ part 10
scenarios_df <- readr::read_csv("./data/input/mddscenarios_tbl2E010.csv")
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
    "time" = "08:00:00",
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)

# clear files (sims except those for 001 scenarios and log) *****
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
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)



# *******************clear ALL Sim files (prior to starting next interv model table run)
# *******************
wf <- add_workflow_step(
  wf_summary = wf,
  step_tmpl = step_tmpl_do_call_script(
    r_script = "R/C-netsim_scenarios/52.4-removefiles_AllSims_mddtbl2.R",
    args = list(
      ncores = max_cores),
    setup_lines = hpc_node_setup
  ),
  sbatch_opts = list(
    "cpus-per-task" = max_cores,
    "time" = "08:00:00",
    "mem-per-cpu" = "4G",
    "mail-type" = "END"
  )
)
# *************************************************
# *************************************************






# to send workflows to the HPC (Run in R terminal)
# scp -r workflows/mddtbl2 sph:projects/epimodel/uonwubi/PartnerServiceYr3/workflows

# # to execute jobs
# chmod +x workflows/mddtbl2/start_workflow.sh
# ./workflows/mddtbl2/start_workflow.sh
