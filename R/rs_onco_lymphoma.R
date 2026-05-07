# Datasets: rs_onco_lymphoma
# Description: RS Oncology dataset using Lugano 2014 style lymphoma response assessments

# Load libraries ----
library(dplyr)
library(tidyr)
library(admiral)
library(pharmaversesdtm)

# Create rs_onco_lymphoma ----
lymphoma_raw <- tibble::tribble(
  ~USUBJID,       ~VISIT,    ~PET,  ~CT,  ~Overall, ~OVRSSCAT,                ~PETSTAT,
  "01-701-1015", "WEEK 8",  "SMD", "SD", "SD",     "INCLUDING PET-CT SCAN",  NA,
  "01-701-1015", "WEEK 16", "PMR", "PR", "PR",     "INCLUDING PET-CT SCAN",  NA,
  "01-701-1015", "WEEK 24", "CMR", "PR", "CR",     "INCLUDING PET-CT SCAN",  NA,
  "01-701-1028", "WEEK 8",  "PMR", "PR", "PR",     "INCLUDING PET-CT SCAN",  NA,
  "01-701-1028", "WEEK 16", "PMR", "PR", "PR",     "INCLUDING PET-CT SCAN",  NA,
  "01-701-1028", "WEEK 24", "PMD", "PD", "PD",     "INCLUDING PET-CT SCAN",  NA,
  "01-701-1034", "WEEK 8",  "SMD", "SD", "SD",     "INCLUDING PET-CT SCAN",  NA,
  "01-701-1034", "WEEK 16", "SMD", "SD", "SD",     "INCLUDING PET-CT SCAN",  NA,
  "01-701-1034", "WEEK 24", "SMD", "SD", "SD",     "INCLUDING PET-CT SCAN",  NA,
  "01-701-1097", "WEEK 8",  "SMD", "SD", "SD",     "INCLUDING PET-CT SCAN",  NA,
  "01-701-1097", "WEEK 16", "PMD", "PR", "PD",     "INCLUDING PET-CT SCAN",  NA,
  "01-701-1097", "WEEK 24", "PMD", "PR", "PD",     "INCLUDING PET-CT SCAN",  NA,
  "01-701-1115", "WEEK 8",  NA,    "PD", "PD",     "NOT INCLUDING PET SCAN", "NOT DONE",
  "01-701-1118", "WEEK 8",  "CMR", "CR", "CR",     "INCLUDING PET-CT SCAN",  NA,
  "01-701-1118", "WEEK 16", "CMR", "CR", "CR",     "INCLUDING PET-CT SCAN",  NA,
  "01-701-1118", "WEEK 24", "CMR", "CR", "CR",     "INCLUDING PET-CT SCAN",  NA,
  "01-701-1130", "WEEK 8",  "PMR", "PR", "PR",     "INCLUDING PET-CT SCAN",  NA,
  "01-701-1130", "WEEK 16", "PMR", "PR", "PR",     "INCLUDING PET-CT SCAN",  NA,
  "01-701-1130", "WEEK 24", "PMD", "PD", "PD",     "INCLUDING PET-CT SCAN",  NA,
  "01-701-1133", "WEEK 8",  "NE",  "PR", "PR",     "NOT INCLUDING PET SCAN", NA,
  "01-701-1133", "WEEK 16", "SMD", "SD", "SD",     "INCLUDING PET-CT SCAN",  NA,
  "01-701-1133", "WEEK 24", "SMD", "SD", "SD",     "INCLUDING PET-CT SCAN",  NA,
  "01-701-1148", "WEEK 8",  NA,    "PR", "PR",     "NOT INCLUDING PET SCAN", "NOT DONE",
  "01-701-1148", "WEEK 16", NA,    "PR", "PR",     "NOT INCLUDING PET SCAN", "NOT DONE",
  "01-701-1148", "WEEK 24", NA,    "PR", "PR",     "NOT INCLUDING PET SCAN", "NOT DONE",
  "01-701-1153", "WEEK 8",  "ND",  "SD", "SD",     "NOT INCLUDING PET SCAN", NA,
  "01-701-1153", "WEEK 16", "SMD", "SD", "SD",     "INCLUDING PET-CT SCAN",  NA,
  "01-701-1153", "WEEK 24", "SMD", "SD", "SD",     "INCLUDING PET-CT SCAN",  NA,
  "01-701-1275", "WEEK 8",  "PMD", "PD", "PD",     "INCLUDING PET-CT SCAN",  NA,
  "01-701-1275", "WEEK 16", "PMD", "PD", "PD",     "INCLUDING PET-CT SCAN",  NA,
  "01-716-1311", "WEEK 8",  "PMR", "NE", "PR",     "INCLUDING PET-CT SCAN",  NA,
  "01-716-1311", "WEEK 16", "CMR", "NE", "CR",     "INCLUDING PET-CT SCAN",  NA,
  "01-710-1315", "WEEK 8",  "SMD", "PR", "SD",     "INCLUDING PET-CT SCAN",  NA,
  "01-710-1315", "WEEK 16", "PMR", "PR", "PR",     "INCLUDING PET-CT SCAN",  NA,
  "01-701-1023", "WEEK 8",  "ND",  "NE", "ND",     "NOT INCLUDING PET SCAN", NA
)

rs_onco_lymphoma_pre <- lymphoma_raw %>%
  pivot_longer(
    cols = c("PET", "CT", "Overall"),
    names_to = "assessment",
    values_to = "RSORRES",
    values_drop_na = FALSE
  )

testnames <- tibble::tribble(
  ~assessment, ~RSTESTCD,  ~RSTEST,                               ~RSCAT,         ~RSSCAT,
  "PET",       "PETRESP",  "Response (PET-CT)",                   "LUGANO 2014",  "INCLUDING PET-CT SCAN",
  "CT",        "CTRESP",   "Response (CT or MRI without PET)",    "LUGANO 2014",  "NOT INCLUDING PET SCAN",
  "Overall",   "OVRLRESP", "Overall Response",                    "LUGANO 2014",  NA
)

# date of the corresponding visit from LB
lb <- pharmaversesdtm::lb
timingvars <- rs_onco_lymphoma_pre %>%
  distinct(USUBJID) %>%
  left_join(lb, by = "USUBJID") %>%
  filter(VISITNUM %in% c(8, 10, 12)) %>%
  distinct(USUBJID, VISITNUM, VISIT, LBDTC, LBDY) %>%
  mutate(
    RSDTC = sapply(strsplit(LBDTC, "T", fixed = TRUE), `[`, 1),
    RSDY = LBDY
  ) %>%
  select(USUBJID, VISITNUM, VISIT, RSDTC, RSDY)

rs_onco_lymphoma <- rs_onco_lymphoma_pre %>%
  left_join(testnames, by = "assessment") %>%
  left_join(timingvars, by = c("USUBJID", "VISIT")) %>%
  mutate(
    STUDYID = "CDISCPILOT01",
    DOMAIN = "RS",
    RSEVAL = "INVESTIGATOR",
    RSSCAT = case_when(
      assessment == "Overall" ~ OVRSSCAT,
      TRUE ~ RSSCAT
    ),
    RSSTAT = case_when(
      assessment == "PET" ~ PETSTAT,
      TRUE ~ NA_character_
    ),
    RSSTRESC = case_when(
      assessment == "PET" & RSSTAT == "NOT DONE" ~ NA_character_,
      TRUE ~ RSORRES
    )
  ) %>%
  filter(!(assessment == "PET" & is.na(RSORRES) & is.na(RSSTAT))) %>%
  derive_var_obs_number(
    by_vars = exprs(USUBJID),
    order = exprs(VISITNUM, RSEVAL),
    new_var = RSSEQ
  ) %>%
  select(
    STUDYID, DOMAIN, USUBJID, RSSEQ, RSTESTCD, RSTEST, RSCAT, RSSCAT,
    RSORRES, RSSTRESC, RSSTAT, RSEVAL, VISITNUM, VISIT, RSDTC, RSDY
  )

# assign labels
rs_onco <- pharmaversesdtm::rs_onco
for (col in colnames(rs_onco_lymphoma)) {
  if (col %in% colnames(rs_onco)) {
    attr(rs_onco_lymphoma[[col]], "label") <- attr(rs_onco[[col]], "label")
  }
}

attr(rs_onco_lymphoma, "label") <- "Disease Response (Lymphoma Lugano 2014)"

usethis::use_data(rs_onco_lymphoma, overwrite = TRUE)
