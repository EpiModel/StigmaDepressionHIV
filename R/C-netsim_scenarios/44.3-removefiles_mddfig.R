##
## Remove sim and log files after processing for contour fig simulations
##

#remove sim files
sims_dir <- paste0("data/intermediate/scenarios_mddfig")

files_to_delete_1 <- dir(path = sims_dir, pattern = "^sim__.*rds$")
file.remove(file.path(sims_dir, files_to_delete_1))




#remove log files
log_dir <- paste0("workflows/mddfig/log")

files_to_delete_2 <- dir(path = log_dir, pattern = "^mddfig_step.*out$")
file.remove(file.path(log_dir, files_to_delete_2))
