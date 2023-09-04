# Datasets: ds, suppds
# Description: Standard DS, SUPPDS datasets from CDISC pilot study with added DSDECOD = RANDOMIZED rows

# Load libraries -----
library(dplyr)
library(tidyselect)
library(labelled)
library(admiral)
library(metatools)
library(haven)

# Create ds ----
data("dm")
sdtm_path <- "https://github.com/cdisc-org/sdtm-adam-pilot-project/blob/master/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm/" # nolint
raw_ds <- read_xpt(paste0(sdtm_path, "ds", ".xpt?raw=true"))
raw_suppds <- read_xpt(paste0(sdtm_path, "suppds", ".xpt?raw=true"))

## Converting blank to NA ----
dm <- convert_blanks_to_na(dm)
ds1a <- convert_blanks_to_na(raw_ds)
suppds1a <- convert_blanks_to_na(raw_suppds)

## Creating full DS data ----
ds1a <- ds1a %>%
  mutate(DSSEQ = as.character(DSSEQ))
ds1 <- combine_supp(ds1a, suppds1a) %>%
  mutate(DSSEQ = as.numeric(DSSEQ))

dsnames <- names(ds1a)

## Creating RANDOMIZED records ----
dm1 <- select(dm, c(STUDYID, USUBJID, RFSTDTC)) %>%
  filter(!is.na(RFSTDTC)) %>%
  mutate(
    DSTERM = "RANDOMIZED",
    DSDECOD = "RANDOMIZED",
    DSCAT = "PROTOCOL MILESTONE",
    DSDTC = RFSTDTC,
    DSSTDTC = RFSTDTC,
    DOMAIN = "DS",
    DSSEQ = 1,
    VISIT = "BASELINE",
    VISITNUM = 3.0,
    DSSTDY = 1
  )

ds2 <- bind_rows(ds1, select(dm1, -c(RFSTDTC)))

## Adding labels ----
dslab <- var_label(ds1a)
var_label(ds2) <- dslab

ds3 <- ds2 %>%
  arrange(STUDYID, USUBJID, DSSTDTC, DSCAT, DSDECOD) %>%
  group_by(STUDYID, USUBJID) %>%
  mutate(
    DSSEQ = row_number()
  ) %>%
  add_labels(
    DSSEQ = "Sequence Number"
  ) %>%
  ungroup()

ds4 <- ds3 %>%
  select(all_of(dsnames))

## Label dataset ----
attr(ds4, "label") <- "Disposition"

ds <- ds4

# Creating SUPPDS ----
suppds1 <- select(ds3, c("STUDYID", "USUBJID", "DSSEQ", "DOMAIN", "ENTCRIT")) %>%
  filter(!is.na(ENTCRIT))

suppds2 <- rename(suppds1, "RDOMAIN" = "DOMAIN") %>%
  mutate(
    "IDVARVAL" = as.character(DSSEQ),
    "IDVAR" = "DSSEQ",
    "QVAL" = ENTCRIT,
    "QNAM" = "ENTCRIT",
    "QLABEL" = "PROTOCOL ENTRY CRITERIA NOT MET",
    "QORIG" = "CRF"
  ) %>%
  select(STUDYID, RDOMAIN, USUBJID, IDVAR, IDVARVAL, QNAM, QLABEL, QVAL, QORIG)

## Adding labels ----
suppds3 <- suppds2 %>%
  add_labels(
    STUDYID = "Study Identifier",
    RDOMAIN = "Related Domain Abbreviation",
    USUBJID = "Unique Subject Identifier",
    IDVAR = "Identifying Variable",
    IDVARVAL = "Identifying Variable Value",
    QNAM = "Qualifier Variable Name",
    QLABEL = "Qualifier Variable Label",
    QVAL = "Data Value",
    QORIG = "Origin"
  )

## Label dataset ----
attr(suppds3, "label") <- "Supplemental Qualifiers for DS"

suppds <- suppds3

# Save datasets ----
usethis::use_data(ds, overwrite = TRUE)
usethis::use_data(suppds, overwrite = TRUE)
