# Update DS by adding DSDECOD=RANDOMIZED rows

library(dplyr)
library(tidyselect)
library(labelled)
library(admiral)
library(metatools)

data("admiral_dm")
data("raw_ds")
data("raw_suppds")

# Converting blank to NA
dm <- convert_blanks_to_na(admiral_dm)
ds1a <- convert_blanks_to_na(raw_ds)
suppds1a <- convert_blanks_to_na(raw_suppds)

# Creating full DS data
ds1a <- ds1a %>%
  mutate(DSSEQ = as.character(DSSEQ))
ds1 <- combine_supp(ds1a, suppds1a) %>%
  mutate(DSSEQ = as.numeric(DSSEQ))

# Creating RANDOMIZED records
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

# Adding labels
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

# Creating SUPPDS
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
  )

suppds <- select(
  suppds2,
  c(
    STUDYID, RDOMAIN, USUBJID,
    IDVAR, IDVARVAL, QNAM, QLABEL,
    QVAL, QORIG
  )
)

admiral_suppds <- suppds %>% add_labels(
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

attr(admiral_suppds, "label") <- "Supplemental Disposition"

# Creating DS
dsnames <- names(ds1a)
admiral_ds <- select(ds3, all_of(dsnames))

attr(admiral_ds, "label") <- "Disposition"

save(admiral_ds, file = "data/admiral_ds.rda", compress = "bzip2")
save(admiral_suppds, file = "data/admiral_suppds.rda", compress = "bzip2")
