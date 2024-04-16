#Functions for model output processing

library(dplyr)


#Function 1: Process plot data -----------------------------------------------------------
process_fulldata <- function(file_name, ts) {

  # file_name <-sim_files[1]
  # ts <- 0 #3901 - (5 * 52) + 1

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
      scenario.num            = as.numeric(substr(scenario_name,3,3)),
      scenario.new            = substr(scenario_name,5,nchar(scenario_name))
    ) %>%
    mutate(tbl = ifelse(scenario.new == "base","A",
                        ifelse(scenario.new == "efxtransmis", "B",
                               ifelse(scenario.new == "efxservices", "C", "D")))) %>%
    ungroup() %>%
     select(
       tbl, scenario.num, scenario.new, scenario_name, batch_number, sim, time,

      #Distal impacts: HIV incidence measures
      num,
      incid, ir100,

      incid.mdd0, mdd.ir100.0,
      incid.mdd1, mdd.ir100.1,

      incid.stigma1, stigma.ir100.1,
      incid.stigma2, stigma.ir100.2,
      incid.stigma3, stigma.ir100.3,
      incid.stigma4, stigma.ir100.4,


      #Intermediate impacts: PrEP & ART coverage
      #PrEP
      prepElig, prepCurr, prepCov,
      prepCov.mdd0, prepCov.mdd1,
      prepCov.stigma1, prepCov.stigma2, prepCov.stigma3, prepCov.stigma4,

      #ART
      i.num, hivdiag, hivdiagCov,
      hivdiagCov.mdd0, hivdiagCov.mdd1,
      hivdiagCov.stigma1, hivdiagCov.stigma2, hivdiagCov.stigma3, hivdiagCov.stigma4,

      artCurr, artCov,
      artCov.mdd0, artCov.mdd1,
      artCov.stigma1, artCov.stigma2, artCov.stigma3, artCov.stigma4,

      vSupp, vSuppCov,


      #Proximal measures: stigma & mde cascade
      #stigma-related
      stigma.1.prphiv1, stigma.2.prphiv1, stigma.3.prphiv1, stigma.4.prphiv1,
      stigma.1.prphiv0, stigma.2.prphiv0, stigma.3.prphiv0, stigma.4.prphiv0,

      #mdd-related
      mdd.prpall,
      mdd.prphiv1, mdd.prphiv0,
      mdd.prpstigma1, mdd.prpstigma2, mdd.prpstigma3, mdd.prpstigma4,
      mdd.prprace1, mdd.prprace2, mdd.prprace3,

      #mde-related
      mde.ever.prpmdd,
      mde.ever.prpmddhiv0, mde.ever.prpmddhiv1,
      mde.active.prpmdd,

      mde.start.numall,
      mde.start.new.numall, mde.start.recurr.numall,

      mde.stop.numall,
      mde.stop.numspontres, mde.stop.numtxremiss, mde.stop.numendmainte, mde.stop.numdth,
      mde.epidur.median, mde.epidur.max,

      mde.active.numall, mde.active.prpmdd,

      #mdd care-related
      mdd.diagever.prpmddall,
      mdd.diagever.prpmddhiv0, mdd.diagever.prpmddhiv1,

      mdd.eligdiagat.numgen, mdd.diagat.numgen,
      mdd.eligdiagat.numprep, mdd.diagat.numprep,
      mdd.diagat.numall,

      mdd.eligtxstart.numall, mdd.txstart.numall,
      mdd.txstart.prpofeverdiag, mdd.txstart.prpofactivemde, mdd.txstart.prpofactivemdediag,
      mdd.txstart.prpeverdiag.race1, mdd.txstart.prpeverdiag.race2, mdd.txstart.prpeverdiag.race3,

      mdd.txstop.numall, mdd.txstop.numremiss, mdd.txstop.numendmainte, mdd.txstop.numltfu, mdd.txstop.numdth,


      #suicide-related
      mdd.eligsuitry.numall, mdd.suitry.numall,
      mdd.suitry.numhiv0, mdd.suitry.numhiv1,
      mdd.suitry.numsev1, mdd.suitry.numsev2, mdd.suitry.numsev3, mdd.suitry.numsev4,
      mdd.suitry.nummed, mdd.suitry.nummax,

      mdd.eligsuicompl.numall, mdd.suicompl.numall, mdd.suicompl.prpdepall,


      #Proximal impacts - HIV transmission dynamics & services engagement
      #hiv trans dynamics
      mdd.ai.numall,
      mdd.ai.totmain, mdd.ai.totcas, mdd.ai.totoof,
      mdd.ai.totcas.sev1, mdd.ai.totcas.sev2, mdd.ai.totcas.sev3, mdd.ai.totcas.sev4,

      mdd.uai.numall,
      mdd.uai.totmain, mdd.uai.totcas, mdd.uai.totoof,
      mdd.uai.totcasoof.sev1, mdd.uai.totcasoof.sev2, mdd.uai.totcasoof.sev3, mdd.uai.totcasoof.sev4,

      #hiv screening
      tot.tests,
      tot.tests.ibt, tot.tests.pbt,

      #hiv tx
      all.init.tx,
      elig.gen.start.tx, gen.start.tx,
      elig.part.start.tx, part.start.tx,

      all.reinit.tx,
      gen.elig.for.reinit, gen.reinit.tx,
      part.elig.for.reinit, part.reinit.tx,

      txStop,

      #prep
      prepCurr,
      elig.prepStartGen, prepStartGen,
      elig.prepStartPart, prepStartPart,

      prep.all.stop, prep.rand.stop

    ) %>%
    arrange(scenario.num, scenario.new, scenario_name, batch_number, sim)

  return(d)
}




#Function 2a: Get cumulative HIV incidence  ----------------
get_cumulative_outcomes <- function(d) {
  #d <- alldata
  d %>%
    #filter(time > 5 * 52) %>%
    select(tbl, scenario.num, scenario.new, scenario_name, sim, time,
           incid,
           incid.mdd0, incid.mdd1,
           incid.stigma1, incid.stigma2, incid.stigma3, incid.stigma4) %>%
    group_by(tbl, scenario.num, scenario.new, scenario_name, sim) %>%
    summarise(across(c(starts_with("incid")), ~ sum(.x, na.rm = TRUE), .names = "{.col}.cum"))
}


#Function 2b: Get mean in yr-10 (process measures) ---------------------------------------
get_yr10_outcomes <- function(d) {
  #d <- alldata
  d %>%
    filter(time >= max(time) - 52) %>%
    select(
      tbl, scenario.num, scenario.new, scenario_name, sim,
      incid,
      incid.mdd0, incid.mdd1,
      incid.stigma1, incid.stigma2, incid.stigma3, incid.stigma4,
      contains("ir100"),

      hivdiagCov,
      hivdiagCov.mdd0, hivdiagCov.mdd1,
      hivdiagCov.stigma1, hivdiagCov.stigma2, hivdiagCov.stigma3, hivdiagCov.stigma4,

      artCov,
      artCov.mdd0, artCov.mdd1,
      artCov.stigma1, artCov.stigma2, artCov.stigma3, artCov.stigma4,

      vSuppCov,

      prepCov,
      prepCov.mdd0, prepCov.mdd1,
      prepCov.stigma1, prepCov.stigma2, prepCov.stigma3, prepCov.stigma4
    ) %>%
    group_by(tbl, scenario.num, scenario.new, scenario_name, sim) %>%
    summarise(
      across(c(starts_with("incid")), ~sum (.x, na.rm = T), .names = "{.col}.yr10"),
      across(c(contains("ir100"),starts_with("hivdiagCov"), starts_with("artCov"),
                           "vSuppCov", starts_with("prepCov")),
             ~ mean(.x, na.rm = T),
             .names = "{.col}.yr10")
    ) %>%
    select(tbl, scenario.num, scenario.new, scenario_name, sim, ends_with(".yr10"))
}





#Function 2c: Get nia, pia, nnt ----------------------------------------------------------
get_niapiannt <- function(d) {
  #d <- alldata
  d %>%
    #filter(time > 5 * 52) %>%
    select(
      tbl, scenario.num, scenario.new, scenario_name, sim, time,
      incid, mdd.txstart.numall,
    ) %>%
    group_by(tbl, scenario.num, scenario.new, scenario_name, sim) %>%
    summarise(across(c(incid, mdd.txstart.numall), ~ sum(.x, na.rm = TRUE)))  %>%
    arrange(tbl, sim, scenario.num) %>%
    group_by(sim, tbl) %>%
    mutate(base_incid = incid[1]) %>%
    mutate(
      nia = base_incid - incid,
      pia = (base_incid - incid) / base_incid
    ) %>%
    mutate(nnt = mdd.txstart.numall / nia) %>%
    ungroup() %>%
    select(tbl, scenario.num, scenario.new, scenario_name, sim, nia, pia, nnt)
}





#Function 2d: Get mean outcomes over intervention period (mean/interv yr) ----------------
get_yrMu_outcomes <- function(d) {
  #d <- alldata
  d %>%
    #filter(time > 5 * 52) %>%
    select(
      tbl, scenario.num, scenario.new, scenario_name, sim,
      contains("prp")
      ) %>%
    group_by(tbl, scenario.num, scenario.new, scenario_name, sim) %>%
    summarise(across(
      everything(),
      ~ mean(.x, na.rm = T)
    ))
}



#Function 2e: Get summed and average outcomes over intervention period -------------------
get_sumave_outcomes <- function(d) {
  #d <- alldata
  d %>%
    #filter(time > 5 * 52) %>%
    select(
      tbl, scenario.num, scenario.new, scenario_name, sim,
      contains(".num"), contains(".tot"),
      prepElig, prepCurr,
      i.num, hivdiag, artCurr, vSupp,
      all.init.tx,
      elig.gen.start.tx, gen.start.tx,
      elig.part.start.tx, part.start.tx,
      all.reinit.tx,
      gen.elig.for.reinit, gen.reinit.tx,
      part.elig.for.reinit, part.reinit.tx,
      txStop,
      elig.prepStartGen, prepStartGen,
      elig.prepStartPart, prepStartPart,
      prep.all.stop, prep.rand.stop
    ) %>%
    group_by(tbl, scenario.num, scenario.new, scenario_name, sim) %>%
    summarise(across(
      everything(),
      ~ sum(.x, na.rm = T) / 10
    )
    )
}



#Function 2f: Get processed data ---------------------------------------------------------
get_outcome_sims <- function(d){

  d_cum       <- get_cumulative_outcomes(d)
  d_yr10      <- get_yr10_outcomes(d)
  d_niapiannt <- get_niapiannt(d)
  d_yrMu      <- get_yrMu_outcomes(d)
  d_yrmean    <- get_sumave_outcomes(d)

  #merge files
  d_join0 <- left_join(
    d_cum,
    d_yr10,
    by = c("tbl","scenario.num", "scenario.new","scenario_name", "sim")
  )
  d_join1 <- left_join(
    d_join0,
    d_niapiannt,
    by = c("tbl","scenario.num", "scenario.new","scenario_name", "sim")
  )
  d_join2 <- left_join(
    d_join1,
    d_yrMu,
    by = c("tbl","scenario.num", "scenario.new","scenario_name", "sim")
  )

  left_join(
    d_join2,
    d_yrmean,
    by = c("tbl","scenario.num", "scenario.new","scenario_name", "sim")
  )
}




