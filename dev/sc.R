# SC (ophthalmology)

library(dplyr)
library(metatools)

data("admiral_dm")
data("admiral_sv")

dm <- admiral_dm
sv <- admiral_sv

# Remove screen failures, they will not make it to drug infusion
dm1 <- dm %>%
  filter(ARMCD != "Scrnfail")


# Use subjects in DM  and info from SV  Screening 1 visit
sc <- merge(dm1[, c("STUDYID", "USUBJID", "SUBJID", "RFSTDTC")],
  sv[sv$VISIT == "SCREENING 1", c("STUDYID", "USUBJID", "SVSTDTC", "VISIT")],
  by = c("STUDYID", "USUBJID")
)

# Create SC domain var
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


# SCSEQ and keep relevant variables;
sc_seq <- sc %>%
  group_by(STUDYID, USUBJID) %>%
  mutate(SCSEQ = row_number()) %>%
  select(
    "STUDYID", "DOMAIN", "USUBJID", "SCSEQ", "SCTESTCD", "SCTEST",
    "SCCAT", "SCORRES", "SCSTRESC", "EPOCH", "SCDTC", "SCDY"
  )

sc <- sc_seq %>%
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

admiral_sc <- sc

# assign dataset label
attr(admiral_sc, "label") <- "Subject Characteristic"

# Save output
save(admiral_sc, file = "data/admiral_sc.rda", compress = "bzip2")
