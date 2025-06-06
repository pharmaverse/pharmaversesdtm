# Dataset: PP
# Description: Create PP test SDTM dataset

# Load libraries ----
library(haven)
library(dplyr)
library(lubridate)
library(labelled)
library(admiral)

# Create pc ----
pc <- pharmaversesdtm::pc

## Calculate subjects with all missing ----
blq_usubjid <- pc %>%
  ungroup() %>%
  group_by(STUDYID, DOMAIN, USUBJID) %>%
  summarise(PPORRES = max(PCSTRESN, na.rm = TRUE))

## Remove from PC, subjects with all blq (placebos) ----
remove_usubjid <- blq_usubjid %>% filter(PPORRES == 0)

pc0 <- anti_join(pc, remove_usubjid, by = c("STUDYID", "DOMAIN", "USUBJID")) %>%
  rename(PPCAT = PCTEST, PPSPEC = PCSPEC)

pc1 <- pc0 %>%
  filter(PPSPEC == "PLASMA")

pc1u <- pc0 %>%
  filter(PPSPEC == "URINE")

# PP usually only present values for applicable subjects;
## Calculate Cmax ----
pp_cmax <- pc1 %>%
  group_by(STUDYID, DOMAIN, USUBJID, PPCAT, PPSPEC) %>%
  summarise(CMAX = max(PCSTRESN, na.rm = TRUE))

## Calculate Tmax ----
pp_tmax <- pc1 %>%
  group_by(STUDYID, DOMAIN, USUBJID, PPCAT, PPSPEC) %>%
  filter(PCSTRESN == max(PCSTRESN, na.rm = TRUE)) %>%
  arrange(STUDYID, DOMAIN, USUBJID, PCTPTNUM) %>%
  glimpse()

pp_tmax$TMAX <- pp_tmax$PCTPTNUM
pp_tmax <- subset(pp_tmax, select = c("STUDYID", "DOMAIN", "USUBJID", "PPCAT", "PPSPEC", "TMAX"))

## AUC 0_tlast ----
pc2 <- pc1
pc2$PCTPTNUM <- ifelse(pc1$PCTPTNUM == -0.5, 0, pc1$PCTPTNUM)
pc2 <- pc2 %>%
  filter(!is.na(PCSTRESN))

pc2$AUC <- 0

nrows <- dim(pc2)[1]
for (idx in 1:nrows) {
  if (idx != 1 && pc2$USUBJID[idx] == pc2$USUBJID[idx - 1]) {
    pc2$AUC[idx] <- (pc2$PCTPTNUM[idx] - pc2$PCTPTNUM[idx - 1]) * (pc2$PCSTRESN[idx] + pc2$PCSTRESN[idx - 1]) / 2 + pc2$AUC[idx - 1]
  }
}

pp_AUC <- pc2 %>%
  group_by(STUDYID, DOMAIN, USUBJID, PPCAT, PPSPEC) %>%
  summarise(AUC = max(AUC, na.rm = TRUE))

pc2 <- subset(pc2, select = -AUC)

# Elimination rate
pc3 <- merge(pc2, pp_tmax, by = c("STUDYID", "DOMAIN", "USUBJID", "PPCAT", "PPSPEC"))
pc3 <- pc3 %>% filter(PCTPTNUM >= TMAX)

pp_npts <- pc3 %>%
  group_by(STUDYID, DOMAIN, USUBJID, PPCAT, PPSPEC) %>%
  summarise(npts = n())

## Break up pc3 by usubjid, then fit the specified model to each piece ----
# return a list
models <- plyr::dlply(pc3, c("STUDYID", "DOMAIN", "USUBJID", "PPCAT", "PPSPEC"), function(df) {
  lm(-log(PCSTRESN, base = exp(1)) ~ PCTPTNUM, data = df)
})
# summarym2=lapply(models,summary)
# lapply(summarym2,"[[","adj.r.squared") #This provides the Rs
# Apply coef to each model and return a data frame
pp_Ke <- plyr::ldply(models, coef)
pp_Ke$Ke <- pp_Ke$PCTPTNUM
pp_Ke <- subset(pp_Ke, select = c("STUDYID", "DOMAIN", "USUBJID", "PPCAT", "PPSPEC", "Ke"))


## Halflife ----
pp_lambda <- pp_Ke
pp_lambda$lambda <- 0.693 / pp_lambda$Ke
pp_lambda <- subset(pp_lambda, select = c("STUDYID", "DOMAIN", "USUBJID", "PPCAT", "PPSPEC", "lambda"))

## AUC_0_inf ----
pc4 <- pc3 %>%
  group_by(STUDYID, DOMAIN, USUBJID, PPCAT, PPSPEC) %>%
  mutate(min = min(PCSTRESN, na.rm = TRUE))

pp_Clast <- pc4
pp_Clast$Clast <- pp_Clast$min
pp_Clast <- subset(pp_Clast, select = c("STUDYID", "DOMAIN", "USUBJID", "PPCAT", "PPSPEC", "Clast"))

pc5 <- merge(pc4, pp_Ke, by = c("STUDYID", "DOMAIN", "USUBJID", "PPCAT", "PPSPEC"))
pp_AUC_inf <- merge(pc5, pp_AUC, by = c("STUDYID", "DOMAIN", "USUBJID", "PPCAT", "PPSPEC"))

pp_AUC_inf$AUC_inf <- pp_AUC_inf$AUC + (pp_AUC_inf$min) / pp_AUC_inf$Ke
pp_AUC_inf <- subset(pp_AUC_inf, select = c("STUDYID", "DOMAIN", "USUBJID", "PPCAT", "PPSPEC", "AUC_inf"))

# Urine parameters
# Ae
pp_Ae <- pc1u %>%
  group_by(STUDYID, DOMAIN, USUBJID, PPCAT, PPSPEC) %>%
  summarise(pp_Ae = sum(PCSTRESN, na.rm = TRUE)) %>%
  glimpse()

# CLR
pp_AUC_sub <- subset(pp_AUC, select = c("STUDYID", "DOMAIN", "USUBJID", "PPCAT", "AUC"))
pp_CLR <- merge(pp_Ae, pp_AUC_sub, by = c("STUDYID", "DOMAIN", "USUBJID", "PPCAT")) %>%
  mutate(pp_CLR = pp_Ae / AUC * 1000 / 60) %>%
  glimpse()

## Add all require variables -----
pp_AUC$PPTESTCD <- "AUCLST"
pp_AUC$PPTEST <- "AUC to Last Nonzero Conc"
pp_AUC$PPORRESU <- "h*ug/ml"
pp_AUC$PPORRES <- pp_AUC$AUC

pp_AUC_inf$PPTESTCD <- "AUCALL"
pp_AUC_inf$PPTEST <- "AUC All"
pp_AUC_inf$PPORRESU <- "h*ug/ml"
pp_AUC_inf$PPORRES <- pp_AUC_inf$AUC_inf

pp_Clast$PPTESTCD <- "CLST"
pp_Clast$PPTEST <- "Last Nonzero Conc"
pp_Clast$PPORRESU <- "ug/ml"
pp_Clast$PPORRES <- pp_Clast$Clast

pp_cmax$PPTESTCD <- "CMAX"
pp_cmax$PPTEST <- "Max Conc"
pp_cmax$PPORRESU <- "ug/ml"
pp_cmax$PPORRES <- pp_cmax$CMAX

pp_Ke$PPTESTCD <- "LAMZ"
pp_Ke$PPTEST <- "Lambda z"
pp_Ke$PPORRESU <- "/h"
pp_Ke$PPORRES <- pp_Ke$Ke

pp_lambda$PPTESTCD <- "LAMZHL"
pp_lambda$PPTEST <- "Half-Life Lambda z"
pp_lambda$PPORRESU <- "h"
pp_lambda$PPORRES <- pp_lambda$lambda

pp_npts$PPTESTCD <- "LAMZNPT"
pp_npts$PPTEST <- "Number of Points for Lambda z"
pp_npts$PPORRESU <- "U"
pp_npts$PPORRES <- pp_npts$npts

pp_tmax$PPTESTCD <- "TMAX"
pp_tmax$PPTEST <- "Time of CMAX"
pp_tmax$PPORRESU <- "h"
pp_tmax$PPORRES <- pp_tmax$TMAX
# R2ADJ	C85553	R Squared Adjusted

# Urine parameters
pp_Ae$PPTESTCD <- "RCAMINT"
pp_Ae$PPTEST <- "Ae"
pp_Ae$PPORRESU <- "mg"
pp_Ae$PPORRES <- pp_Ae$pp_Ae

pp_CLR$PPTESTCD <- "RENALCL"
pp_CLR$PPTEST <- "CLR"
pp_CLR$PPORRESU <- "mL/min"
pp_CLR$PPORRES <- pp_CLR$pp_CLR


## Join all data ----
PP <- bind_rows(pp_tmax, pp_npts, pp_lambda, pp_Ke, pp_cmax, pp_Clast, pp_AUC, pp_AUC_inf, pp_Ae, pp_CLR)

# Constant variables
PP$PPSTRESC <- as.character(PP$PPORRES)
PP$PPSTRESN <- PP$PPORRES
PP$PPSTRESU <- PP$PPORRESU
PP$PPORRES <- as.character(PP$PPORRES)

PP$DOMAIN <- "PP"

## Sort ----
pp <- PP %>%
  arrange(STUDYID, USUBJID, PPTESTCD)

## PPSEQ ----
pp <- pp %>%
  group_by(STUDYID, USUBJID) %>%
  mutate(PPSEQ = row_number())

## Load ex to add the reference time (EXSTDTC) ----
ex <- pharmaversesdtm::ex

## Only use baseline ----
ex1 <- ex %>%
  filter(VISIT == "BASELINE")

## Select needed exvars ----
ex2 <- subset(ex1, select = c("STUDYID", "USUBJID", "EXSTDTC"))

## Merge pp and ex ----
pp <- merge(pp, ex2, by = c("STUDYID", "USUBJID"))
pp$PPRFDTC <- pp$EXSTDTC

## Subset pp vars -----
pp <- subset(pp, select = c(
  "STUDYID", "DOMAIN", "USUBJID", "PPSEQ", "PPTESTCD", "PPTEST", "PPCAT",
  "PPORRES", "PPORRESU", "PPSTRESC", "PPSTRESN", "PPSTRESU", "PPSPEC", "PPRFDTC"
))

# Label pp ----
pp <- pp %>%
  set_variable_labels(
    STUDYID = "Study Identifier",
    DOMAIN = "Domain Abbreviation",
    USUBJID = "Unique Subject Identifier",
    PPSEQ = "Sequence Number",
    PPTESTCD = "Parameter Short Name",
    PPTEST = "Parameter Name",
    PPCAT = "Parameter Category",
    PPORRES = "Result or Finding in Original Units",
    PPORRESU = "Original Units",
    PPSTRESC = "Character Result/Finding in Std Format",
    PPSTRESN = "Numeric Result/Finding in Standard Units",
    PPSTRESU = "Standard Units",
    PPSPEC = "Specimen Material Type",
    PPRFDTC = "Date/Time of Reference Point"
  )

# Label dataset ----
attr(pp, "label") <- "Pharmacokinetics Parameters"

# Save dataset ----
usethis::use_data(pp, overwrite = TRUE)
