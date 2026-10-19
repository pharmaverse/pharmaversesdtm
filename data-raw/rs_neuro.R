# Dataset: rs_neuro
# Description: Create RS test SDTM dataset for Alzheimer's Disease (Neuro),
#   containing item-level Clinical Dementia Rating (CDR) box scores.
# Note: Under CDISC Controlled Terminology the CDR is a Clinical Classification
#   (codelists C101811/C101812), so it is stored in RS (SDTMIG v3.3+).
# Note: Only the six collected box scores are included. CDR Sum of Boxes (CDR0107)
#   and Global CDR (CDR0108) are left for ADaM derivation.
# Note: RSORRES holds the CRF response text (NONE, QUESTIONABLE, MILD, MODERATE,
#   SEVERE); RSSTRESC/RSSTRESN hold the box score (0, 0.5, 1, 2, 3). CDISC CT has
#   no CDR response codelist, so the text follows the CDR rating anchors.
# Note: The CDR is copyrighted by Washington University in St. Louis. Only CDISC
#   test names are used; all values are simulated and are for not-for-profit use
#   within `pharmaverse`-related examples/documentation only.
# Note: ft_neuro.R reads this dataset, so rs_neuro.R must run first.

# Load libraries ----
library(admiral)
library(dplyr)
library(tibble)
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
  rename(RSDTC = NVDTC, RSDY = NVDY) %>%
  mutate(RSDY = as.numeric(RSDY))

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
    # One more impaired subject so MODERATE/SEVERE ratings occur, exercising the
    # Global CDR rules for Memory >= 1 in ADaM
    z_base = if_else(USUBJID == "01-701-1153", 1.60, z_base),
    z_slope = case_when(
      ARMCD == "Xan_Hi" ~ 0.15,
      TRUE ~ 0.25 # Placebo and observational
    ) * rlnorm(n(), meanlog = 0, sdlog = 0.3)
  )

rs_frame <- visit_schedule %>%
  inner_join(subjects, by = "USUBJID") %>%
  left_join(planned_days, by = "VISITNUM") %>%
  mutate(
    # Planned study day only applies to randomized subjects
    VISITDY = if_else(is.na(ARMNRS), VISITDY, NA_real_),
    z = pmax(z_base + z_slope * TIME_FRAC + rnorm(n(), mean = 0, sd = 0.08), 0)
  ) %>%
  arrange(USUBJID, VISITNUM)

# CDR box scores ----
# Personal Care has no 0.5 rating.
# weight = how strongly each box tracks overall severity in early AD.
cdr_boxes <- tribble(
  ~RSTESTCD, ~RSTEST, ~weight, ~allow_half,
  "CDR0101", "CDR01-Memory", 1.15, TRUE,
  "CDR0102", "CDR01-Orientation", 1.00, TRUE,
  "CDR0103", "CDR01-Judgment and Problem Solving", 1.00, TRUE,
  "CDR0104", "CDR01-Community Affairs", 0.90, TRUE,
  "CDR0105", "CDR01-Home and Hobbies", 0.85, TRUE,
  "CDR0106", "CDR01-Personal Care", 0.45, FALSE
)

# Box score to CRF response text (Personal Care has no QUESTIONABLE)
cdr_responses <- tribble(
  ~score, ~RSORRES,
  0, "NONE",
  0.5, "QUESTIONABLE",
  1, "MILD",
  2, "MODERATE",
  3, "SEVERE"
)

# Round a continuous value to the nearest allowed CDR rating
to_cdr_level <- function(x, allow_half) {
  map2_dbl(x, allow_half, function(v, h) {
    lv <- if (h) c(0, 0.5, 1, 2, 3) else c(0, 1, 2, 3)
    lv[which.min(abs(lv - v))]
  })
}

rs_scores <- rs_frame %>%
  cross_join(cdr_boxes) %>%
  mutate(
    RSCAT = "CDR",
    score = to_cdr_level(
      pmax(z * weight + rnorm(n(), mean = 0, sd = 0.18), 0),
      allow_half
    )
  ) %>%
  select(
    STUDYID, USUBJID, RFSTDTC, RFXSTDTC, RSCAT, RSTESTCD, RSTEST, score,
    VISITNUM, VISIT, VISITDY, RSDTC, RSDY
  )

# Value checks (before introducing missing data) ----
if (!all(rs_scores$score %in% c(0, 0.5, 1, 2, 3))) {
  cli_abort("CDR box scores must be one of 0, 0.5, 1, 2, 3.")
}
if (any(rs_scores$score[rs_scores$RSTESTCD == "CDR0106"] == 0.5)) {
  cli_abort("CDR Personal Care (CDR0106) cannot be rated 0.5.")
}
box_counts <- count(rs_scores, USUBJID, VISITNUM)
if (any(box_counts$n != 6)) {
  cli_abort("Each CDR administration must have exactly 6 box scores.")
}

# Missing data example ----
# Whole CDR not done for 01-701-1234 at WEEK 26: replace the six box records
# with a single RSALL record.
cdr_not_done <- rs_scores %>%
  filter(USUBJID == "01-701-1234", VISIT == "WEEK 26", RSTESTCD == "CDR0101") %>%
  mutate(
    RSTESTCD = "RSALL",
    RSTEST = "Clinical Classification",
    score = NA_real_,
    RSSTAT = "NOT DONE",
    RSREASND = "STUDY PARTNER NOT AVAILABLE"
  )

rs_scores <- rs_scores %>%
  filter(!(USUBJID == "01-701-1234" & VISIT == "WEEK 26")) %>%
  mutate(RSSTAT = NA_character_, RSREASND = NA_character_) %>%
  bind_rows(cdr_not_done)

# Derive SDTM variables ----
# RSLOBXFL: last non-missing result on or before first exposure, per subject and
# test. Observational subjects have no exposure, so RFSTDTC is used instead.
rs_neuro <- rs_scores %>%
  left_join(cdr_responses, by = "score") %>%
  mutate(
    DOMAIN = "RS",
    RSSTRESC = if_else(is.na(score), NA_character_, as.character(score)),
    RSSTRESN = score,
    ref_date = as.Date(coalesce(RFXSTDTC, RFSTDTC)),
    pre_exposure = !is.na(RSSTRESN) & as.Date(RSDTC) <= ref_date
  ) %>%
  group_by(USUBJID, RSTESTCD) %>%
  mutate(
    RSLOBXFL = if_else(
      # "" guards against groups with no pre-exposure record (e.g. RSALL)
      pre_exposure & RSDTC == max(c(RSDTC[pre_exposure], "")),
      "Y", NA_character_
    )
  ) %>%
  ungroup() %>%
  arrange(USUBJID, VISITNUM, RSTESTCD) %>%
  group_by(USUBJID) %>%
  mutate(RSSEQ = row_number()) %>%
  ungroup() %>%
  select(
    STUDYID, DOMAIN, USUBJID, RSSEQ, RSTESTCD, RSTEST, RSCAT,
    RSORRES, RSSTRESC, RSSTRESN, RSSTAT, RSREASND, RSLOBXFL,
    VISITNUM, VISIT, VISITDY, RSDTC, RSDY
  )

# Result consistency check ----
# Each RSORRES text must match its RSSTRESN score
result_check <- rs_neuro %>%
  filter(!is.na(RSSTRESN)) %>%
  left_join(rename(cdr_responses, expected = RSORRES), by = c("RSSTRESN" = "score"))
if (any(result_check$RSORRES != result_check$expected) ||
    any(result_check$RSSTRESC != as.character(result_check$RSSTRESN))) {
  cli_abort("RSORRES, RSSTRESC and RSSTRESN are not consistent.")
}
if (any(rs_neuro$RSORRES[rs_neuro$RSTESTCD == "CDR0106"] %in% "QUESTIONABLE")) {
  cli_abort("CDR Personal Care (CDR0106) cannot be QUESTIONABLE.")
}

# Structural checks ----
if (!all(nchar(rs_neuro$RSTESTCD) <= 8)) {
  cli_abort("The length of values in 'rs_neuro$RSTESTCD' must not exceed 8 characters.")
}

if (!all(rs_neuro$VISIT %in% c("BASELINE", "WEEK 12", "WEEK 26"))) {
  cli_abort("Unexpected VISIT values in 'rs_neuro'.")
}

dups <- rs_neuro %>%
  count(USUBJID, RSTESTCD, VISITNUM) %>%
  filter(n > 1)
if (nrow(dups) > 0) {
  cli_abort("Duplicate records found for some subject/test/visit combinations.")
}

lobx <- rs_neuro %>%
  filter(RSLOBXFL == "Y") %>%
  count(USUBJID, RSTESTCD) %>%
  filter(n > 1)
if (nrow(lobx) > 0) {
  cli_abort("More than one RSLOBXFL = 'Y' record per subject and test.")
}

# Assign labels ----
labels <- list(
  STUDYID = "Study Identifier",
  DOMAIN = "Domain Abbreviation",
  USUBJID = "Unique Subject Identifier",
  RSSEQ = "Sequence Number",
  RSTESTCD = "Assessment Short Name",
  RSTEST = "Assessment Name",
  RSCAT = "Category for Assessment",
  RSORRES = "Result or Finding in Original Units",
  RSSTRESC = "Character Result/Finding in Std Format",
  RSSTRESN = "Numeric Result/Finding in Standard Units",
  RSSTAT = "Completion Status",
  RSREASND = "Reason Not Done",
  RSLOBXFL = "Last Observation Before Exposure Flag",
  VISITNUM = "Visit Number",
  VISIT = "Visit Name",
  VISITDY = "Planned Study Day of Visit",
  RSDTC = "Date/Time of Assessment",
  RSDY = "Study Day of Assessment"
)

for (var in names(labels)) {
  attr(rs_neuro[[var]], "label") <- labels[[var]]
}

attr(rs_neuro, "label") <- "Disease Response and Clin Classification"

# Save dataset ----
usethis::use_data(rs_neuro, overwrite = TRUE)
