# Dataset: ft_neuro
# Description: Create FT test SDTM dataset for Alzheimer's Disease (Neuro),
#   containing item-level Mini-Mental State Examination (MMSE) results.
# Note: Under CDISC Controlled Terminology the MMSE is a Functional Test
#   (codelists C100142/C100141), so it is stored in FT (SDTMIG v3.3+).
# Note: Only the 30 collected item results are included (serial 7s path for
#   attention). The attention subtotal (MMS104) and total score (MMS112) are left
#   for ADaM derivation.
# Note: FTORRES holds the CRF response (CORRECT, INCORRECT); FTSTRESC/FTSTRESN hold
#   the item score (1, 0). CDISC CT has no MMSE response codelist.
# Note: The MMSE is copyrighted by Psychological Assessment Resources (PAR). Only
#   CDISC test names are used; all values are simulated and are for not-for-profit
#   use within `pharmaverse`-related examples/documentation only.
# Note: rs_neuro.R must run first. Each subject's MMSE is simulated from their CDR
#   Sum of Boxes at the same visit, so the two datasets stay consistent.

# Load libraries ----
library(admiral)
library(dplyr)
library(tibble)
library(tidyr)
library(purrr)
library(cli)

# Read input data ----
dm_neuro <- convert_blanks_to_na(pharmaversesdtm::dm_neuro)
nv_neuro <- convert_blanks_to_na(pharmaversesdtm::nv_neuro)
rs_neuro <- convert_blanks_to_na(pharmaversesdtm::rs_neuro)

set.seed(2026)

# Visit schedule ----
# Same structure as rs_neuro: NV visits, earliest date within each subject-visit
planned_days <- tribble(
  ~VISITNUM, ~VISITDY,
  3, 1,
  9, 84,
  13, 182
)

visit_schedule <- nv_neuro %>%
  distinct(STUDYID, USUBJID, VISITNUM, VISIT, NVDTC, NVDY) %>%
  group_by(USUBJID, VISITNUM) %>%
  arrange(NVDTC, .by_group = TRUE) %>%
  slice(1) %>%
  ungroup() %>%
  rename(FTDTC = NVDTC, FTDY = NVDY) %>%
  mutate(FTDY = as.numeric(FTDY))

# Severity from CDR ----
# CDR Sum of Boxes per subject-visit is used only to drive the simulation; it is
# not stored in FT. Where the CDR was not done, the previous visit's value is
# carried forward.
cdr_sb <- rs_neuro %>%
  filter(RSCAT == "CDR", !is.na(RSSTRESN)) %>%
  group_by(USUBJID, VISITNUM) %>%
  summarise(cdr_sb = sum(RSSTRESN), .groups = "drop")

ft_frame <- visit_schedule %>%
  inner_join(
    select(dm_neuro, USUBJID, ARMNRS, RFSTDTC, RFXSTDTC),
    by = "USUBJID"
  ) %>%
  left_join(planned_days, by = "VISITNUM") %>%
  left_join(cdr_sb, by = c("USUBJID", "VISITNUM")) %>%
  group_by(USUBJID) %>%
  arrange(VISITNUM, .by_group = TRUE) %>%
  fill(cdr_sb, .direction = "down") %>%
  ungroup() %>%
  mutate(
    # Planned study day only applies to randomized subjects
    VISITDY = if_else(is.na(ARMNRS), VISITDY, NA_real_)
  )

if (any(is.na(ft_frame$cdr_sb))) {
  cli_abort("Every MMSE subject-visit needs a CDR Sum of Boxes value.")
}

# MMSE items ----
# 30 binary items (serial 7s path for attention). weight = relative vulnerability
# in AD: delayed recall and temporal orientation fail first, naming and reading last.
mmse_items <- tribble(
  ~FTTESTCD, ~FTTEST, ~weight,
  "MMS101A", "MMS1-What Is the Year", 1.0,
  "MMS101B", "MMS1-What Is the Season", 0.9,
  "MMS101C", "MMS1-What Is the Month of Year", 1.2,
  "MMS101D", "MMS1-What Is the Day of Week", 1.4,
  "MMS101E", "MMS1-What Is the Date", 1.6,
  "MMS102A", "MMS1-What Is the State", 0.4,
  "MMS102B", "MMS1-What Is the County", 0.9,
  "MMS102C", "MMS1-What Is the City/Town", 0.5,
  "MMS102D", "MMS1-What Is the Building", 0.6,
  "MMS102E", "MMS1-What Is the Floor", 0.9,
  "MMS103A", "MMS1-Repeat Word 1", 0.25,
  "MMS103B", "MMS1-Repeat Word 2", 0.25,
  "MMS103C", "MMS1-Repeat Word 3", 0.25,
  "MMS104AA", "MMS1-What is 100 Take Away 7", 0.8,
  "MMS104AB", "MMS1-Keep Subtracting 7 Step 2", 1.2,
  "MMS104AC", "MMS1-Keep Subtracting 7 Step 3", 1.3,
  "MMS104AD", "MMS1-Keep Subtracting 7 Step 4", 1.4,
  "MMS104AE", "MMS1-Keep Subtracting 7 Step 5", 1.5,
  "MMS105A", "MMS1-Recall Word 1", 2.0,
  "MMS105B", "MMS1-Recall Word 2", 2.0,
  "MMS105C", "MMS1-Recall Word 3", 2.0,
  "MMS106A", "MMS1-Naming Object 1", 0.15,
  "MMS106B", "MMS1-Naming Object 2", 0.15,
  "MMS107", "MMS1-Repeat What I Say", 0.6,
  "MMS108A", "MMS1-Take in Right Hand", 0.35,
  "MMS108B", "MMS1-Fold in Half", 0.35,
  "MMS108C", "MMS1-Put on Floor (or Table)", 0.35,
  "MMS109", "MMS1-Read This and Do What It Says", 0.2,
  "MMS110", "MMS1-Write a Sentence", 0.35,
  "MMS111", "MMS1-Copy This Design", 0.7
)

# Item score to CRF response text
mmse_responses <- tribble(
  ~score, ~FTORRES,
  1, "CORRECT",
  0, "INCORRECT"
)

# Simulate a total, then mark (30 - total) items incorrect one at a time,
# favouring vulnerable items, so the 30 items always sum to the simulated total
allocate_mmse <- function(total, weight) {
  score <- rep(1, length(weight))
  deficit <- 30 - total
  while (deficit > 0) {
    i <- sample(seq_along(score), size = 1, prob = weight * score)
    score[i] <- 0
    deficit <- deficit - 1
  }
  score
}

# MMSE total from CDR Sum of Boxes: about 29 when unimpaired, about 20 at CDR-SB 9
ft_scores <- ft_frame %>%
  mutate(
    total = pmin(pmax(round(29.3 - 1.0 * cdr_sb + rnorm(n(), mean = 0, sd = 1.5)), 0), 30),
    FTTESTCD = list(mmse_items$FTTESTCD),
    score = map(total, ~ allocate_mmse(.x, mmse_items$weight))
  ) %>%
  unnest(c(FTTESTCD, score)) %>%
  left_join(select(mmse_items, FTTESTCD, FTTEST), by = "FTTESTCD") %>%
  mutate(FTCAT = "MMSE") %>%
  select(
    STUDYID, USUBJID, RFSTDTC, RFXSTDTC, FTCAT, FTTESTCD, FTTEST, score, total,
    VISITNUM, VISIT, VISITDY, FTDTC, FTDY
  )

# Value checks (before introducing missing data) ----
if (!all(ft_scores$score %in% c(0, 1))) {
  cli_abort("MMSE item scores must be 0 or 1.")
}
item_check <- ft_scores %>%
  group_by(USUBJID, VISITNUM) %>%
  summarise(n = n(), sum_items = sum(score), total = first(total), .groups = "drop")
if (any(item_check$n != 30)) {
  cli_abort("Each MMSE administration must have exactly 30 items.")
}
if (any(item_check$sum_items != item_check$total)) {
  cli_abort("MMSE items do not sum to the simulated total.")
}

# Missing data example ----
# MMSE Copy This Design not done for 01-701-1392 at WEEK 12
ft_scores <- ft_scores %>%
  mutate(
    item_nd = USUBJID == "01-701-1392" & VISIT == "WEEK 12" & FTTESTCD == "MMS111",
    score = if_else(item_nd, NA_real_, score),
    FTSTAT = if_else(item_nd, "NOT DONE", NA_character_),
    FTREASND = if_else(item_nd, "PHYSICALLY UNABLE", NA_character_)
  ) %>%
  select(-item_nd, -total)

# Derive SDTM variables ----
# FTLOBXFL: last non-missing result on or before first exposure, per subject and
# test. Observational subjects have no exposure, so RFSTDTC is used instead.
ft_neuro <- ft_scores %>%
  left_join(mmse_responses, by = "score") %>%
  mutate(
    DOMAIN = "FT",
    FTSTRESC = if_else(is.na(score), NA_character_, as.character(score)),
    FTSTRESN = score,
    ref_date = as.Date(coalesce(RFXSTDTC, RFSTDTC)),
    pre_exposure = !is.na(FTSTRESN) & as.Date(FTDTC) <= ref_date
  ) %>%
  group_by(USUBJID, FTTESTCD) %>%
  mutate(
    FTLOBXFL = if_else(
      # "" guards against groups with no pre-exposure record
      pre_exposure & FTDTC == max(c(FTDTC[pre_exposure], "")),
      "Y", NA_character_
    )
  ) %>%
  ungroup() %>%
  arrange(USUBJID, VISITNUM, FTTESTCD) %>%
  group_by(USUBJID) %>%
  mutate(FTSEQ = row_number()) %>%
  ungroup() %>%
  select(
    STUDYID, DOMAIN, USUBJID, FTSEQ, FTTESTCD, FTTEST, FTCAT,
    FTORRES, FTSTRESC, FTSTRESN, FTSTAT, FTREASND, FTLOBXFL,
    VISITNUM, VISIT, VISITDY, FTDTC, FTDY
  )

# Result consistency check ----
# Each FTORRES text must match its FTSTRESN score
result_check <- ft_neuro %>%
  filter(!is.na(FTSTRESN)) %>%
  left_join(rename(mmse_responses, expected = FTORRES), by = c("FTSTRESN" = "score"))
if (any(result_check$FTORRES != result_check$expected) ||
  any(result_check$FTSTRESC != as.character(result_check$FTSTRESN))) {
  cli_abort("FTORRES, FTSTRESC and FTSTRESN are not consistent.")
}

# Structural checks ----
if (!all(nchar(ft_neuro$FTTESTCD) <= 8)) {
  cli_abort("The length of values in 'ft_neuro$FTTESTCD' must not exceed 8 characters.")
}

if (!all(ft_neuro$VISIT %in% c("BASELINE", "WEEK 12", "WEEK 26"))) {
  cli_abort("Unexpected VISIT values in 'ft_neuro'.")
}

dups <- ft_neuro %>%
  count(USUBJID, FTTESTCD, VISITNUM) %>%
  filter(n > 1)
if (nrow(dups) > 0) {
  cli_abort("Duplicate records found for some subject/test/visit combinations.")
}

lobx <- ft_neuro %>%
  filter(FTLOBXFL == "Y") %>%
  count(USUBJID, FTTESTCD) %>%
  filter(n > 1)
if (nrow(lobx) > 0) {
  cli_abort("More than one FTLOBXFL = 'Y' record per subject and test.")
}

# Assign labels ----
labels <- list(
  STUDYID = "Study Identifier",
  DOMAIN = "Domain Abbreviation",
  USUBJID = "Unique Subject Identifier",
  FTSEQ = "Sequence Number",
  FTTESTCD = "Short Name of Test",
  FTTEST = "Name of Test",
  FTCAT = "Category",
  FTORRES = "Result or Finding in Original Units",
  FTSTRESC = "Character Result/Finding in Std Format",
  FTSTRESN = "Numeric Result/Finding in Standard Units",
  FTSTAT = "Completion Status",
  FTREASND = "Reason Not Done",
  FTLOBXFL = "Last Observation Before Exposure Flag",
  VISITNUM = "Visit Number",
  VISIT = "Visit Name",
  VISITDY = "Planned Study Day of Visit",
  FTDTC = "Date/Time of Test",
  FTDY = "Study Day of Test"
)

for (var in names(labels)) {
  attr(ft_neuro[[var]], "label") <- labels[[var]]
}

attr(ft_neuro, "label") <- "Functional Tests"

# Save dataset ----
usethis::use_data(ft_neuro, overwrite = TRUE)
