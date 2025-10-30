# Datasets: rs_onco_pcwg3
# Description: RS Oncology dataset using PCWG3 criteria

# Load libraries -----
library(dplyr)
library(tidyr)
library(admiral)

# Create rs_onco_pcwg3 ----
pcwg3_raw <- tibble::tribble(
  ~USUBJID,         ~VISIT,     ~PSA, ~SoftTissue,    ~Bone, ~Overall,
  "01-701-1015",  "WEEK 8",     "PR",        "SD", "NON-PD",     "SD",
  "01-701-1015", "WEEK 16",     "PR",        "PR", "NON-PD",     "PR",
  "01-701-1015", "WEEK 24",     "PR",        "PR", "NON-PD",     "PR",
  "01-701-1028",  "WEEK 8",     "PR",        "PR", "NON-PD",     "PR",
  "01-701-1028", "WEEK 16",     "PR",        "PR", "NON-PD",     "PR",
  "01-701-1028", "WEEK 24",     "PD",        "PD", "NON-PD",     "PD",
  "01-701-1034",  "WEEK 8",     "PD",        "SD", "NON-PD",     "SD",
  "01-701-1034", "WEEK 16",     "PD",        "SD", "NON-PD",     "SD",
  "01-701-1034", "WEEK 24",     "PD",        "SD", "NON-PD",     "SD",
  "01-701-1097",  "WEEK 8",     "PR",        "SD", "NON-PD",     "SD",
  "01-701-1097", "WEEK 16",     "PR",        "PR", "NON-PD",     "PR",
  "01-701-1097", "WEEK 24",     "PR",        "PR",     "PD",     "PD",
  "01-701-1115",  "WEEK 8",     "PR",       "NED",    "PDu",    "PDu",
  "01-701-1118",  "WEEK 8",     "CR",        "CR",    "NED",     "CR",
  "01-701-1118", "WEEK 16",     "CR",        "CR",    "NED",     "CR",
  "01-701-1118", "WEEK 24",     "CR",        "CR",    "NED",     "CR",
  "01-701-1130",  "WEEK 8", "NON-PD",        "PR", "NON-PD",     "PR",
  "01-701-1130", "WEEK 16", "NON-PD",        "PR", "NON-PD",     "PR",
  "01-701-1130", "WEEK 24", "NON-PD",        "PD", "NON-PD",     "PD",
  "01-701-1133",  "WEEK 8",     "PR",        "NE",     "NE",     "NE",
  "01-701-1133", "WEEK 16",     "PR",        "SD", "NON-PD",     "SD",
  "01-701-1133", "WEEK 24",     "PR",        "SD", "NON-PD",     "SD",
  "01-701-1148",  "WEEK 8",     "PR",        "PR",     "NE",     "PR",
  "01-701-1148", "WEEK 16",     "PR",        "PR",     "NE",     "PR",
  "01-701-1148", "WEEK 24",     "PR",        "PR",     "NE",     "PR",
  "01-701-1153",  "WEEK 8",     "SD",        "SD",    "NED",     "SD",
  "01-701-1153", "WEEK 16",     "SD",        "SD",    "NED",     "SD",
  "01-701-1153", "WEEK 24",     "SD",        "SD",    "NED",     "SD",
  "01-701-1275",  "WEEK 8",     "CR",        "SD",     "PD",     "PD",
  "01-701-1275", "WEEK 16",     "CR",        "SD",     "PD",     "PD"
)

rs_onco_pcwg3_pre <- pcwg3_raw %>%
  pivot_longer(
    cols = c("PSA", "SoftTissue", "Bone", "Overall"),
    names_to = "assessment",
    values_to = "RSORRES",
    values_drop_na = TRUE
  )

testnames <- tibble::tribble(
  ~assessment,   ~RSTESTCD,                 ~RSTEST,                            ~RSCAT,
  "PSA",          "TMRESP", "Tumor Marker Response", "PCWG SCHER PROSTATE CANCER 2016",
  "SoftTissue", "SFTSRESP",  "Soft Tissue Response",                      "RECIST 1.1",
  "Bone",       "BONERESP",         "Bone Response", "PCWG SCHER PROSTATE CANCER 2016",
  "Overall",    "OVRLRESP",      "Overall Response", "PCWG SCHER PROSTATE CANCER 2016"
)

# date of the corresponding visit from LB
lb <- pharmaversesdtm::lb
timingvars <- rs_onco_pcwg3_pre %>%
  distinct(USUBJID) %>%
  left_join(lb, by = "USUBJID") %>%
  filter(VISITNUM %in% c(8, 10, 12)) %>%
  distinct(USUBJID, VISITNUM, VISIT, LBDTC, LBDY) %>%
  mutate(
    RSDTC = sapply(strsplit(LBDTC, "T", fixed = TRUE), `[`, 1),
    RSDY = LBDY
  ) %>%
  select(USUBJID, VISITNUM, VISIT, RSDTC, RSDY)

rs_onco_pcwg3 <- rs_onco_pcwg3_pre %>%
  left_join(testnames, by = "assessment") %>%
  left_join(timingvars, by = c("USUBJID", "VISIT")) %>%
  mutate(
    STUDYID = "CDISCPILOT01",
    DOMAIN = "RS",
    RSEVAL = "INVESTIGATOR",
    RSSTRESC = RSORRES
  ) %>%
  derive_var_obs_number(
    by_vars = exprs(USUBJID),
    order = exprs(VISITNUM, RSEVAL),
    new_var = RSSEQ
  ) %>%
  select(
    STUDYID, DOMAIN, USUBJID, RSSEQ, RSTESTCD, RSTEST, RSCAT, RSORRES, RSSTRESC,
    RSEVAL, VISITNUM, VISIT, RSDTC, RSDY
  )

# assign labels
rs_onco <- pharmaversesdtm::rs_onco
for (col in colnames(rs_onco_pcwg3)) {
  attr(rs_onco_pcwg3[[col]], "label") <- attr(rs_onco[[col]], "label")
}

attr(rs_onco_pcwg3, "label") <- "Disease Response (PCWG3)"

usethis::use_data(rs_onco_pcwg3, overwrite = TRUE)
