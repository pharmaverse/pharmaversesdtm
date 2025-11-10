# Datasets: lb_onco_pcwg
# Description: LB test dataset containing PSA measurements for prostate cancer studies

# Load libraries -----
library(dplyr)
library(admiral)

# Read input data ----
lb <- pharmaversesdtm::lb

# Create lb_onco_pcwg ----
lb_data <- tibble::tribble(
  ~USUBJID,             ~VISIT, ~LBORRES,
  "01-701-1015", "SCREENING 1",    "120",
  "01-701-1015",      "WEEK 8",     "55",
  "01-701-1015",     "WEEK 16",     "45",
  "01-701-1015",     "WEEK 24",     "50",
  "01-701-1028", "SCREENING 1",    "200",
  "01-701-1028",      "WEEK 8",     "90",
  "01-701-1028",     "WEEK 16",     "85",
  "01-701-1028",     "WEEK 24",    "130",
  "01-701-1034", "SCREENING 1",    "150",
  "01-701-1034",      "WEEK 8",    "195",
  "01-701-1034",     "WEEK 16",    "190",
  "01-701-1034",     "WEEK 24",    "195",
  "01-701-1097", "SCREENING 1",    "180",
  "01-701-1097",      "WEEK 8",     "80",
  "01-701-1097",     "WEEK 16",     "85",
  "01-701-1097",     "WEEK 24",     "90",
  "01-701-1115", "SCREENING 1",     "90",
  "01-701-1115",      "WEEK 8",     "40",
  "01-701-1118", "SCREENING 1",    "110",
  "01-701-1118",      "WEEK 8",      "1",
  "01-701-1118",     "WEEK 16",      "1",
  "01-701-1118",     "WEEK 24",      "1",
  "01-701-1130", "SCREENING 1",    "160",
  "01-701-1130",      "WEEK 8",     "85",
  "01-701-1130",     "WEEK 16",     "83",
  "01-701-1130",     "WEEK 24",     "83",
  "01-701-1133", "SCREENING 1",    "165",
  "01-701-1133",      "WEEK 8",     "80",
  "01-701-1133",     "WEEK 16",     "80",
  "01-701-1133",     "WEEK 24",     "75",
  "01-701-1148", "SCREENING 1",    "100",
  "01-701-1148",      "WEEK 8",     "40",
  "01-701-1148",     "WEEK 16",     "38",
  "01-701-1148",     "WEEK 24",     "35",
  "01-701-1153", "SCREENING 1",     "70",
  "01-701-1153",      "WEEK 8",     "72",
  "01-701-1153",     "WEEK 16",     "68",
  "01-701-1153",     "WEEK 24",     "70",
  "01-701-1275", "SCREENING 1",    "210",
  "01-701-1275",      "WEEK 8",      "1",
  "01-701-1275",     "WEEK 16",      "1"
)

lb_base <- lb %>%
  distinct(STUDYID, DOMAIN, USUBJID, VISITNUM, VISIT, VISITDY, LBDTC, LBDY)

cols <- c(
  "STUDYID", "DOMAIN", "USUBJID", "LBSEQ", "LBTESTCD", "LBTEST", "LBCAT",
  "LBORRES", "LBORRESU", "LBSTRESC", "LBSTRESN", "LBSTRESU", "LBBLFL",
  "VISITNUM", "VISIT", "VISITDY", "LBDTC", "LBDY"
)

lb_onco_pcwg <- lb_base %>%
  right_join(lb_data, by = c("USUBJID", "VISIT")) %>%
  mutate(
    LBTESTCD = "PSA",
    LBTEST = "Prostate Specific Antigen",
    LBCAT = "CHEMISTRY",
    LBORRESU = "ng/mL",
    LBSTRESC = LBORRES,
    LBSTRESN = as.double(LBSTRESC),
    LBSTRESU = "ng/mL",
    LBBLFL = if_else(VISIT == "SCREENING 1", "Y", NA_character_)
  ) %>%
  derive_var_obs_number(
    by_vars = exprs(USUBJID),
    order = exprs(LBTESTCD, LBDTC),
    new_var = LBSEQ
  ) %>%
  relocate(all_of(cols))

# Assign labels ----
for (col in colnames(select(lb, all_of(cols)))) {
  attr(lb_onco_pcwg[[col]], "label") <- attr(lb[[col]], "label")
}

attr(lb_onco_pcwg, "label") <- "Laboratory Test Results (PSA)"

# Save dataset ----
usethis::use_data(lb_onco_pcwg, overwrite = TRUE)
