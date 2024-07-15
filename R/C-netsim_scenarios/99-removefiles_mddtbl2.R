##
## Remove sim and log files after processing for table 2 simulations
##

#remove sim files
sims_dir <- paste0("data/intermediate/scenarios_mddtbl2")

all_files <- dir(path = sims_dir, pattern = "^sim__.*rds$")
files_to_keep <- dir(path = sims_dir, pattern = "^sim__.*001.*rds$")
files_to_delete1 <- setdiff(all_files, files_to_keep)

file.remove(file.path(sims_dir, files_to_delete1))



#remove log files
log_dir <- paste0("workflows/mddtbl2/log")

files_to_delete_2 <- dir(path = log_dir, pattern = "^mddtbl2_step.*out$")
file.remove(file.path(log_dir, files_to_delete_2))
