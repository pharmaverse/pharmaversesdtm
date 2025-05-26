# Datasets: rs_onco_ca125, supprs_onco_ca125
# Description: RS Oncology and SUPPRS dataset using GCIG criteria

# Load libraries -----
library(dplyr)
library(usethis)

# Create rs_onco_ca125 ----
rs_onco_ca125 <- tibble::tribble(
  ~USUBJID,      ~RSSEQ,  ~RSTESTCD,            ~RSTEST,               ~RSCAT,                               ~RSORRES, ~RSSTRESC, ~VISITNUM,    ~VISIT,       ~RSDTC,
  "01-701-1015",     3L, "OVRLRESP", "Overall Response",              "CA125",                 "Non-Response/ Non-PD",      "SD",        2L,  "WEEK 3", "2014-01-23",
  "01-701-1015",     6L, "OVRLRESP", "Overall Response",              "CA125",                        "Not Evaluable",      "NE",        3L,  "WEEK 6",    "2014-02",
  "01-701-1015",     9L, "OVRLRESP", "Overall Response",              "CA125", "Response But Not Within Normal Range",      "PR",        4L,  "WEEK 9", "2014-03-06",
  "01-701-1028",     3L, "OVRLRESP", "Overall Response",              "CA125",                  "Progressive Disease",      "PD",        2L,  "WEEK 3", "2013-08-09",
  "01-701-1028",     6L, "OVRLRESP", "Overall Response",              "CA125",                  "Progressive Disease",      "PD",        3L,  "WEEK 6", "2013-08-30",
  "01-701-1028",     9L, "OVRLRESP", "Overall Response",              "CA125",                  "Progressive Disease",      "PD",        4L,  "WEEK 9", "2013-09-30",
  "01-701-1034",     3L, "OVRLRESP", "Overall Response",              "CA125",         "Response Within Normal Range",      "CR",        2L,  "WEEK 3", "2014-07-22",
  "01-701-1034",     6L, "OVRLRESP", "Overall Response",              "CA125",         "Response Within Normal Range",      "CR",        3L,  "WEEK 6", "2014-08-20",
  "01-701-1097",     3L, "OVRLRESP", "Overall Response",              "CA125",                 "Non-Response/ Non-PD",      "SD",        2L,  "WEEK 3", "2014-01-22",
  "01-701-1115",     3L, "OVRLRESP", "Overall Response",              "CA125", "Response But Not Within Normal Range",      "PR",        2L,  "WEEK 3", "2012-12-21",
  "01-701-1115",     6L, "OVRLRESP", "Overall Response",              "CA125", "Response But Not Within Normal Range",      "PR",        3L,  "WEEK 6", "2013-01-11",
  "01-701-1115",     9L, "OVRLRESP", "Overall Response",              "CA125",         "Response Within Normal Range",      "CR",        4L,  "WEEK 9", "2013-02-01",
  "01-701-1118",     3L, "OVRLRESP", "Overall Response",              "CA125",                 "Non-Response/ Non-PD",      "SD",        2L,  "WEEK 3", "2014-04-02",
  "01-701-1118",     6L, "OVRLRESP", "Overall Response",              "CA125",         "Response Within Normal Range",      "CR",        3L,  "WEEK 6", "2014-04-23",
  "01-701-1118",     9L, "OVRLRESP", "Overall Response",              "CA125",                        "Not Evaluable",      "NE",        4L,  "WEEK 9", "2014-05-14",
  "01-701-1118",    12L, "OVRLRESP", "Overall Response",              "CA125",         "Response Within Normal Range",      "CR",        5L, "WEEK 12", "2014-06-04",
  "01-701-1130",     3L, "OVRLRESP", "Overall Response",              "CA125",                 "Non-Response/ Non-PD",      "SD",        2L,  "WEEK 3", "2014-03-08",
  "01-701-1130",     6L, "OVRLRESP", "Overall Response",              "CA125",                  "Progressive Disease",      "PD",        3L,  "WEEK 6", "2014-03-29",
  "01-701-1130",     9L, "OVRLRESP", "Overall Response",              "CA125",                  "Progressive Disease",      "PD",        4L,  "WEEK 9", "2014-04-19",
  "01-701-1133",     3L, "OVRLRESP", "Overall Response",              "CA125", "Response But Not Within Normal Range",      "PR",        2L,  "WEEK 3", "2012-11-18",
  "01-701-1133",     6L, "OVRLRESP", "Overall Response",              "CA125",                  "Progressive Disease",      "PD",        3L,  "WEEK 6", "2012-12-09",
  "01-701-1133",     9L, "OVRLRESP", "Overall Response",              "CA125",                  "Progressive Disease",      "PD",        4L,  "WEEK 9", "2012-12-30",
  "01-701-1015",    12L, "OVRLRESP", "Overall Response",         "RECIST 1.1",                                   "SD",      "SD",        2L,  "WEEK 3", "2014-01-23",
  "01-701-1015",    15L, "OVRLRESP", "Overall Response",         "RECIST 1.1",                                   "NE",      "NE",        3L,  "WEEK 6",    "2014-02",
  "01-701-1015",    18L, "OVRLRESP", "Overall Response",         "RECIST 1.1",                                   "PR",      "PR",        4L,  "WEEK 9", "2014-03-06",
  "01-701-1028",    12L, "OVRLRESP", "Overall Response",         "RECIST 1.1",                                   "PR",      "PR",        2L,  "WEEK 3", "2013-08-09",
  "01-701-1028",    15L, "OVRLRESP", "Overall Response",         "RECIST 1.1",                                   "PD",      "PD",        3L,  "WEEK 6", "2013-08-30",
  "01-701-1028",    18L, "OVRLRESP", "Overall Response",         "RECIST 1.1",                                   "PD",      "PD",        4L,  "WEEK 9", "2013-09-30",
  "01-701-1034",    12L, "OVRLRESP", "Overall Response",         "RECIST 1.1",                                   "CR",      "CR",        2L,  "WEEK 3", "2014-07-22",
  "01-701-1034",    15L, "OVRLRESP", "Overall Response",         "RECIST 1.1",                                   "CR",      "CR",        3L,  "WEEK 6", "2014-08-20",
  "01-701-1097",    12L, "OVRLRESP", "Overall Response",         "RECIST 1.1",                                   "SD",      "SD",        2L,  "WEEK 3", "2014-01-22",
  "01-701-1115",    12L, "OVRLRESP", "Overall Response",         "RECIST 1.1",                                   "SD",      "SD",        2L,  "WEEK 3", "2012-12-21",
  "01-701-1115",    15L, "OVRLRESP", "Overall Response",         "RECIST 1.1",                                   "PR",      "PR",        3L,  "WEEK 6", "2013-01-11",
  "01-701-1115",    18L, "OVRLRESP", "Overall Response",         "RECIST 1.1",                                   "CR",      "CR",        4L,  "WEEK 9", "2013-02-01",
  "01-701-1118",    12L, "OVRLRESP", "Overall Response",         "RECIST 1.1",                                   "SD",      "SD",        2L,  "WEEK 3", "2014-04-02",
  "01-701-1118",    15L, "OVRLRESP", "Overall Response",         "RECIST 1.1",                                   "CR",      "CR",        3L,  "WEEK 6", "2014-04-23",
  "01-701-1118",    18L, "OVRLRESP", "Overall Response",         "RECIST 1.1",                                   "NE",      "NE",        4L,  "WEEK 9", "2014-05-14",
  "01-701-1118",    21L, "OVRLRESP", "Overall Response",         "RECIST 1.1",                                   "CR",      "CR",        5L, "WEEK 12", "2014-06-04",
  "01-701-1130",    12L, "OVRLRESP", "Overall Response",         "RECIST 1.1",                                   "SD",      "SD",        2L,  "WEEK 3", "2014-03-08",
  "01-701-1130",    15L, "OVRLRESP", "Overall Response",         "RECIST 1.1",                                   "PD",      "PD",        3L,  "WEEK 6", "2014-03-29",
  "01-701-1130",    18L, "OVRLRESP", "Overall Response",         "RECIST 1.1",                                   "PD",      "PD",        4L,  "WEEK 9", "2014-04-19",
  "01-701-1133",    12L, "OVRLRESP", "Overall Response",         "RECIST 1.1",                                   "PR",      "PR",        2L,  "WEEK 3", "2012-11-18",
  "01-701-1133",    15L, "OVRLRESP", "Overall Response",         "RECIST 1.1",                                   "PR",      "PR",        3L,  "WEEK 6", "2012-12-09",
  "01-701-1133",    18L, "OVRLRESP", "Overall Response",         "RECIST 1.1",                                   "PR",      "PR",        4L,  "WEEK 9", "2012-12-30",
  "01-701-1015",    21L, "OVRLRESP", "Overall Response", "RECIST 1.1 - CA125",                       "Stable Disease",      "SD",        2L,  "WEEK 3", "2014-01-23",
  "01-701-1015",    24L, "OVRLRESP", "Overall Response", "RECIST 1.1 - CA125",                        "Not Evaluable",      "NE",        3L,  "WEEK 6",    "2014-02",
  "01-701-1015",    27L, "OVRLRESP", "Overall Response", "RECIST 1.1 - CA125",                     "Partial Response",      "PR",        4L,  "WEEK 9", "2014-03-06",
  "01-701-1028",    21L, "OVRLRESP", "Overall Response", "RECIST 1.1 - CA125",                  "Progressive Disease",      "PD",        2L,  "WEEK 3", "2013-08-09",
  "01-701-1028",    24L, "OVRLRESP", "Overall Response", "RECIST 1.1 - CA125",                  "Progressive Disease",      "PD",        3L,  "WEEK 6", "2013-08-30",
  "01-701-1028",    27L, "OVRLRESP", "Overall Response", "RECIST 1.1 - CA125",                  "Progressive Disease",      "PD",        4L,  "WEEK 9", "2013-09-30",
  "01-701-1034",    21L, "OVRLRESP", "Overall Response", "RECIST 1.1 - CA125",                    "Complete Response",      "CR",        2L,  "WEEK 3", "2014-07-22",
  "01-701-1034",    24L, "OVRLRESP", "Overall Response", "RECIST 1.1 - CA125",                    "Complete Response",      "CR",        3L,  "WEEK 6", "2014-08-20",
  "01-701-1097",    21L, "OVRLRESP", "Overall Response", "RECIST 1.1 - CA125",                       "Stable Disease",      "SD",        2L,  "WEEK 3", "2014-01-22",
  "01-701-1115",    21L, "OVRLRESP", "Overall Response", "RECIST 1.1 - CA125",                     "Partial Response",      "PR",        2L,  "WEEK 3", "2012-12-21",
  "01-701-1115",    24L, "OVRLRESP", "Overall Response", "RECIST 1.1 - CA125",                     "Partial Response",      "PR",        3L,  "WEEK 6", "2013-01-11",
  "01-701-1115",    27L, "OVRLRESP", "Overall Response", "RECIST 1.1 - CA125",                    "Complete Response",      "CR",        4L,  "WEEK 9", "2013-02-01",
  "01-701-1118",    21L, "OVRLRESP", "Overall Response", "RECIST 1.1 - CA125",                       "Stable Disease",      "SD",        2L,  "WEEK 3", "2014-04-02",
  "01-701-1118",    24L, "OVRLRESP", "Overall Response", "RECIST 1.1 - CA125",                    "Complete Response",      "CR",        3L,  "WEEK 6", "2014-04-23",
  "01-701-1118",    27L, "OVRLRESP", "Overall Response", "RECIST 1.1 - CA125",                        "Not Evaluable",      "NE",        4L,  "WEEK 9", "2014-05-14",
  "01-701-1118",    30L, "OVRLRESP", "Overall Response", "RECIST 1.1 - CA125",                    "Complete Response",      "CR",        5L, "WEEK 12", "2014-06-04",
  "01-701-1130",    21L, "OVRLRESP", "Overall Response", "RECIST 1.1 - CA125",                       "Stable Disease",      "SD",        2L,  "WEEK 3", "2014-03-08",
  "01-701-1130",    24L, "OVRLRESP", "Overall Response", "RECIST 1.1 - CA125",                  "Progressive Disease",      "PD",        3L,  "WEEK 6", "2014-03-29",
  "01-701-1130",    27L, "OVRLRESP", "Overall Response", "RECIST 1.1 - CA125",                  "Progressive Disease",      "PD",        4L,  "WEEK 9", "2014-04-19",
  "01-701-1133",    21L, "OVRLRESP", "Overall Response", "RECIST 1.1 - CA125",                     "Partial Response",      "PR",        2L,  "WEEK 3", "2012-11-18",
  "01-701-1133",    24L, "OVRLRESP", "Overall Response", "RECIST 1.1 - CA125",                  "Progressive Disease",      "PD",        3L,  "WEEK 6", "2012-12-09",
  "01-701-1133",    27L, "OVRLRESP", "Overall Response", "RECIST 1.1 - CA125",                  "Progressive Disease",      "PD",        4L,  "WEEK 9", "2012-12-30"
) %>%
  mutate(
    STUDYID = "CDISCPILOT01",
    DOMAIN = "RS",
    RSEVAL = "INVESTIGATOR"
  ) %>%
  relocate(
    STUDYID, DOMAIN, USUBJID, RSSEQ, RSTESTCD, RSTEST, RSCAT, RSORRES,
    RSSTRESC, RSEVAL, VISITNUM, VISIT, RSDTC
  )

# Label variables ----
rs_onco_ca125 <- rs_onco_ca125 %>%
  add_labels(
    STUDYID = "Study Identifier",
    DOMAIN = "Domain Abbreviation",
    USUBJID = "Unique Subject Identifier",
    RSSEQ = "Sequence Number",
    RSTESTCD = "Assessment Short Name",
    RSTEST = "Assessment Name",
    RSCAT = "Category for Assessment",
    RSORRES = "Result or Finding in Original Units",
    RSSTRESC = "Character Result/Finding in Std Format",
    RSEVAL = "Evaluator",
    VISITNUM = "Visit Number",
    VISIT = "Visit Name",
    RSDTC = "Date/Time of Assessment"
  )

attr(rs_onco_ca125, "label") <- "Disease Response (CA125)"

usethis::use_data(rs_onco_ca125, overwrite = TRUE)

# Create supprs_onco_imwg ----
supprs_onco_ca125 <- tibble::tribble(
  ~USUBJID,      ~IDVARVAL,      ~QNAM,                                    ~QLABEL, ~QVAL,
  "01-701-1133",        3L, "CA125EFL",                "CA-125 response evaluable",   "Y",
  "01-701-1133",        6L, "CA125EFL",                "CA-125 response evaluable",   "Y",
  "01-701-1133",        9L, "CA125EFL",                "CA-125 response evaluable",   "Y",
  "01-701-1133",        3L, "CAELEPRE",            "Elevated pre-treatment CA-125",   "Y",
  "01-701-1133",        6L, "CAELEPRE",            "Elevated pre-treatment CA-125",   "Y",
  "01-701-1133",        9L, "CAELEPRE",            "Elevated pre-treatment CA-125",   "Y",
  "01-701-1133",        3L,  "CA50RED",            ">=50% reduction from baseline",   "Y",
  "01-701-1133",        6L, "CANORM2X",    "CA125 normal, lab increased >=2x ULRR",   "Y",
  "01-701-1133",        9L, "CANORM2X",    "CA125 normal, lab increased >=2x ULRR",   "Y",
  "01-701-1130",        3L, "CA125EFL",                "CA-125 response evaluable",   "Y",
  "01-701-1130",        6L, "CA125EFL",                "CA-125 response evaluable",   "Y",
  "01-701-1130",        9L, "CA125EFL",                "CA-125 response evaluable",   "Y",
  "01-701-1130",        3L, "CAELEPRE",            "Elevated pre-treatment CA-125",   "Y",
  "01-701-1130",        6L, "CAELEPRE",            "Elevated pre-treatment CA-125",   "Y",
  "01-701-1130",        9L, "CAELEPRE",            "Elevated pre-treatment CA-125",   "Y",
  "01-701-1130",        6L, "CNOTNORM", "CA125 not norm, lab increased >=2x nadir",   "Y",
  "01-701-1130",        9L, "CNOTNORM", "CA125 not norm, lab increased >=2x nadir",   "Y",
  "01-701-1028",        3L, "CA125EFL",                "CA-125 response evaluable",   "N",
  "01-701-1028",        6L, "CA125EFL",                "CA-125 response evaluable",   "N",
  "01-701-1028",        9L, "CA125EFL",                "CA-125 response evaluable",   "N",
  "01-701-1028",        3L, "CAELEPRE",            "Elevated pre-treatment CA-125",   "N",
  "01-701-1028",        6L, "CAELEPRE",            "Elevated pre-treatment CA-125",   "N",
  "01-701-1028",        9L, "CAELEPRE",            "Elevated pre-treatment CA-125",   "N",
  "01-701-1028",        3L, "CANORM2X",    "CA125 normal, lab increased >=2x ULRR",   "Y",
  "01-701-1028",        6L, "CANORM2X",    "CA125 normal, lab increased >=2x ULRR",   "Y",
  "01-701-1028",        9L, "CANORM2X",    "CA125 normal, lab increased >=2x ULRR",   "Y",
  "01-701-1034",        3L, "CA125EFL",                "CA-125 response evaluable",   "Y",
  "01-701-1034",        6L, "CA125EFL",                "CA-125 response evaluable",   "Y",
  "01-701-1034",        3L,  "CA50RED",            ">=50% reduction from baseline",   "Y",
  "01-701-1034",        6L,  "CA50RED",            ">=50% reduction from baseline",   "Y",
  "01-701-1097",        3L, "CA125EFL",                "CA-125 response evaluable",   "Y",
  "01-701-1015",        3L, "CA125EFL",                "CA-125 response evaluable",   "Y",
  "01-701-1015",        6L, "CA125EFL",                "CA-125 response evaluable",   "Y",
  "01-701-1015",        9L, "CA125EFL",                "CA-125 response evaluable",   "Y",
  "01-701-1015",        9L,  "CA50RED",            ">=50% reduction from baseline",   "Y",
  "01-701-1015",        6L, "MOUSEANT",                "Received mouse antibodies",   "Y",
  "01-701-1015",       24L, "MOUSEANT",                "Received mouse antibodies",   "Y",
  "01-701-1115",        3L, "CA125EFL",                "CA-125 response evaluable",   "Y",
  "01-701-1115",        6L, "CA125EFL",                "CA-125 response evaluable",   "Y",
  "01-701-1115",        9L, "CA125EFL",                "CA-125 response evaluable",   "Y",
  "01-701-1115",        3L,  "CA50RED",            ">=50% reduction from baseline",   "Y",
  "01-701-1115",        6L,  "CA50RED",            ">=50% reduction from baseline",   "Y",
  "01-701-1115",        9L,  "CA50RED",            ">=50% reduction from baseline",   "Y",
  "01-701-1118",        3L, "CA125EFL",                "CA-125 response evaluable",   "Y",
  "01-701-1118",        6L, "CA125EFL",                "CA-125 response evaluable",   "Y",
  "01-701-1118",        9L, "CA125EFL",                "CA-125 response evaluable",   "Y",
  "01-701-1118",       12L, "CA125EFL",                "CA-125 response evaluable",   "Y",
  "01-701-1118",        6L,  "CA50RED",            ">=50% reduction from baseline",   "Y",
  "01-701-1118",       12L,  "CA50RED",            ">=50% reduction from baseline",   "Y"
) %>%
  mutate(
    STUDYID = "CDISCPILOT01",
    RDOMAIN = "RS",
    IDVAR = "RSSEQ",
    QORIG = "CRF",
    IDVARVAL = as.character(IDVARVAL)
  ) %>%
  relocate(
    STUDYID, RDOMAIN, USUBJID, IDVAR, IDVARVAL, QNAM, QLABEL, QVAL, QORIG
  )

# Label variables ----
supprs_onco_ca125 <- supprs_onco_ca125 %>%
  add_labels(
    STUDYID = "Study Identifier",
    RDOMAIN = "Related Domain Abbreviation",
    USUBJID = "Unique Subject Identifier",
    IDVAR = "Identifying Variable",
    IDVARVAL = "Identifying Variable Value",
    QNAM = "Qualifier Variable Name",
    QLABEL = "Qualifier Variable Label",
    QVAL = "Data Value",
    QORIG = "Origin"
  )

attr(supprs_onco_ca125, "label") <- "Supplemental Qualifiers for RS_ONCO_CA125"

usethis::use_data(supprs_onco_ca125, overwrite = TRUE)
