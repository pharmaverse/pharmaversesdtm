# Add new variables to MH
library(metatools)

data("admiral_dm")
data("raw_mh")

# Convert blank to NA
dm <- convert_blanks_to_na(admiral_dm) %>%
  select(STUDYID, USUBJID, RFSTDTC, RFENDTC, RFXSTDTC, RFXENDTC)
mh <- convert_blanks_to_na(raw_mh)
# Set seed so that result stays the same for each run
set.seed(1)
ran_int <- sample.int(400, nrow(raw_mh), replace = TRUE)


admiral_mh <- mh %>%
  # Add MHENDTC
  mutate(MHENDTC = as.character(as.Date(MHSTDTC) + days(ran_int))) %>%
  # Add MHPRESP
  mutate(MHPRESP = ifelse(MHTERM == "ALZHEIMER'S DISEASE", "Y", NA_character_)) %>%
  # Add MHOCCUR
  mutate(MHOCCUR = case_when(
    MHPRESP == "Y" & !is.na(MHSTDTC) ~ "Y",
    MHPRESP == "Y" & is.na(MHSTDTC) ~ "N",
    MHPRESP == "N" ~ NA_character_
  )) %>%
  left_join(dm, by = c("STUDYID", "USUBJID")) %>%
  # Add MHSTRTPT
  mutate(MHSTRTPT = if_else(MHTERM == "ALZHEIMER'S DISEASE", NA_character_,
    "BEFORE"
  )) %>%
  # Add MHENRTPT
  mutate(MHENRTPT = if_else(as.Date(MHENDTC) < as.Date(RFXSTDTC),
    "BEFORE", "ONGOING"
  )) %>%
  # Add MHSTTPT
  mutate(MHSTTPT = if_else(MHTERM == "ALZHEIMER'S DISEASE", NA_character_,
    "SCREENING"
  )) %>%
  # Add MHENTPT
  mutate(MHENTPT = if_else(MHTERM == "ALZHEIMER'S DISEASE", "SCREENING",
    "FIRST DOSE OF STUDY DRUG"
  )) %>%
  # Add MHENRF
  mutate(MHENRF = case_when(
    as.Date(MHENDTC) < as.Date(RFSTDTC) ~ "BEFORE",
    as.Date(MHENDTC) > as.Date(RFENDTC) ~ "AFTER",
    is.na(MHENDTC) ~ NA_character_,
    TRUE ~ "DURING"
  )) %>%
  # Add MHSTAT
  mutate(MHSTAT = ifelse(MHPRESP == "Y" & is.na(MHOCCUR), "NOT DONE",
    NA_character_
  )) %>%
  # Remove variables from DM
  select(-c("RFSTDTC", "RFENDTC", "RFXSTDTC", "RFXENDTC")) %>%
  # Variable labels
  add_labels(
    MHENDTC = "End Date/Time of Medical History Event",
    MHPRESP = "Medical History Event Pre-Specified",
    MHOCCUR = "Medical History Occurrence",
    MHSTTPT = "Start Reference Time Point",
    MHENTPT = "End Reference Time Point",
    MHSTRTPT = "Start Relative to Reference Time Point",
    MHENRTPT = "End Relative to Reference Time Point",
    MHENRF = "End Relative to Reference Period",
    MHSTAT = "Completion Status"
  )

attr(admiral_mh, "label") <- "Medical History"
save(admiral_mh, file = "data/admiral_mh.rda", compress = "bzip2")
