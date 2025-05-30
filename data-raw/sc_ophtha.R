# Dataset: sc
# Description: Create SC test SDTM dataset for ophthalmology studies

# Load libraries -----
library(dplyr)
library(metatools)

# Create sc ----
## Load required datasets ----
dm <- pharmaversesdtm::dm
sv <- pharmaversesdtm::sv

## Remove screen failures, they will not make it to drug infusion ---
dm1 <- dm %>%
  filter(ARMCD != "Scrnfail")

## Use subjects in DM  and info from SV Screening 1 visit ---
sc <- merge(dm1[, c("STUDYID", "USUBJID", "SUBJID", "RFSTDTC")],
  sv[sv$VISIT == "SCREENING 1", c("STUDYID", "USUBJID", "SVSTDTC", "VISIT")],
  by = c("STUDYID", "USUBJID")
)

## Create SC domain vars ----
sc$DOMAIN <- "SC"
sc$SCCAT <- "STUDY EYE SELECTION"
sc$SCTESTCD <- "FOCID"
sc$SCTEST <- "Focus of Study-Specific Interest"
sc$EPOCH <- "SCREENING"
sc$SCDTC <- sc$SVSTDTC
sc$SCDY <- as.numeric(as.Date(sc$SCDTC) - as.Date(sc$RFSTDTC))
# Even SUBJID numbers will have study eye assigned to Left;  odd to Right
sc$SCORRES <- if_else(as.integer(sc$SUBJID) %% 2 == 0, "Left Eye", "Right Eye")
sc$SCSTRESC <- if_else(as.integer(sc$SUBJID) %% 2 == 0, "OS", "OD")

## Create SCSEQ and keep relevant variables ----
sc_seq <- sc %>%
  group_by(STUDYID, USUBJID) %>%
  mutate(SCSEQ = row_number()) %>%
  select(
    "STUDYID", "DOMAIN", "USUBJID", "SCSEQ", "SCTESTCD", "SCTEST",
    "SCCAT", "SCORRES", "SCSTRESC", "EPOCH", "SCDTC", "SCDY"
  )

## Sort and variable labels -----
sc_ophtha <- sc_seq %>%
  ungroup() %>%
  # Sort data
  arrange(STUDYID, USUBJID, SCSEQ) %>%
  # Assign variable labels
  add_labels(
    STUDYID = "Study Identifier",
    DOMAIN = "Domain Abbreviation",
    USUBJID = "Unique Subject Identifier",
    SCSEQ = "Sequence Number",
    SCTESTCD = "Subject Characteristic Short Name",
    SCTEST = "Subject Characteristic",
    SCCAT = "Category for Subject Characteristic",
    SCORRES = "Result or Finding in Original Units",
    SCSTRESC = "Character Result/Finding in Std Format",
    EPOCH = "Epoch",
    SCDTC = "Date/Time of Collection",
    SCDY = "Study Day of Examination"
  )

# Dataset label ----
attr(sc_ophtha, "label") <- "Subject Characteristic"

# Save dataset
usethis::use_data(sc_ophtha, overwrite = TRUE)
