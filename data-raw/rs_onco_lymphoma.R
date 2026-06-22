# Datasets: rs_onco_lymphoma
# Description: RS Oncology dataset using Lugano 2014 lymphoma response assessments

# Load libraries ----
library(dplyr)
library(tidyr)
library(admiral)
library(pharmaversesdtm)

# Extract timing from pharmaversesdtm LB ----
lb <- pharmaversesdtm::lb

timing_lb <- lb %>%
  filter(VISITNUM %in% c(1, 8, 10, 12)) %>%
  distinct(USUBJID, VISITNUM, VISIT, LBDTC, LBDY) %>%
  mutate(
    RSDTC = sapply(strsplit(LBDTC, "T", fixed = TRUE), `[`, 1),
    RSDY = LBDY
  ) %>%
  select(USUBJID, VISITNUM, RSDTC, RSDY)

# Create rs_onco_lymphoma ----
lymphoma_raw <- tibble::tribble(
  ~USUBJID,      ~VISITNUM, ~VISIT,      ~PET,  ~CT,    ~OVRL, ~PETSTAT,
  "01-701-1015", 1,         "BASELINE",  "NMR", "SAD",  "SD",  NA,
  "01-701-1015", 8,         "WEEK 8",    "NMR", "SAD",  "SD",  NA,
  "01-701-1015", 10,        "WEEK 16",   "PMR", "PAR",  "PR",  NA,
  "01-701-1015", 12,        "WEEK 24",   "CMR", "PAR",  "CR",  NA,
  "01-701-1028", 1,         "BASELINE",  "NMR", "SAD",  "SD",  NA,
  "01-701-1028", 8,         "WEEK 8",    "PMR", "PAR",  "PR",  NA,
  "01-701-1028", 10,        "WEEK 16",   "PMR", "PAR",  "PR",  NA,
  "01-701-1028", 12,        "WEEK 24",   "PMD", "PAD",  "PD",  NA,
  "01-701-1034", 1,         "BASELINE",  "NMR", "SAD",  "SD",  NA,
  "01-701-1034", 8,         "WEEK 8",    "NMR", "SAD",  "SD",  NA,
  "01-701-1034", 10,        "WEEK 16",   "NMR", "SAD",  "SD",  NA,
  "01-701-1034", 12,        "WEEK 24",   "NMR", "SAD",  "SD",  NA,
  "01-701-1097", 1,         "BASELINE",  "NMR", "SAD",  "SD",  NA,
  "01-701-1097", 8,         "WEEK 8",    "NMR", "SAD",  "SD",  NA,
  "01-701-1097", 10,        "WEEK 16",   "PMD", "PAR",  "PD",  NA,
  "01-701-1097", 12,        "WEEK 24",   "PMD", "PAR",  "PD",  NA,
  "01-701-1115", 1,         "BASELINE",  "NMR", "SAD",  "SD",  NA,
  "01-701-1115", 8,         "WEEK 8",    NA,    "PAD",  "PD",  "NOT DONE",
  "01-701-1118", 1,         "BASELINE",  "NMR", "SAD",  "SD",  NA,
  "01-701-1118", 8,         "WEEK 8",    "CMR", "CAR",  "CR",  NA,
  "01-701-1118", 10,        "WEEK 16",   "CMR", "CAR",  "CR",  NA,
  "01-701-1118", 12,        "WEEK 24",   "CMR", "CAR",  "CR",  NA,
  "01-701-1130", 1,         "BASELINE",  "NMR", "SAD",  "SD",  NA,
  "01-701-1130", 8,         "WEEK 8",    "PMR", "PAR",  "PR",  NA,
  "01-701-1130", 10,        "WEEK 16",   "PMR", "PAR",  "PR",  NA,
  "01-701-1130", 12,        "WEEK 24",   "PMD", "PAD",  "PD",  NA,
  "01-701-1133", 1,         "BASELINE",  "NMR", "SAD",  "SD",  NA,
  "01-701-1133", 8,         "WEEK 8",    "NE",  "PAR",  "SD",  NA,
  "01-701-1133", 10,        "WEEK 16",   "NMR", "PAR",  "SD",  NA,
  "01-701-1133", 12,        "WEEK 24",   "NMR", "PAR",  "SD",  NA,
  "01-701-1148", 1,         "BASELINE",  "NMR", "PAR",  "SD",  NA,
  "01-701-1148", 8,         "WEEK 8",    NA,    "PAR",  "PR",  "NOT DONE",
  "01-701-1148", 10,        "WEEK 16",   NA,    "PAR",  "PR",  "NOT DONE",
  "01-701-1148", 12,        "WEEK 24",   NA,    "PAR",  "PR",  "NOT DONE",
  "01-701-1153", 1,         "BASELINE",  "NMR", "SAD",  "SD",  NA,
  "01-701-1153", 8,         "WEEK 8",    "ND",  "SAD",  "SD",  NA,
  "01-701-1153", 10,        "WEEK 16",   "NMR", "SAD",  "SD",  NA,
  "01-701-1153", 12,        "WEEK 24",   "NMR", "SAD",  "SD",  NA,
  "01-701-1275", 1,         "BASELINE",  "NMR", "SAD",  "SD",  NA,
  "01-701-1275", 8,         "WEEK 8",    "PMD", "PAD",  "PD",  NA,
  "01-701-1275", 10,        "WEEK 16",   "PMD", "PAD",  "PD",  NA,
  "01-716-1311", 1,         "BASELINE",  "NMR", "SAD",  "SD",  NA,
  "01-716-1311", 8,         "WEEK 8",    "PMR", "NE",   "PR",  NA,
  "01-716-1311", 10,        "WEEK 16",   "CMR", "NE",   "CR",  NA,
  "01-710-1315", 1,         "BASELINE",  "NMR", "SAD",  "SD",  NA,
  "01-710-1315", 8,         "WEEK 8",    "NMR", "PAR",  "SD",  NA,
  "01-710-1315", 10,        "WEEK 16",   "PMR", "PAR",  "PR",  NA,
  "01-701-1023", 1,         "BASELINE",  "ND",  "NE",   "ND",  NA
) %>%
  left_join(timing_lb, by = c("USUBJID", "VISITNUM"))


rs_onco_lymphoma_pre <- lymphoma_raw %>%
  pivot_longer(
    cols = c("PET", "CT"), # cols = c("PET", "CT", "OVRL")
    names_to = "assessment",
    values_to = "RSORRES",
    values_drop_na = FALSE
  )

testnames <- tibble::tribble(
  ~assessment, ~RSTESTCD,  ~RSTEST,            ~RSCAT,        ~RSMETHOD, ~RSSCAT,
  "PET",       "OVRLRESP", "Overall Response", "LUGANO 2014", "PET-CT",  "INCLUDING PET-CT SCAN",
  "CT",        "OVRLRESP", "Overall Response", "LUGANO 2014", "CT",      "NOT INCLUDING PET SCAN"
)

rs_onco_lymphoma <- rs_onco_lymphoma_pre %>%
  left_join(testnames, by = "assessment") %>%
  mutate(
    STUDYID = "CDISCPILOT01",
    DOMAIN = "RS",
    RSEVAL = "INVESTIGATOR",
    RSSTAT = case_when(
      assessment == "PET" & PETSTAT == "NOT DONE" ~ "NOT DONE",
      TRUE ~ NA_character_
    ),
    RSSTRESC = case_when(
      assessment == "PET" & RSSTAT == "NOT DONE" ~ NA_character_,
      TRUE ~ RSORRES
    ),
    RSBLFL = if_else(VISIT == "BASELINE", "Y", NA_character_)
  ) %>%
  filter(!(assessment == "PET" & is.na(RSORRES) & is.na(RSSTAT))) %>%
  filter(!(assessment == "CT" & is.na(RSORRES))) %>%
  derive_var_obs_number(
    by_vars = exprs(USUBJID),
    order = exprs(VISITNUM, RSEVAL, RSTESTCD, RSSCAT),
    new_var = RSSEQ
  ) %>%
  select(
    STUDYID, DOMAIN, USUBJID, RSSEQ, RSTESTCD, RSTEST, RSCAT, RSMETHOD, RSSCAT,
    RSORRES, RSSTRESC, RSSTAT, RSEVAL, RSBLFL, VISITNUM, VISIT, RSDTC, RSDY
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

# Lugano 2014 response terminology for Reference----
# CMR / CAR / CR = Complete Metabolic Response / Complete Anatomic Response / Complete Response
# PMR / PAR / PR = Partial Metabolic Response / Partial Anatomic Response / Partial Response
# NMR / SAD / SD = No Metabolic Response / Stable Anatomic Response / Stable Disease
# PMD / PAD / PD = Progressive Metabolic Disease / Progressive Anatomic Disease / Progressive Disease
# PSP = Pseudoprogression
# NED = No Evidence of Disease (used by BICR only)
