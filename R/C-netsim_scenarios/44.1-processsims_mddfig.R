##
## 42. Processing counterfactual scenarios
##


# Setup ----------------------------------------------------------------------------------
context<-"hpc"

sims_dir <- paste0("data/intermediate/scenarios_mddfig")
save_dir <- paste0("data/intermediate/processed")


#get batch info
batches_infos <- EpiModelHPC::get_scenarios_batches_infos(
  paste0("data/intermediate/scenarios_mddfig")
)




#A. Process intervdata -------------------------------------------------------------------
install.packages("future.apply")
suppressMessages({
  library("EpiModelHIV")
  library("future.apply")
  library("tidyr")
  library("dplyr")
  library("ggplot2")
})


#get sim files
sim_files <- list.files(
  sims_dir,
  pattern = "^sim__.*rds$",
  full.names = TRUE
)


#Process each batch in parallel
process_fulldata <- function(file_name, ts) {

  # file_name <-sim_files[1]
  # ts <- 3901 - (5 * 52) + 1

  # keep only the file name without extension and split around `__`
  name_elts <- fs::path_file(file_name) %>%
    fs::path_ext_remove() %>%
    strsplit(split = "__")

  scenario_name <- name_elts[[1]][2]
  batch_number <- as.numeric(name_elts[[1]][3])

  d <- as_tibble(readRDS(file_name))

  d <- d %>%
    mutate(scenario_name = scenario_name, batch_number = batch_number) %>%
    group_by(scenario_name, batch_number, sim) %>%
    filter(time >= ts) %>%
    mutate(time=row_number()) %>%
    ungroup() %>%
    mutate(sim2=ifelse(batch_number > 1,
                       sim + ((batch_number-1) * 32),
                       sim)) %>%
    select(-sim) %>%
    rename(sim=sim2) %>%
    mutate(
      tbl0                    = toupper(substr(scenario_name,1,1)),
      scenario.num            = as.numeric(substr(scenario_name,2,4)),
      scenario.new            = substr(scenario_name,5,nchar(scenario_name))
    ) %>%
    #select(scenario_name, tbl0, scenario.num, scenario.new)
    mutate(tbl = factor(tbl0, levels=c("A","C","E"))) %>%
    ungroup() %>%
    select(
      tbl, scenario.num, scenario.new, scenario_name, batch_number, sim, time,

      #Distal impacts: HIV incidence measures
      num,
      incid,
      incid.mdd0, incid.mdd1
    ) %>%
    arrange(scenario.num, scenario.new, scenario_name, batch_number, sim)

  return(d)
}



intervds <- future.apply::future_lapply(
  sim_files,
  process_fulldata,
  ts = 3901 - (5 * 52) + 1   #gets data from 5 years prior to intervention start
)


#Merge batches
fulldata <- bind_rows(intervds) %>%
  select(tbl, scenario.num, scenario_name, sim, time, incid) %>%
  mutate(scenario.new = stringr::str_split_i(scenario_name, "_", 1),
         psval = stringr::str_split_i(scenario_name, "_", 4))



if(fulldata$scenario_name [1] == "a001base") {
  saveRDS(fulldata, paste0(save_dir, "/fulldata_basemodel.rds"))
}



if(fulldata$scenario_name [1] != "a001base"){

  tblnam <- fulldata$tbl[2]
  psval <- fulldata$psval[2]
  scetop <- fulldata$scenario.new[2]

  saveRDS(fulldata, paste0(save_dir, "/fulldata_",scetop,"_",psval,".rds"))


  #B. Get pia
  #-----------------------------------------------------------------------------------------
  base_df <- readRDS(paste0(save_dir, "/fulldata_basemodel.rds", sep="")) %>%
    filter(time > 5 * 52) %>%
    group_by(tbl, scenario.num, scenario_name, sim) %>%
    summarise(across(c(incid), ~ sum(.x, na.rm = TRUE))) %>%
    ungroup() %>%
    summarise(base_incid = median(incid))

  base_incid <- base_df$base_incid

  piatbl <- fulldata %>%
    filter(time > 5 * 52) %>%
    group_by(tbl, scenario.num, scenario_name, sim) %>%
    summarise(across(c(incid), ~ sum(.x, na.rm = TRUE))) %>%
    mutate(pia = (base_incid - incid) / base_incid) %>%
    ungroup() %>%
    mutate(across(where(is.numeric), ~round (., 6))) %>% ungroup()%>%
    group_by(tbl, scenario.num, scenario_name) %>%
    summarise(pia = median(pia)) %>%
    mutate(scenario.new = stringr::str_split_i(scenario_name, "_", 1),
           x = as.numeric(stringr::str_split_i(scenario_name, "_", 2)),
           y = as.numeric(stringr::str_split_i(scenario_name, "_", 3)),
           psval = stringr::str_split_i(scenario_name, "_", 4)) %>%
    arrange(tbl, scenario.num)

  saveRDS(piatbl, paste0(save_dir, "/piatbl_",scetop,"_",psval,".rds"))

}














