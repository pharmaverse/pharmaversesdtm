# Dataset: qs_neuro
# Description: Create QS test SDTM dataset for Alzheimer's Disease (Neuro),
#   containing item-level Clinical Dementia Rating (CDR) and Mini-Mental State
#   Examination (MMSE) data.
# Note: Test codes and names follow CDISC Controlled Terminology. Under current CT
#   the CDR is a Clinical Classification (RS, codelists C101811/C101812) and the
#   MMSE is a Functional Test (FT, codelists C100142/C100141). They are combined in
#   one QS dataset here for convenience as test data; a submission would map them
#   to RS and FT.
# Note: Only collected item-level records are included. Derived scores (CDR Sum of
#   Boxes, Global CDR, MMSE subtotal and total) are left for ADaM derivation.
# Note: The MMSE is copyrighted by Psychological Assessment Resources (PAR) and the
#   CDR by Washington University in St. Louis. Only CDISC test names are used; all
#   values are simulated and are for not-for-profit use within `pharmaverse`-related
#   examples/documentation only.

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

set.seed(2026)

# Visit schedule ----
# Use the NV visit structure (BASELINE, WEEK 12, WEEK 26) and take the earliest
# assessment date within each subject-visit, consistent with lb_neuro.
planned_days <- tribble(
  ~VISITNUM, ~VISITDY, ~TIME_FRAC,
  3, 1, 0,
  9, 84, 12 / 26,
  13, 182, 1
)

visit_schedule <- nv_neuro %>%
  distinct(STUDYID, USUBJID, VISITNUM, VISIT, NVDTC, NVDY) %>%
  group_by(USUBJID, VISITNUM) %>%
  arrange(NVDTC, .by_group = TRUE) %>%
  slice(1) %>%
  ungroup() %>%
  rename(QSDTC = NVDTC, QSDY = NVDY) %>%
  mutate(QSDY = as.numeric(QSDY))

# Subject-level disease severity ----
# z is a latent severity on roughly the CDR box scale (0 = unimpaired, 1 = mild
# dementia). Progression is expressed per 26 weeks and is slower on high dose.
# Two subjects are set near-unimpaired so that all-zero CDR profiles occur at
# baseline (Global CDR = 0 once derived in ADaM).
subjects <- dm_neuro %>%
  select(USUBJID, ARMCD, ARMNRS, RFSTDTC, RFXSTDTC) %>%
  mutate(
    z_base = runif(n(), min = 0.35, max = 1.05),
    z_base = if_else(USUBJID %in% c("01-701-1015", "01-714-1288"), 0.10, z_base),
    z_slope = case_when(
      ARMCD == "Xan_Hi" ~ 0.15,
      TRUE ~ 0.25 # Placebo and observational
    ) * rlnorm(n(), meanlog = 0, sdlog = 0.3)
  )

qs_frame <- visit_schedule %>%
  inner_join(subjects, by = "USUBJID") %>%
  left_join(planned_days, by = "VISITNUM") %>%
  mutate(
    # Planned study day only applies to randomized subjects
    VISITDY = if_else(is.na(ARMNRS), VISITDY, NA_real_),
    z = pmax(z_base + z_slope * TIME_FRAC + rnorm(n(), mean = 0, sd = 0.08), 0)
  ) %>%
  arrange(USUBJID, VISITNUM)

# CDR ----
# Six box scores. Personal Care has no 0.5 rating.
# weight = how strongly each box tracks overall severity in early AD.
cdr_boxes <- tribble(
  ~QSTESTCD, ~QSTEST, ~weight, ~allow_half,
  "CDR0101", "CDR01-Memory", 1.15, TRUE,
  "CDR0102", "CDR01-Orientation", 1.00, TRUE,
  "CDR0103", "CDR01-Judgment and Problem Solving", 1.00, TRUE,
  "CDR0104", "CDR01-Community Affairs", 0.90, TRUE,
  "CDR0105", "CDR01-Home and Hobbies", 0.85, TRUE,
  "CDR0106", "CDR01-Personal Care", 0.45, FALSE
)

# Round a continuous value to the nearest allowed CDR rating
to_cdr_level <- function(x, allow_half) {
  map2_dbl(x, allow_half, function(v, h) {
    lv <- if (h) c(0, 0.5, 1, 2, 3) else c(0, 1, 2, 3)
    lv[which.min(abs(lv - v))]
  })
}

cdr_records <- qs_frame %>%
  cross_join(cdr_boxes) %>%
  mutate(
    QSCAT = "CDR",
    score = to_cdr_level(
      pmax(z * weight + rnorm(n(), mean = 0, sd = 0.18), 0),
      allow_half
    )
  )

# MMSE ----
# 30 binary items (serial 7s path for attention). weight = relative vulnerability
# in AD: delayed recall and temporal orientation fail first, naming and reading last.
mmse_items <- tribble(
  ~QSTESTCD, ~QSTEST, ~weight,
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

mmse_records <- qs_frame %>%
  mutate(
    total = pmin(pmax(round(29.6 - 7.5 * z + rnorm(n(), mean = 0, sd = 1.2)), 0), 30),
    QSTESTCD = list(mmse_items$QSTESTCD),
    score = map(total, ~ allocate_mmse(.x, mmse_items$weight))
  ) %>%
  unnest(c(QSTESTCD, score)) %>%
  left_join(select(mmse_items, QSTESTCD, QSTEST), by = "QSTESTCD") %>%
  mutate(QSCAT = "MMSE")

# Combine ----
qs_scores <- bind_rows(cdr_records, mmse_records) %>%
  select(
    STUDYID, USUBJID, RFSTDTC, RFXSTDTC, QSCAT, QSTESTCD, QSTEST, score,
    VISITNUM, VISIT, VISITDY, QSDTC, QSDY
  )

# Value checks (before introducing missing data) ----
cdr_check <- filter(qs_scores, QSCAT == "CDR")
if (!all(cdr_check$score %in% c(0, 0.5, 1, 2, 3))) {
  cli_abort("CDR box scores must be one of 0, 0.5, 1, 2, 3.")
}
if (any(cdr_check$score[cdr_check$QSTESTCD == "CDR0106"] == 0.5)) {
  cli_abort("CDR Personal Care (CDR0106) cannot be rated 0.5.")
}

mmse_check <- filter(qs_scores, QSCAT == "MMSE")
if (!all(mmse_check$score %in% c(0, 1))) {
  cli_abort("MMSE item scores must be 0 or 1.")
}
mmse_counts <- count(mmse_check, USUBJID, VISITNUM)
if (any(mmse_counts$n != 30)) {
  cli_abort("Each MMSE administration must have exactly 30 items.")
}

# Missing data examples ----
# 1. Whole CDR not done for 01-701-1234 at WEEK 26 (one QSALL record)
# 2. MMSE Copy This Design not done for 01-701-1392 at WEEK 12
cdr_not_done <- qs_scores %>%
  filter(USUBJID == "01-701-1234", VISIT == "WEEK 26", QSTESTCD == "CDR0101") %>%
  mutate(
    QSTESTCD = "QSALL",
    QSTEST = "Questionnaire",
    score = NA_real_,
    QSSTAT = "NOT DONE",
    QSREASND = "STUDY PARTNER NOT AVAILABLE"
  )

qs_scores <- qs_scores %>%
  filter(!(USUBJID == "01-701-1234" & VISIT == "WEEK 26" & QSCAT == "CDR")) %>%
  mutate(
    item_nd = USUBJID == "01-701-1392" & VISIT == "WEEK 12" & QSTESTCD == "MMS111",
    score = if_else(item_nd, NA_real_, score),
    QSSTAT = if_else(item_nd, "NOT DONE", NA_character_),
    QSREASND = if_else(item_nd, "PHYSICALLY UNABLE", NA_character_)
  ) %>%
  select(-item_nd) %>%
  bind_rows(cdr_not_done)

# Derive SDTM variables ----
# QSLOBXFL: last non-missing result on or before first exposure, per subject and
# test. Observational subjects have no exposure, so RFSTDTC is used instead.
qs_neuro <- qs_scores %>%
  mutate(
    DOMAIN = "QS",
    QSORRES = if_else(is.na(score), NA_character_, as.character(score)),
    QSSTRESC = QSORRES,
    QSSTRESN = score,
    ref_date = as.Date(coalesce(RFXSTDTC, RFSTDTC)),
    pre_exposure = !is.na(QSSTRESN) & as.Date(QSDTC) <= ref_date
  ) %>%
  group_by(USUBJID, QSTESTCD) %>%
  mutate(
    QSLOBXFL = if_else(
      # "" guards against groups with no pre-exposure record (e.g. QSALL)
      pre_exposure & QSDTC == max(c(QSDTC[pre_exposure], "")),
      "Y", NA_character_
    )
  ) %>%
  ungroup() %>%
  arrange(USUBJID, VISITNUM, QSCAT, QSTESTCD) %>%
  group_by(USUBJID) %>%
  mutate(QSSEQ = row_number()) %>%
  ungroup() %>%
  select(
    STUDYID, DOMAIN, USUBJID, QSSEQ, QSTESTCD, QSTEST, QSCAT,
    QSORRES, QSSTRESC, QSSTRESN, QSSTAT, QSREASND, QSLOBXFL,
    VISITNUM, VISIT, VISITDY, QSDTC, QSDY
  )

# Structural checks ----
if (!all(nchar(qs_neuro$QSTESTCD) <= 8)) {
  cli_abort("The length of values in 'qs_neuro$QSTESTCD' must not exceed 8 characters.")
}

if (!all(qs_neuro$VISIT %in% c("BASELINE", "WEEK 12", "WEEK 26"))) {
  cli_abort("Unexpected VISIT values in 'qs_neuro'.")
}

dups <- qs_neuro %>%
  count(USUBJID, QSCAT, QSTESTCD, VISITNUM) %>%
  filter(n > 1)
if (nrow(dups) > 0) {
  cli_abort("Duplicate records found for some subject/test/visit combinations.")
}

lobx <- qs_neuro %>%
  filter(QSLOBXFL == "Y") %>%
  count(USUBJID, QSTESTCD) %>%
  filter(n > 1)
if (nrow(lobx) > 0) {
  cli_abort("More than one QSLOBXFL = 'Y' record per subject and test.")
}

# Assign labels ----
labels <- list(
  STUDYID = "Study Identifier",
  DOMAIN = "Domain Abbreviation",
  USUBJID = "Unique Subject Identifier",
  QSSEQ = "Sequence Number",
  QSTESTCD = "Question Short Name",
  QSTEST = "Question Name",
  QSCAT = "Category of Question",
  QSORRES = "Finding in Original Units",
  QSSTRESC = "Character Result/Finding in Std Format",
  QSSTRESN = "Numeric Finding in Standard Units",
  QSSTAT = "Completion Status",
  QSREASND = "Reason Not Performed",
  QSLOBXFL = "Last Observation Before Exposure Flag",
  VISITNUM = "Visit Number",
  VISIT = "Visit Name",
  VISITDY = "Planned Study Day of Visit",
  QSDTC = "Date/Time of Finding",
  QSDY = "Study Day of Finding"
)

for (var in names(labels)) {
  attr(qs_neuro[[var]], "label") <- labels[[var]]
}

attr(qs_neuro, "label") <- "Questionnaires"

# Save dataset ----
usethis::use_data(qs_neuro, overwrite = TRUE)
