##
## 42. Processing counterfactual scenarios - Table 2
##

# Setup ----------------------------------------------------------------------------------
context <- "hpc"


install.packages("future.apply")
suppressMessages({
  library("EpiModelHIV")
  library("future.apply")
  library("tidyr")
  library("dplyr")
})


rawsims_dir <- paste0("data/intermediate/scenarios_mddtbl2/rawsims")
redusims_dir <- paste0("data/intermediate/scenarios_mddtbl2/reducedsims")





# Reduce sim files -----------------------------------------------------------------------
#function
reduce_simfiles <- function(input_dir, output_dir, keep_last) {

  if (!fs::dir_exists(output_dir)) fs::dir_create(output_dir)

  batches_infos <- EpiModelHPC::get_scenarios_batches_infos(input_dir)

  for (scenario in unique(batches_infos$scenario_name)) {
    scenario_infos <- dplyr::filter(batches_infos, .data$scenario_name == scenario)

    df_list <- future.apply::future_lapply(
      seq_len(nrow(scenario_infos)),
      function(i) {
        sc_inf <- scenario_infos[i, ]

        d <- readRDS(sc_inf$file_path) |>
          dplyr::as_tibble() |>
          dplyr::filter(.data$time >= max(.data$time) - keep_last)

        d_fix <- dplyr::select(d, "sim", "time")
        d_var <- dplyr::select(d, -c("sim", "time"))

        pos <- tidyselect::eval_select(dplyr::everything(), data = d_var)
        d_var <- rlang::set_names(d_var[pos], names(pos))

        dplyr::bind_cols(d_fix, d_var) |>
          dplyr::mutate( , batch_number = sc_inf$batch_number) |>
          dplyr::select("batch_number", "sim", "time", everything())
      }
    )

    df_sc <- dplyr::bind_rows(df_list)
    saveRDS(df_sc, fs::path(output_dir, paste0("df__", scenario, ".rds")))
  }
}


#apply reducing function
reduce_simfiles(rawsims_dir, redusims_dir, keep_last = 52 * 15)





# Remove files ---------------------------------------------------------------------------
#raw sim files
rawsims_dir <- paste0("data/intermediate/scenarios_mddtbl2/rawsims")

files_to_delete1 <- dir(path = rawsims_dir, pattern = "^sim__.*rds$")
file.remove(file.path(rawsims_dir, files_to_delete1))



#remove log files
log_dir <- paste0("workflows/mddtbl2/log")

files_to_delete_2 <- dir(path = log_dir, pattern = "^mddtbl2_step.*out$")
file.remove(file.path(log_dir, files_to_delete_2))
