##
## Remove sim and log files after processing for table 2 simulations
##

#remove all sim files
sims_dir <- paste0("data/intermediate/scenarios_mddtbl2/redusims")

files_to_delete_1 <- dir(path = sims_dir, pattern = "^df__.*rds$")
file.remove(file.path(sims_dir, files_to_delete_1))



