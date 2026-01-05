# Dataset: lb_neuro
# Description: Create LB test SDTM dataset for Alzheimer's Disease (Neuro)

# Load libraries
library(admiral)
library(dplyr)

# Read input data
dm_neuro <- pharmaversesdtm::dm_neuro
nv_neuro <- pharmaversesdtm::nv_neuro

# Convert blank to NA
dm_neuro <- convert_blanks_to_na(dm_neuro)

# Select patients from DM Neuro only (following adsl_neuro.R pattern)
# Separate randomized group to identify which subjects don't have planned study days
randomized_group <- dm_neuro %>%
  # Subjects with non-missing ARMNRS are randomized, otherwise from observational study
  filter(is.na(ARMNRS)) %>%
  select(USUBJID) %>%
  pull()

# Get visit schedule from NV data for all visits
visit_schedule <- nv_neuro %>%
  filter(VISIT == "BASELINE") %>%
  select(USUBJID, VISITNUM, VISIT, NVDTC, NVDY) %>%
  group_by(USUBJID, VISIT) %>%
  arrange(as.Date(NVDTC)) %>%
  slice(1) %>%
  ungroup() %>%
  rename(LBDTC = NVDTC, LBDY = NVDY) %>%
  mutate(
    VISITDY = if_else(
      USUBJID %in% randomized_group,
      as.numeric(LBDY),
      NA_real_
    ),
    LBDTC = as.character(LBDTC)
  ) %>%
  distinct()

# Get subject characteristics with treatment information from adsl_neuro ----
subject_chars <- dm_neuro %>%
  select(STUDYID, USUBJID, ARM, ARMCD) %>%
  mutate( # Create treatment groups for analysis (pattern as in nv_neuro.R)
    TRTGRP = case_when(
      ARM == "Placebo" ~ "PLACEBO_CONTROL",
      ARMCD == "Pbo" ~ "PLACEBO_CONTROL",
      ARMCD == "Xan_Hi" ~ "TREATMENT",
      is.na(ARMCD) ~ "PLACEBO_CONTROL"
    )
  )

# Create LB record for one subject-visit ----
create_lb_record <- function(usubjid, visitnum, visit, visitdy, lbdtc, lbdy, trtgrp) {
  # Define positive rates based on treatment group and visit
  pos_rate <- case_when(
    trtgrp == "PLACEBO_CONTROL" ~ 0.30, # 30% positive for placebo/control at all visits
    trtgrp == "TREATMENT" & visit == "BASELINE" ~ 0.30, # Assume baseline similar for all
    TRUE ~ 0.00 # Default
  )

  # Generate SAA result based on positive rate
  lborres <- if (runif(1) < pos_rate) "Positive" else "Negative"

  tibble(
    STUDYID = "CDISCPILOT01",
    DOMAIN = "LB",
    USUBJID = usubjid,
    LBSEQ = "missing",
    LBTESTCD = "ASYNASAA",
    LBTEST = "Alpha Synuclein Seed Amplification Assay (CSF)",
    LBCAT = "Biomarkers",
    LBORRES = lborres,
    LBORRESU = NA_character_,
    LBORNRLO = NA_character_,
    LBORNRHI = NA_character_,
    LBSTRESC = lborres,
    LBSTRESN = case_when(
      lborres == "Positive" ~ 1,
      lborres == "Negative" ~ 0,
      TRUE ~ NA_real_
    ),
    LBSTRESU = NA_character_,
    LBSTNRLO = NA_real_,
    LBSTNRHI = NA_real_,
    LBNRIND = NA_character_,
    LBBLFL = ifelse(visit == "BASELINE", "Y", NA_character_),
    VISITNUM = visitnum,
    VISIT = visit,
    VISITDY = visitdy,
    LBDTC = lbdtc,
    LBDY = lbdy
  )
}

# Set seed for reproducibility
set.seed(2774)

# Generate all LB records
all_lb_records <- visit_schedule %>%
  left_join(subject_chars, by = c("USUBJID")) %>%
  rowwise() %>%
  do(
    create_lb_record(
      usubjid = .$USUBJID,
      visitnum = .$VISITNUM,
      visit = .$VISIT,
      visitdy = .$VISITDY,
      lbdtc = .$LBDTC,
      lbdy = .$LBDY,
      trtgrp = .$TRTGRP
    )
  ) %>%
  ungroup()

# Create LB record for one subject-visit with pTau, Amyloid, and Ratio ----
create_lb_ratio_record <- function(usubjid, visitnum, visit, visitdy, lbdtc, lbdy, trtgrp) {
  # Define positive rates based on treatment group and visit for generating random results
  pos_rate <- case_when(
    trtgrp == "PLACEBO_CONTROL" ~ 0.30, # 30% positive for placebo/control at all visits
    trtgrp == "TREATMENT" & visit == "BASELINE" ~ 0.30, # Assume baseline similar for all
    TRUE ~ 0.00 # Default
  )

  # Generate random values for pTau and Amyloid in pg/mL (using uniform distribution for test data)
  amyloid_value <- runif(1, min = 0.8, max = 500.0) # Generate Amyloid value (0.8 to 500.0 pg/mL)
  ptau_value <- runif(1, min = 0.047, max = 10.000) # Generate pTau value (0.047 to 10.000 pg/mL)

  # Calculate the pTau / Amyloid ratio
  ratio_value <- ptau_value / amyloid_value

  # Generate results for pTau and Amyloid (just to match your previous format)
  ptau_lborres <- if (runif(1) < pos_rate) "Positive" else "Negative"
  amyloid_lborres <- if (runif(1) < pos_rate) "Positive" else "Negative"

  # Define result based on ratio value for LBORRES (Positive, Negative, Indeterminate)
  ratio_lborres <- case_when(
    ratio_value <= 0.00370 ~ "Negative", # Negative if result is less than or equal to 0.00370
    ratio_value >= 0.00738 ~ "Positive", # Positive if result is greater than or equal to 0.00738
    TRUE ~ "Indeterminate" # Indeterminate if result is between 0.00370 and 0.00738
  )

  # Create the record for Lumipulse G pTau 217 Plasma
  ptau_record <- tibble(
    STUDYID = "CDISCPILOT01",
    DOMAIN = "LB",
    USUBJID = usubjid,
    LBSEQ = "missing",
    LBTESTCD = "PTAU217",
    LBTEST = "Lumipulse G pTau 217 Plasma",
    LBCAT = "Biomarkers",
    LBORRES = ptau_lborres,
    LBORRESU = "pg/mL",
    LBORNRLO = NA_character_,
    LBORNRHI = NA_character_,
    LBSTRESC = ptau_lborres,
    LBSTRESN = ptau_value,
    LBSTRESU = "pg/mL",
    LBSTNRLO = NA_real_,
    LBSTNRHI = NA_real_,
    LBNRIND = NA_character_,
    LBBLFL = ifelse(visit == "BASELINE", "Y", NA_character_),
    VISITNUM = visitnum,
    VISIT = visit,
    VISITDY = visitdy,
    LBDTC = lbdtc,
    LBDY = lbdy
  )

  # Create the record for Lumipulse G β-Amyloid 1-42-N Plasma
  amyloid_record <- tibble(
    STUDYID = "CDISCPILOT01",
    DOMAIN = "LB",
    USUBJID = usubjid,
    LBSEQ = "missing",
    LBTESTCD = "ABETA42",
    LBTEST = "Lumipulse G β-Amyloid 1-42-N Plasma",
    LBCAT = "Biomarkers",
    LBORRES = amyloid_lborres,
    LBORRESU = "pg/mL",
    LBORNRLO = NA_character_,
    LBORNRHI = NA_character_,
    LBSTRESC = amyloid_lborres,
    LBSTRESN = amyloid_value,
    LBSTRESU = "pg/mL",
    LBSTNRLO = NA_real_,
    LBSTNRHI = NA_real_,
    LBNRIND = NA_character_,
    LBBLFL = ifelse(visit == "BASELINE", "Y", NA_character_),
    VISITNUM = visitnum,
    VISIT = visit,
    VISITDY = visitdy,
    LBDTC = lbdtc,
    LBDY = lbdy
  )

  # Create the record for Lumipulse G pTau 217/β-Amyloid 1-42 Plasma Ratio
  ratio_record <- tibble(
    STUDYID = "CDISCPILOT01",
    DOMAIN = "LB",
    USUBJID = usubjid,
    LBSEQ = "missing",
    LBTESTCD = "PTARATIO",
    LBTEST = "Lumipulse G pTau 217/β-Amyloid 1-42 Plasma Ratio",
    LBCAT = "Biomarkers",
    LBORRES = ratio_lborres,
    LBORRESU = NA_character_,
    LBORNRLO = NA_character_,
    LBORNRHI = NA_character_,
    LBSTRESC = ratio_lborres,
    LBSTRESN = ratio_value,
    LBSTRESU = NA_character_,
    LBSTNRLO = NA_real_,
    LBSTNRHI = NA_real_,
    LBNRIND = NA_character_,
    LBBLFL = ifelse(visit == "BASELINE", "Y", NA_character_),
    VISITNUM = visitnum,
    VISIT = visit,
    VISITDY = visitdy,
    LBDTC = lbdtc,
    LBDY = lbdy
  )

  # Combine all records into a single tibble
  combined_record <- bind_rows(ptau_record, amyloid_record, ratio_record)

  return(combined_record)
}

# Example of generating all LB records for a visit schedule ----
set.seed(2774)

# Generate all LB records by joining 'visit_schedule' and 'subject_chars' ----
all_lb_ratio_records <- visit_schedule %>%
  left_join(subject_chars, by = c("USUBJID")) %>%
  rowwise() %>%
  do(
    create_lb_ratio_record(
      usubjid = .$USUBJID,
      visitnum = .$VISITNUM,
      visit = .$VISIT,
      visitdy = .$VISITDY,
      lbdtc = .$LBDTC,
      lbdy = .$LBDY,
      trtgrp = .$TRTGRP
    )
  ) %>%
  ungroup()

# Add sequence numbers and finalize
lb_neuro <- bind_rows(all_lb_records, all_lb_ratio_records) %>%
  arrange(USUBJID, VISITNUM) %>%
  group_by(USUBJID) %>%
  mutate(LBSEQ = row_number()) %>%
  ungroup() %>%
  select(
    STUDYID, DOMAIN, USUBJID, LBSEQ, LBTESTCD, LBTEST, LBCAT,
    LBORRES, LBORRESU, LBORNRLO, LBORNRHI, LBSTRESC, LBSTRESN,
    LBSTRESU, LBSTNRLO, LBSTNRHI, LBNRIND, LBBLFL,
    VISITNUM, VISIT, VISITDY, LBDTC, LBDY
  )

# Validation checks
expected_visits <- c("BASELINE")
stopifnot(all(lb_neuro$VISIT %in% expected_visits))
stopifnot(all(lb_neuro$LBORRES %in% c("Positive", "Negative")))
stopifnot(all(nchar(lb_neuro$LBTESTCD) <= 8))

# Check for one record per subject per visit
visit_counts <- lb_neuro %>%
  count(USUBJID, VISIT) %>%
  filter(n > 1)

if (nrow(visit_counts) > 0) {
  warning("Duplicate records found for some subjects/visits")
}

# Assign labels for lb_neuro variables
labels <- list(
  STUDYID = "Study Identifier",
  DOMAIN = "Domain Abbreviation",
  USUBJID = "Unique Subject Identifier",
  LBSEQ = "Sequence Number",
  LBTESTCD = "Lab Test or Examination Short Name",
  LBTEST = "Lab Test or Examination Name",
  LBCAT = "Category for Lab Test",
  LBORRES = "Result or Finding in Original Units",
  LBORRESU = "Original Units",
  LBORNRLO = "Reference Range Lower Limit in Orig Unit",
  LBORNRHI = "Reference Range Upper Limit in Orig Unit",
  LBSTRESC = "Character Result/Finding in Std Format",
  LBSTRESN = "Numeric Result/Finding in Standard Units",
  LBSTRESU = "Standard Units",
  LBSTNRLO = "Reference Range Lower Limit-Std Units",
  LBSTNRHI = "Reference Range Upper Limit-Std Units",
  LBNRIND = "Reference Range Indicator",
  LBBLFL = "Baseline Flag",
  VISITNUM = "Visit Number",
  VISIT = "Visit Name",
  VISITDY = "Planned Study Day of Visit",
  LBDTC = "Date/Time of Specimen Collection",
  LBDY = "Study Day of Specimen Collection"
)

for (var in names(labels)) {
  attr(lb_neuro[[var]], "label") <- labels[[var]]
}

# Label dataset
attr(lb_neuro, "label") <- "Laboratory Test Results Dataset"

# Save dataset
usethis::use_data(lb_neuro, overwrite = TRUE)
