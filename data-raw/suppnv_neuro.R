# Dataset: suppnv_neuro
# Description: Create SUPPNV test SDTM dataset for Alzheimer's Disease (neuro studies)

library(admiral)
library(dplyr)

# Read input data ----

data("nv_neuro")

# Convert blank to NA ----

nv_neuro <- convert_blanks_to_na(nv_neuro)

suppnv_neuro <- nv_neuro %>%
  filter(!is.na(NVLOC)) %>%
  mutate(
    RDOMAIN = "NV", IDVAR = "NVSEQ", IDVARVAL = NVSEQ, QNAM = "REFREG",
    QLABEL = "Reference Region"
  ) %>%
  mutate(QVAL = case_when(
    NVCAT %in% c("FBP", "FBB") ~ "Whole Cerebellum",
    NVCAT == "FTP" ~ "Inferior Cerebellar Gray Matter",
    TRUE ~ NA_character_
  )) %>%
  mutate(QORIG = "Assigned", QEVAL = "STATISTICIAN") %>%
  select(STUDYID, RDOMAIN, USUBJID, IDVAR, IDVARVAL, QNAM, QLABEL, QVAL, QORIG, QEVAL)

# Add labels to variables ----

labels <- list(
  STUDYID = "Study Identifier",
  RDOMAIN = "Related Domain Abbreviation",
  USUBJID = "Unique Subject Identifier",
  IDVAR = "Identifying Variable",
  IDVARVAL = "Identifying Variable Value",
  QNAM = "Qualifier Variable Name",
  QLABEL = "Qualifier Variable Label",
  QVAL = "Data Value",
  QORIG = "Origin",
  QEVAL = "Evaluator"
)

for (var in names(labels)) {
  attr(suppnv_neuro[[var]], "label") <- labels[[var]]
}

# Label SUPPNV dataset ----

attr(suppnv_neuro, "label") <- "Supplemental Qualifiers for Nervous System Findings"

# Save dataset ----

usethis::use_data(suppnv_neuro, overwrite = TRUE)
