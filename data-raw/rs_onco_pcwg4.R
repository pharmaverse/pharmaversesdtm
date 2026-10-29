# Datasets: rs_onco_pcwg4
# Description: RS Oncology dataset using PCWG3 criteria

# Load libraries -----
library(dplyr)
library(tidyr)
library(admiral)

# Create rs_onco_pcwg4 ----
pcwg4_raw <- tibble::tribble(
  ~USUBJID,         ~VISIT, ~SoftTissue,    ~Bone, ~Overall, ~PSMA_PET,
  "01-701-1015",  "WEEK 8",        "SD", "NON-PD",     "SD", "NON-CR/NON-PD",
  "01-701-1015", "WEEK 16",        "PR", "NON-PD",     "PR", "NON-CR/NON-PD",
  "01-701-1015", "WEEK 24",        "PR", "NON-PD",     "PR", "NON-CR/NON-PD",
  "01-701-1028",  "WEEK 8",        "PR", "NON-PD",     "PR", "NON-CR/NON-PD",
  "01-701-1028", "WEEK 16",        "PR", "NON-PD",     "PR", "CR",
  "01-701-1028", "WEEK 24",        "PD", "NON-PD",     "PD", "PDu",
  "01-701-1034",  "WEEK 8",        "SD", "NON-PD",     "SD", "NON-CR/NON-PD",
  "01-701-1034", "WEEK 16",        "SD", "NON-PD",     "SD", "NON-CR/NON-PD",
  "01-701-1034", "WEEK 24",        "SD", "NON-PD",     "SD", "NON-CR/NON-PD",
  "01-701-1097",  "WEEK 8",        "SD", "NON-PD",     "SD", "PD",
  "01-701-1097", "WEEK 16",        "PR",     "PD",     "PD", "PD",
  "01-701-1097", "WEEK 24",        "PR",     "PD",     "PD", "PD",
  "01-701-1115",  "WEEK 8",       "NED",    "PDu",    "PDu", "NON-CR/NON-PD",
  "01-701-1118",  "WEEK 8",        "CR",    "NED",     "CR", "NON-CR/NON-PD",
  "01-701-1118", "WEEK 16",        "CR",    "NED",     "CR", "PD",
  "01-701-1118", "WEEK 24",        "CR",    "NED",     "CR", "PD",
  "01-701-1130",  "WEEK 8",        "PR", "NON-PD",     "PR", "NE",
  "01-701-1130", "WEEK 16",        "PR", "NON-PD",     "PR", "NON-CR/NON-PD",
  "01-701-1130", "WEEK 24",        "PD", "NON-PD",     "PD", "CR",
  "01-701-1133",  "WEEK 8",        "NE",     "NE",     "NE", "NON-CR/NON-PD",
  "01-701-1133", "WEEK 16",        "SD", "NON-PD",     "SD", "NE",
  "01-701-1133", "WEEK 24",        "SD", "NON-PD",     "SD", "PDu",
  "01-701-1148",  "WEEK 8",        "PR",     "NE",     "PR", "CR",
  "01-701-1148", "WEEK 16",        "PR",     "NE",     "PR", "NON-CR/NON-PD",
  "01-701-1148", "WEEK 24",        "PR",     "NE",     "PR", "PD",
  "01-701-1153",  "WEEK 8",        "SD",    "NED",     "SD", "NON-CR/NON-PD",
  "01-701-1153", "WEEK 16",        "SD",    "NED",     "SD", "NON-CR/NON-PD",
  "01-701-1153", "WEEK 24",        "SD",    "NED",     "SD", "CR",
  "01-701-1275",  "WEEK 8",        "SD",     "PD",     "PD", "PD",
  "01-701-1275", "WEEK 16",        "SD",     "PD",     "PD", "PD"
)

rs_onco_pcwg4_pre <- pcwg4_raw %>%
  pivot_longer(
    cols = c("SoftTissue", "Bone", "Overall", "PSMA_PET"),
    names_to = "assessment",
    values_to = "RSORRES",
    values_drop_na = TRUE
  )

testnames <- tibble::tribble(
  ~assessment,   ~RSTESTCD,                 ~RSTEST,                            ~RSCAT,
  "SoftTissue", "SFTSRESP",  "Soft Tissue Response",                      "RECIST 1.1",
  "Bone",       "BONERESP",         "Bone Response", "PCWG SCHER PROSTATE CANCER 2016",
  "Overall",    "OVRLRESP",      "Overall Response", "PCWG SCHER PROSTATE CANCER 2016",
  "PSMA_PET",   "OVRLRESP",      "Overall Response",                        "PSMA-PET"
)

# date of the corresponding visit from LB
lb <- pharmaversesdtm::lb
timingvars <- rs_onco_pcwg4_pre %>%
  distinct(USUBJID) %>%
  left_join(lb, by = "USUBJID") %>%
  filter(VISITNUM %in% c(8, 10, 12)) %>%
  distinct(USUBJID, VISITNUM, VISIT, LBDTC, LBDY) %>%
  mutate(
    RSDTC = sapply(strsplit(LBDTC, "T", fixed = TRUE), `[`, 1),
    RSDY = LBDY
  ) %>%
  select(USUBJID, VISITNUM, VISIT, RSDTC, RSDY)

rs_onco_pcwg4 <- rs_onco_pcwg4_pre %>%
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
for (col in colnames(rs_onco_pcwg4)) {
  attr(rs_onco_pcwg4[[col]], "label") <- attr(rs_onco[[col]], "label")
}

attr(rs_onco_pcwg4, "label") <- "Disease Response (PCWG3)"

usethis::use_data(rs_onco_pcwg4, overwrite = TRUE)
