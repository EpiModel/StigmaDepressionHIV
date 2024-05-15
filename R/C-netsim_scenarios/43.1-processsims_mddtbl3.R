##
## 42. Processing counterfactual scenarios - Table 3
##

# Setup ----------------------------------------------------------------------------------
context<-"hpc"


source("R/C-netsim_scenarios/43.2-processfxns_mddtbl3.R")


sims_dir <- paste0("data/intermediate/scenarios_mddtbl3")
save_dir <- paste0("data/intermediate/processed")


#get batch info
batches_infos <- EpiModelHPC::get_scenarios_batches_infos(
  paste0("data/intermediate/scenarios_mddtbl3")
)



install.packages("future.apply")
suppressMessages({
  library("EpiModelHIV")
  library("future.apply")
  library("tidyr")
  library("dplyr")
  library("ggplot2")
})




#A. Process raw sims -------------------------------------------------------------------
#get sim files
sim_files <- list.files(
  sims_dir,
  pattern = "^sim__.*rds$",
  full.names = TRUE
)



#Process each batch in parallel
intervds <- future.apply::future_lapply(
  sim_files,
  process_fulldata,
  ts = 3901 - (5 * 52) + 1   #gets data from 5 years prior to intervention start
)



#Merge all batches
fulldata <- bind_rows(intervds)

tblnam <- fulldata$tbl[nrow(fulldata)- 10]

saveRDS(fulldata, paste0(save_dir, "/fulldata_mddtbl3", tblnam,".rds"))




#B. Get outcome_sims  data  ------------------------------------------------------------
# get_dir <- paste0("C:/Users/Uonwubi/OneDrive - Emory University/Desktop/Personal/RSPH EPI Docs/RA2/GitRepos/StigmaDepressionHIV_real/data/intermediate/processed_05132024")
# save_dir <- paste0("C:/Users/Uonwubi/OneDrive - Emory University/Desktop/Personal/RSPH EPI Docs/RA2/GitRepos/StigmaDepressionHIV_real/data/intermediate/processed")
# source("R/C-netsim_scenarios/43.2-processfxns_mddtbl3.R")
# fulldata<-readRDS(paste(get_dir,'/fulldata_mddtbl3E.rds', sep=""))
# tblnam <- "E"

outcomessims <- get_outcome_sims(fulldata) %>%
  select(tbl, scenario.num, scenario.new, scenario_name,sim,
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

         mde.active.numall, mde.active.prpmdd,
         mde.active.prpmddhiv0, mde.active.prpmddhiv1,


         #mhcare-related
         mdd.diagever.prpmddall,
         mdd.diagever.prpmddhiv0, mdd.diagever.prpmddhiv1,

         mdd.eligdiagat.numgen, mdd.diagat.numgen, mdd.diagat.prpeliggen,
         mdd.PrEPstartsat, mdd.eligscrnat.numpstat, mdd.scrndat.numpstat, mdd.diagat.numpstat, mdd.diagat.prpeligpstat,
         #mdd.PrEPeligat,
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
         mdd.suitry.nummed,

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
         elig.prepStartGen, prepStartGen,
         elig.prepStartPart, prepStartPart,

         prep.all.stop, prep.rand.stop,


         #Intermediate impacts: PrEP & ART coverage
         #PrEP
         prepElig, prepCurr,
         prepCov.yr0, prepCov.yr10,
         prepCov.mdd0.yr0, prepCov.mdd0.yr10, prepCov.mdd1.yr0, prepCov.mdd1.yr10,
         prepCov.stigma1.yr0, prepCov.stigma1.yr10, prepCov.stigma2.yr0, prepCov.stigma2.yr10,
         prepCov.stigma3.yr0, prepCov.stigma3.yr10, prepCov.stigma4.yr0, prepCov.stigma4.yr10,

         #ART
         i.num, hivdiag, hivdiagCov.yr10,
         hivdiagCov.mdd0.yr10, hivdiagCov.mdd1.yr10,
         hivdiagCov.stigma1.yr10, hivdiagCov.stigma2.yr10, hivdiagCov.stigma3.yr10, hivdiagCov.stigma4.yr10,

         artCurr, artCov.yr10,
         artCov.mdd0.yr10, artCov.mdd1.yr10,
         artCov.stigma1.yr10, artCov.stigma2.yr10, artCov.stigma3.yr10, artCov.stigma4.yr10,

         vSupp, vSuppCov.yr10,

         #Mental Health needs
         mdd.diagever.prpmddall.yr0, mdd.diagever.prpmddall.yr10,
         mdd.diagever.prpmddhiv0.yr0, mdd.diagever.prpmddhiv0.yr10,
         mdd.diagever.prpmddhiv1.yr0, mdd.diagever.prpmddhiv1.yr10,

         #Distal impacts: HIV incidence measures
         ir.yr10, ir2.yr10, incid.cum, nia, pia,
         nnt_txcurr, nnt_anytx, nnt_minadeqtx, nnt_txstart,
         incid.yr10, ir100.yr10,

         incid.mdd0.cum, nia.mdd0, pia.mdd0, incid.mdd0.yr10, mdd.ir100.0.yr10,
         incid.mdd1.cum, nia.mdd1, pia.mdd1, incid.mdd1.yr10, mdd.ir100.1.yr10,

         incid.stigma1.cum, incid.stigma1.yr10, stigma.ir100.1.yr10,
         incid.stigma2.cum, incid.stigma2.yr10, stigma.ir100.2.yr10,
         incid.stigma3.cum, incid.stigma3.yr10, stigma.ir100.3.yr10,
         incid.stigma4.cum, incid.stigma4.yr10, stigma.ir100.4.yr10
  )
saveRDS(outcomessims, paste0(save_dir, "/outcomessims_mddtbl3", tblnam, ".rds"))




#C. Get outcome_sce  data  ------------------------------------------------------------
outcomessce <- outcomessims %>%
  select(- c(sim)) %>%
  group_by(tbl, scenario.num, scenario.new, scenario_name) %>%
  summarise(across(everything(),list(
    low = ~ quantile(.x, 0.025, na.rm = TRUE),
    med = ~ quantile(.x, 0.50, na.rm = TRUE),
    high = ~ quantile(.x, 0.975, na.rm = TRUE)
  ),
  .names = "{.col}__{.fn}"
  )) %>%
  mutate(across(where(is.numeric), ~round (., 5))) %>% ungroup()%>%
  arrange(tbl, scenario.num, scenario.new, scenario_name)
saveRDS(outcomessce, paste0(save_dir, "/outcomessce_mddtbl3", tblnam, ".rds"))
