# Dataset: is_ada
# Description: Create IS SDTM dataset for ADA analysis
#
# Includes ISBDAGNT and ISTESTCD/ISTEST assigned for SDTMIG v3.4.
# To use with SDTMIG v3.3, could use ISBDAGNT to assign to ISTESTCD/ISTEST
#
# PLACEBO subjects purposely only have BASELINE data.
# Creates a mix of Baseline pos/neg, Post-Baseline pos/neg, plus some missing visits


# Load libraries ----
library(haven)
library(plyr)
library(dplyr)
library(lubridate)
library(labelled)
library(admiral)

# Create is starting with ex and dm ----
ex <- pharmaversesdtm::ex
dm <- pharmaversesdtm::dm

## set seed to get same results each run ----
set.seed(999)

## Remove screen failures, they will not make it to drug infusion ----
dm1 <- dm %>%
  filter(ARMCD != "Scrnfail")

## use subjects in both datasets (ex,dm1) to create IS ----
dmex1 <- merge(dm1[, c(1, 3)], ex, by = c("STUDYID", "USUBJID"))


# Get unique USUBJID and assign them an random ADACAT and NABCAT

allsubs <- dmex1 %>%
  distinct(USUBJID)

subrows <- dim(allsubs)[1]
noise_group <- runif(n = subrows, min = 1, max = 7)
allsubs$ADACAT <- floor(noise_group)
noise_group <- runif(n = subrows, min = 1, max = 7)
allsubs$NABCAT <- floor(noise_group)

allsubs %>%
  group_by(ADACAT) %>%
  summarize(n = n()) %>%
  print(n = 100)


allsubs %>%
  group_by(NABCAT) %>%
  summarize(n = n()) %>%
  print(n = 100)


# Merge allsubs back into dmex1

dmex2 <- dmex1 %>%
  derive_vars_merged(
    dataset_add = allsubs,
    by_vars = exprs(USUBJID)
  )

# Use noise and compute random titer values (in K and V)
nrows <- dim(dmex2)[1]

noise1 <- runif(n = nrows, min = 1.35, max = 1.6)
noise2 <- runif(n = nrows, min = 2.0, max = 3.0)

dmex2$K <- noise1
dmex2$V <- noise2


## Assign ADASTAT types based on ADACAT
# If Placebo, only keep VISITDY=1
# Group 1 and 2:  Neg to Neg
# Group 3 = Neg to Pos
# Group 4 and 5 = Pos to Not Pos
# Group 6: Pos to Pos

dmex3 <- dmex2 %>%
  mutate(
    titer = case_when(
      ADACAT <= 2 ~ NA_real_,
      ADACAT == 3 ~ K,
      ADACAT <= 5 ~ K,
      ADACAT == 6 ~ V,
      TRUE ~ NA_real_
    ),
    titer_orig = titer,
    titer = case_when(
      ADACAT == 3 & VISITDY == 1 ~ NA_real_,
      ADACAT == 6 & VISITDY == 1 ~ K,
      TRUE ~ titer
    ),
    titer = round(signif(titer, 3), 3),
    t = -0.5
  )

IS_PLACEBO <- dmex3 %>%
  filter(EXTRT == "PLACEBO" & VISITDY == 1)

IS_ACTIVE <- dmex3 %>%
  filter(!EXTRT == "PLACEBO")

PRE_IS <- rbind(IS_PLACEBO, IS_ACTIVE) %>%
  arrange(USUBJID, VISITDY) %>%
  mutate(
    ISSTRESN = titer,
    ISSTRESC = case_when(
      !is.na(ISSTRESN) & ISSTRESN < 1.40 ~ "<1.40",
      !is.na(ISSTRESN) ~ as.character(ISSTRESN),
      TRUE ~ "NEGATIVE"
    ),
    ISSTRESN = case_when(
      !is.na(ISSTRESN) & ISSTRESN < 1.40 ~ NA_real_,
      TRUE ~ ISSTRESN
    ),
    ISSTRESU = case_when(
      !is.na(ISSTRESN) ~ "titer",
      TRUE ~ NA_character_
    ),
    ISORRES = ISSTRESN,
    ISORRESU = ISSTRESU
  )

## Constant vars ----
PRE_IS$DOMAIN <- "IS"
PRE_IS$ISTESTCD <- "ADA_BAB"
PRE_IS$ISTEST <- "Binding Antidrug Antibody"
PRE_IS$ISBDAGNT <- "XANOMELINE"
PRE_IS$ISNAM <- "Imaginary Labs"
PRE_IS$ISSPEC <- "SERUM"
PRE_IS$ISTPTNUM <- PRE_IS$t
PRE_IS$ISTPT <- "Pre-dose"
PRE_IS$ISLLOQ <- NA_character_

## ISDTC, ISDY and VISITDY ----
PRE_IS$ISDTC <- format(as.Date(PRE_IS$EXSTDTC) + minutes(round(PRE_IS$t * 60)), "%Y-%m-%dT%H:%M:%S")
PRE_IS$ISDY <- ifelse(PRE_IS$VISITDY == 1, -1, PRE_IS$EXSTDY - 1)
PRE_IS$VISITDY_orig <- PRE_IS$VISITDY
PRE_IS$VISITDY <- ifelse(PRE_IS$VISITDY_orig == 1, -1, PRE_IS$VISITDY_orig - 1)

IS_view <- PRE_IS %>%
  select(USUBJID, EXTRT, ISSPEC, ISTESTCD, ISTEST, ISBDAGNT, VISIT, VISITNUM, VISITDY_orig, VISITDY, t, ISTPT, ISTPTNUM, EXSTDTC, ISDTC, EXSTDY, ISDY, ADACAT, ISSTRESN, ISSTRESC) %>%
  arrange(USUBJID, ISTEST, VISITNUM, ISTPTNUM)


## Set or remove to create some unusual situations then compute ISSEQ -------------

## Baseline Negative - No Post baseline data (USUBJID 01-701-1181 has this already)
## Baseline Positive - No Post-baseline data (USUBJID 01-703-1197 has this already)
## Baseline Missing -  One post baseline has Positive (use 01-704-1093)
## Baseline Missing -  No post baseline Positive (use 01-704-1120)
## Post Baseline has ISSTRESC="POSITIVE" with ISSTRESN = null

IS_ada <- PRE_IS %>%
  mutate(
    DROPIT = case_when(
      (USUBJID == "01-704-1093" | USUBJID == "01-704-1120") & VISIT == "BASELINE" ~ TRUE,
      TRUE ~ FALSE
    ),
    ISSTRESN = case_when(
      USUBJID == "01-704-1114" & VISIT == "WEEK 2" ~ NA_real_,
      TRUE ~ ISSTRESN
    ),
    ISORRES = case_when(
      USUBJID == "01-704-1114" & VISIT == "WEEK 2" ~ NA_real_,
      TRUE ~ ISORRES
    ),
    ISSTRESU = case_when(
      USUBJID == "01-704-1114" & VISIT == "WEEK 2" ~ NA_character_,
      TRUE ~ ISSTRESU
    ),
    ISORRESU = case_when(
      USUBJID == "01-704-1114" & VISIT == "WEEK 2" ~ NA_character_,
      TRUE ~ ISORRESU
    ),
    ISSTRESC = case_when(
      USUBJID == "01-704-1114" & VISIT == "WEEK 2" ~ "POSITIVE CONFIRMATION",
      TRUE ~ ISSTRESC
    ),
  ) %>%
  filter(DROPIT == FALSE) %>%
  group_by(STUDYID, USUBJID) %>%
  dplyr::mutate(ISSEQ = row_number()) %>%
  ungroup() %>%
  arrange(STUDYID, USUBJID, ISSEQ) %>%
  select(
    STUDYID, DOMAIN, USUBJID, ISSEQ, ISTESTCD, ISTEST, ISBDAGNT, VISIT, ADACAT, NABCAT, ISORRES, ISORRESU, ISSTRESC, ISSTRESN, ISSTRESU,
    ISNAM, ISSPEC, ISLLOQ, VISIT, VISITNUM, VISITDY, ISDTC, ISDY, ISTPT, ISTPTNUM
  )



# Compute NAB data --------------------------------------------------------


## Assign NAB results types based on random ADACAT and NABCAT
# NAB POS: ADACAT=4 and NABCAT=1 or ADACAT=6 and NABCAT=1
# Note: ADACAT 4 are 6 are ADA Positive categories.


IS_positive <- IS_ada %>%
  filter(ISSTRESC != "NEGATIVE") %>%
  mutate(
    ISSTRESC = case_when(
      (ADACAT == 4 | ADACAT == 6) & NABCAT == 1 ~ "POSITIVE",
      TRUE ~ "NEGATIVE"
    )
  )


IS_positive$ISTESTCD <- "ADA_NAB"
IS_positive$ISTEST <- "Neutralizing Binding Antidrug Antibody"
IS_positive$ISORRES <- NA_real_
IS_positive$ISORRESU <- NA_character_
IS_positive$ISSTRESN <- NA_real_
IS_positive$ISSTRESU <- NA_character_


# View all the unique ADA Analytes kept
IS_positive %>%
  group_by(ISTESTCD, ISTEST, ISBDAGNT, ISSTRESC) %>%
  summarize(n = n()) %>%
  print(n = 100)


# Set main IS_ada with  IS_positive

IS_ada <- rbind(IS_ada, IS_positive) %>%
  arrange(ISTESTCD, ISTEST, ISBDAGNT, USUBJID, VISITDY) %>%
  select(-ADACAT, -NABCAT)

IS_ada %>%
  group_by(ISTESTCD, ISTEST, ISBDAGNT, ISORRES, ISORRESU, ISSTRESC, ISSTRESN, ISSTRESU) %>%
  summarize(n = n()) %>%
  print(n = 100)


IS_ada %>%
  group_by(ISTESTCD, ISBDAGNT, VISIT, VISITNUM, ISTPT, ISTPTNUM) %>%
  summarize(n = n()) %>%
  print(n = 500)


## add labels ----
is_ada <- IS_ada %>%
  set_variable_labels(
    STUDYID = "Study Identifier",
    DOMAIN = "Domain Abbreviation",
    USUBJID = "Unique Subject Identifier",
    ISSEQ = "Sequence Number",
    ISTESTCD = "Immunogenicity Test/Exam Short Name",
    ISTEST = "Immunogenicity Test or Examination Name",
    ISBDAGNT = "Binding Agent",
    ISORRES = "Result or Finding in Original Units",
    ISORRESU = "Original Units",
    ISSTRESC = "Character Result/Finding in Std Format",
    ISSTRESN = "Numeric Results/Findings in Std. Units",
    ISSTRESU = "Standard Units",
    ISNAM = "Vendor Name",
    ISSPEC = "Specimen Type",
    ISLLOQ = "Lower Limit of Quantitation",
    VISIT = "Visit Name",
    VISITNUM = "Visit Number",
    VISITDY = "Planned Study Day of Visit",
    ISDTC = "Date/Time of Specimen Collection",
    ISDY = "Actual Study Day of Specimen Collection",
    ISTPT = "Planned Time Point Name",
    ISTPTNUM = "Planned Time Point Number"
  )

# Label dataset ----
attr(is_ada, "label") <- "Immunogenicity Specimen Assessments"

# Save dataset ----
usethis::use_data(is_ada, overwrite = TRUE)
