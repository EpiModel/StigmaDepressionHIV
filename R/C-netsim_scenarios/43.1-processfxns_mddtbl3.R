#
# Functions for model output processing
#



library(dplyr)


#Function 1: Process plot data -----------------------------------------------------------
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
    mutate(tbl = factor(tbl0, levels=c("A","B","C","D","E"))) %>%
    ungroup() %>%
    mutate(tot.tests.pbt = tot.tests - tot.tests.ibt,
           mdd.uai.prpai = mdd.uai.numall/mdd.ai.numall) %>%
    select(
      tbl, scenario.num, scenario.new, scenario_name, batch_number, sim, time,

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

      mde.start.numall,
      mde.start.new.numall, mde.start.recurr.numall,

      mde.stop.numall,
      mde.stop.numspontres, mde.stop.numtxremiss, mde.stop.numendmainte, mde.stop.numdth,
      mde.epidur.median, mde.epidur.max,

      mde.active.numall, mde.active.prpmdd,
      mde.active.prpmddhiv0, mde.active.prpmddhiv1,

      #mhcare-related
      mdd.diagever.prpmddall,
      mdd.diagever.prpmddhiv0, mdd.diagever.prpmddhiv1,

      mdd.eligdiagat.numgen, mdd.diagat.numgen, mdd.diagat.prpeliggen,
      mdd.PrEPstartsat, mdd.eligscrnat.numpstat, mdd.scrndat.numpstat, mdd.diagat.numpstat, mdd.diagat.prpeligpstat,

      mdd.eligscrnat.numpind, mdd.scrndat.numpind, mdd.diagat.numpind, mdd.diagat.prpeligpind,
      mdd.diagat.numall,

      mdd.eligtxstart.numtxreg, mdd.txstart.numtxreg, mdd.txstart.prpeligtxreg,
      mdd.eligtxstart.numtxintv, mdd.txstart.numtxintv, mdd.txstart.prpeligtxintv,

      mdd.txstart.numall, mdd.txcurr.numall, mdd.txelig.numall, mdd.txcurr.prpactiveeverdiag,
      mdd.txcurr.prpactiveeverdiag.race1, mdd.txcurr.prpactiveeverdiag.race2, mdd.txcurr.prpactiveeverdiag.race3,
      mdd.mhcare.numpcvdneed,
      mdd.mhcare.numrcvanytx, mdd.mhcare.prppcvd_rcvanytx,
      mdd.mhcare.numrcvminadeqtx, mdd.mhcare.prppcvd_rcvminadeqtx,

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
      mdd.ai.mde1.notx, mdd.ai.mde1.tx, mdd.ai.mde0,
      mdd.ai.totcas.sev1, mdd.ai.totcas.sev2, mdd.ai.totcas.sev3, mdd.ai.totcas.sev4,

      mdd.uai.numall, mdd.uai.prpai,
      mdd.uai.totmain, mdd.uai.totcas, mdd.uai.totoof,
      mdd.uai.mde1.notx, mdd.uai.mde1.tx, mdd.uai.mde0,
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
      prepStart.numactivemde0, prepStart.numactivemde1,
      prepStart.numstigma1, prepStart.numstigma2, prepStart.numstigma3, prepStart.numstigma4,

      prep.all.stop, prep.rand.stop,


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


      #Distal impacts: HIV incidence measures
      num,
      incid, ir100,

      incid.mdd0, mdd.ir100.0,
      incid.mdd1, mdd.ir100.1,

      incid.stigma1, stigma.ir100.1,
      incid.stigma2, stigma.ir100.2,
      incid.stigma3, stigma.ir100.3,
      incid.stigma4, stigma.ir100.4

    ) %>%
    arrange(scenario.num, scenario.new, scenario_name, batch_number, sim)

  return(d)
}




#Function 2a: Cumulative HIV incidence (over 10-yr intervention period)  ----------------
get_cumulative_outcomes <- function(d) {
  #d <- alldata
  d %>%
    filter(time > 5 * 52) %>%
    select(tbl, scenario.num, scenario.new, scenario_name, sim, time,
           incid,
           incid.mdd0, incid.mdd1,
           incid.stigma1, incid.stigma2, incid.stigma3, incid.stigma4) %>%
    group_by(tbl, scenario.num, scenario.new, scenario_name, sim) %>%
    summarise(across(c(starts_with("incid")),
                     ~ sum(.x, na.rm = TRUE),
                     .names = "{.col}.cum"))
}



#Function 2b: Get mean in yr-0 (process measures) ---------------------------------------
get_yr0_outcomes <- function(d) {
  #d <- alldata
  d %>%
    filter(time > (4*52) & time < (5*52)) %>%
    select(
      tbl, scenario.num, scenario.new, scenario_name, sim,
      #hiv-related
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
      prepCov.stigma1, prepCov.stigma2, prepCov.stigma3, prepCov.stigma4,

      #mdd-related
      mdd.diagever.prpmddall, mdd.diagever.prpmddhiv0, mdd.diagever.prpmddhiv1
    ) %>%
    group_by(tbl, scenario.num, scenario.new, scenario_name, sim) %>%
    summarise(
      across(c(starts_with("incid")), ~sum (.x, na.rm = T), .names = "{.col}.yr0"),
      across(c(contains("ir100"),starts_with("hivdiagCov"), starts_with("artCov"),
               "vSuppCov", starts_with("prepCov"), starts_with("mdd.diagever.prp")),
             ~ mean(.x, na.rm = T),
             .names = "{.col}.yr0")
    ) %>%
    select(tbl, scenario.num, scenario.new, scenario_name, sim, ends_with(".yr0"))
}



#Function 2b: Get mean in yr-10 (process measures) ---------------------------------------
get_yr10_outcomes <- function(d) {
  #d <- alldata
  d %>%
    filter(time >= max(time) - 52) %>%
    select(
      tbl, scenario.num, scenario.new, scenario_name, sim,
      #hiv-related
      incid, num,
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
      prepCov.stigma1, prepCov.stigma2, prepCov.stigma3, prepCov.stigma4,

      #mdd-related
      mdd.diagever.prpmddall, mdd.diagever.prpmddhiv0, mdd.diagever.prpmddhiv1
    ) %>%
    group_by(tbl, scenario.num, scenario.new, scenario_name, sim) %>%
    summarise(
      across(c(starts_with("incid")), ~sum (.x, na.rm = T), .names = "{.col}.yr10"),
      across(c(contains("ir100"),starts_with("hivdiagCov"), starts_with("artCov"),
               "vSuppCov", starts_with("prepCov"), starts_with("mdd.diagever.prp"),
               num),
             ~ mean(.x, na.rm = T),
             .names = "{.col}.yr10")
    ) %>%
    mutate(
      ir.yr10 = incid.yr10 / 10000 * 100,
      ir2.yr10 = incid.yr10 / num.yr10 * 100
    ) %>%
    select(tbl, scenario.num, scenario.new, scenario_name, sim, ends_with(".yr10"))
}



#Function 2c: Get nia, pia    ----------------------------------------------------------
get_niapiannt <- function(d) {

  #d <- readRDS(paste0(save_dir, "/fulldata_mddtbl3B.rds"))
  # d0 <- d %>%
  #   filter(time > 5 * 52) %>%
  #   filter(scenario.new == "base") %>%
  #   select(tbl, scenario.num, scenario.new, scenario_name, sim, time, incid) %>%
  #   group_by(tbl, scenario.num, scenario.new, scenario_name, sim) %>%
  #   summarise(across(c(incid), ~ sum (.x, na.rm = T)))
  # base_incid <- median(d0$incid)

  d %>%
    filter(time > 5 * 52) %>%
    select(
      tbl, scenario.num, scenario.new, scenario_name, sim, time,
      incid, incid.mdd0, incid.mdd1,
      mdd.txcurr.numall, mdd.mhcare.numrcvanytx, mdd.txstart.numall
    ) %>%
    group_by(tbl, scenario.num, scenario.new, scenario_name, sim) %>%
    summarise(across(c(incid, incid.mdd0, incid.mdd1,
                       mdd.txcurr.numall, mdd.mhcare.numrcvanytx, mdd.txstart.numall),
                     ~ sum(.x, na.rm = TRUE)))  %>%
    arrange(tbl, sim, scenario.num) %>%
    group_by(tbl, sim) %>%
    mutate(base_incid = incid[1]) %>%
    mutate(
      nia = base_incid - incid,
      pia = (base_incid - incid) / base_incid
    ) %>%
    mutate(nnt_txcurr = mdd.txcurr.numall / nia,
           nnt_anytx = mdd.mhcare.numrcvanytx / nia,
           nnt_txstart = mdd.txstart.numall / nia) %>%
    ungroup() %>%
    select(tbl, scenario.num, scenario.new, scenario_name, sim, nia, pia,
           nnt_txcurr, nnt_anytx, nnt_txstart)
}





#Function 2d: Get mean outcomes over intervention period (mean/interv yr) ----------------
get_yrMu_outcomes <- function(d) {
  #d <- alldata
  d %>%
    filter(time > 5 * 52) %>%
    select(
      tbl, scenario.num, scenario.new, scenario_name, sim,
      contains("prp")
      # mde.active.numall, mdd.diagat.numall, mdd.txstart.numall, mdd.txcurr.numall,
      # mdd.ai.numall, mdd.uai.numall, mdd.ai.mde1.notx, mdd.ai.mde1.tx, mdd.ai.mde0,
      # mdd.uai.mde1.notx, mdd.uai.mde1.tx, mdd.uai.mde0
    ) %>%
    group_by(tbl, scenario.num, scenario.new, scenario_name, sim) %>%
    summarise(across(everything(),~ mean(.x, na.rm = T)))
}



#Function 2e: Get summed and average outcomes over intervention period -------------------
get_sumave_outcomes <- function(d) {
  #d <- alldata
  d %>%
    filter(time > 5 * 52) %>%
    select(
      tbl, scenario.num, scenario.new, scenario_name, sim,
      contains(".num"), contains(".tot"), contains("tot."),
      prepElig, prepCurr, mdd.PrEPstartsat,
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
      prep.all.stop, prep.rand.stop,
      mde.active.numall, mdd.diagat.numall, mdd.txstart.numall, mdd.txcurr.numall,
      mdd.ai.numall, mdd.uai.numall, mdd.ai.mde1.notx, mdd.ai.mde1.tx, mdd.ai.mde0,
      mdd.uai.mde1.notx, mdd.uai.mde1.tx, mdd.uai.mde0
    ) %>%
    # select(-c(mde.active.numall, mdd.diagat.numall, mdd.txstart.numall, mdd.txcurr.numall,
    #           mdd.ai.numall, mdd.uai.numall)) %>%
    group_by(tbl, scenario.num, scenario.new, scenario_name, sim) %>%
    summarise(across(everything(),~ sum(.x, na.rm = T) / 10))
}



#Function 2f: Get processed data ---------------------------------------------------------
get_outcome_sims <- function(d){

  d_cum       <- get_cumulative_outcomes(d)
  d_niapiannt    <- get_niapiannt(d)
  d_yr0       <- get_yr0_outcomes(d)
  d_yr10      <- get_yr10_outcomes(d)
  d_yrMu      <- get_yrMu_outcomes(d)
  d_yrmean    <- get_sumave_outcomes(d)

  #merge files
  d_join0a <- left_join(
    d_cum,
    d_niapiannt,
    by = c("tbl","scenario.num", "scenario.new","scenario_name", "sim")
  )

  d_join0b <- left_join(
    d_join0a,
    d_yr0,
    by = c("tbl","scenario.num", "scenario.new","scenario_name", "sim")
  )
  d_join0c <- left_join(
    d_join0b,
    d_yr10,
    by = c("tbl","scenario.num", "scenario.new","scenario_name", "sim")
  )
  d_join0d <- left_join(
    d_join0c,
    d_yrMu,
    by = c("tbl","scenario.num", "scenario.new","scenario_name", "sim")
  )

  left_join(
    d_join0d,
    d_yrmean,
    by = c("tbl","scenario.num", "scenario.new","scenario_name", "sim")
  )
}




