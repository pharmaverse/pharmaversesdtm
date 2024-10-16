# Datasets: rs_onco_ca125, supprs_onco_ca125
# Description: RS Oncology and SUPPRS dataset using IMWG criteria

# Load libraries -----
library(dplyr)
library(usethis)

# Create rs_onco_ca125 ----
rs_onco_ca125 <- tibble::tribble(
  ~DOMAIN,       ~STUDYID,      ~USUBJID, ~VISITNUM,    ~VISIT,               ~RSCAT,  ~RSTESTCD,            ~RSTEST,                               ~RSORRES,       ~RSSTRESC,        ~RSEVAL, ~RSEVALID, ~RSACPTFL,       ~RSDTC, ~RSSEQ,
  "RS", "CDISCPILOT01", "01-701-1015",        2L,  "WEEK 3",              "CA125", "OVRLRESP", "Overall Response",                 "Non-Response/ Non-PD",            "SD", "INVESTIGATOR",        NA,        NA, "2014-01-23",     3L,
  "RS", "CDISCPILOT01", "01-701-1015",        3L,  "WEEK 6",              "CA125", "OVRLRESP", "Overall Response",                        "Not Evaluable",            "NE", "INVESTIGATOR",        NA,        NA,    "2014-02",     6L,
  "RS", "CDISCPILOT01", "01-701-1015",        4L,  "WEEK 9",              "CA125", "OVRLRESP", "Overall Response", "Response But Not Within Normal Range",            "PR", "INVESTIGATOR",        NA,        NA, "2014-03-06",     9L,
  "RS", "CDISCPILOT01", "01-701-1028",        2L,  "WEEK 3",              "CA125", "OVRLRESP", "Overall Response",                  "Progressive Disease",            "PD", "INVESTIGATOR",        NA,        NA, "2013-08-09",     3L,
  "RS", "CDISCPILOT01", "01-701-1028",        3L,  "WEEK 6",              "CA125", "OVRLRESP", "Overall Response",                  "Progressive Disease",            "PD", "INVESTIGATOR",        NA,        NA, "2013-08-30",     6L,
  "RS", "CDISCPILOT01", "01-701-1028",        4L,  "WEEK 9",              "CA125", "OVRLRESP", "Overall Response",                  "Progressive Disease",            "PD", "INVESTIGATOR",        NA,        NA, "2013-09-30",     9L,
  "RS", "CDISCPILOT01", "01-701-1034",        2L,  "WEEK 3",              "CA125", "OVRLRESP", "Overall Response",         "Response Within Normal Range",            "CR", "INVESTIGATOR",        NA,        NA, "2014-07-22",     3L,
  "RS", "CDISCPILOT01", "01-701-1034",        3L,  "WEEK 6",              "CA125", "OVRLRESP", "Overall Response",         "Response Within Normal Range",            "CR", "INVESTIGATOR",        NA,        NA, "2014-08-20",     6L,
  "RS", "CDISCPILOT01", "01-701-1097",        2L,  "WEEK 3",              "CA125", "OVRLRESP", "Overall Response",                 "Non-Response/ Non-PD",            "SD", "INVESTIGATOR",        NA,        NA, "2014-01-22",     3L,
  "RS", "CDISCPILOT01", "01-701-1115",        2L,  "WEEK 3",              "CA125", "OVRLRESP", "Overall Response", "Response But Not Within Normal Range",            "PR", "INVESTIGATOR",        NA,        NA, "2012-12-21",     3L,
  "RS", "CDISCPILOT01", "01-701-1115",        3L,  "WEEK 6",              "CA125", "OVRLRESP", "Overall Response", "Response But Not Within Normal Range",            "PR", "INVESTIGATOR",        NA,        NA, "2013-01-11",     6L,
  "RS", "CDISCPILOT01", "01-701-1115",        4L,  "WEEK 9",              "CA125", "OVRLRESP", "Overall Response",         "Response Within Normal Range",            "CR", "INVESTIGATOR",        NA,        NA, "2013-02-01",     9L,
  "RS", "CDISCPILOT01", "01-701-1118",        2L,  "WEEK 3",              "CA125", "OVRLRESP", "Overall Response",                 "Non-Response/ Non-PD",            "SD", "INVESTIGATOR",        NA,        NA, "2014-04-02",     3L,
  "RS", "CDISCPILOT01", "01-701-1118",        3L,  "WEEK 6",              "CA125", "OVRLRESP", "Overall Response",         "Response Within Normal Range",            "CR", "INVESTIGATOR",        NA,        NA, "2014-04-23",     6L,
  "RS", "CDISCPILOT01", "01-701-1118",        4L,  "WEEK 9",              "CA125", "OVRLRESP", "Overall Response",                        "Not Evaluable",            "NE", "INVESTIGATOR",        NA,        NA, "2014-05-14",     9L,
  "RS", "CDISCPILOT01", "01-701-1118",        5L, "WEEK 12",              "CA125", "OVRLRESP", "Overall Response",         "Response Within Normal Range",            "CR", "INVESTIGATOR",        NA,        NA, "2014-06-04",    12L,
  "RS", "CDISCPILOT01", "01-701-1130",        2L,  "WEEK 3",              "CA125", "OVRLRESP", "Overall Response",                 "Non-Response/ Non-PD",            "SD", "INVESTIGATOR",        NA,        NA, "2014-03-08",     3L,
  "RS", "CDISCPILOT01", "01-701-1130",        3L,  "WEEK 6",              "CA125", "OVRLRESP", "Overall Response",                  "Progressive Disease",            "PD", "INVESTIGATOR",        NA,        NA, "2014-03-29",     6L,
  "RS", "CDISCPILOT01", "01-701-1130",        4L,  "WEEK 9",              "CA125", "OVRLRESP", "Overall Response",                  "Progressive Disease",            "PD", "INVESTIGATOR",        NA,        NA, "2014-04-19",     9L,
  "RS", "CDISCPILOT01", "01-701-1133",        2L,  "WEEK 3",              "CA125", "OVRLRESP", "Overall Response", "Response But Not Within Normal Range",            "PR", "INVESTIGATOR",        NA,        NA, "2012-11-18",     3L,
  "RS", "CDISCPILOT01", "01-701-1133",        3L,  "WEEK 6",              "CA125", "OVRLRESP", "Overall Response",                  "Progressive Disease",            "PD", "INVESTIGATOR",        NA,        NA, "2012-12-09",     6L,
  "RS", "CDISCPILOT01", "01-701-1133",        4L,  "WEEK 9",              "CA125", "OVRLRESP", "Overall Response",                  "Progressive Disease",            "PD", "INVESTIGATOR",        NA,        NA, "2012-12-30",     9L,
  "RS", "CDISCPILOT01", "01-701-1015",        2L,  "WEEK 3",         "RECIST 1.1", "OVRLRESP", "Overall Response",                                   "SD",            "SD", "INVESTIGATOR",        NA,        NA, "2014-01-23",    12L,
  "RS", "CDISCPILOT01", "01-701-1015",        3L,  "WEEK 6",         "RECIST 1.1", "OVRLRESP", "Overall Response",                                   "NE",            "NE", "INVESTIGATOR",        NA,        NA,    "2014-02",    15L,
  "RS", "CDISCPILOT01", "01-701-1015",        4L,  "WEEK 9",         "RECIST 1.1", "OVRLRESP", "Overall Response",                                   "PR",            "PR", "INVESTIGATOR",        NA,        NA, "2014-03-06",    18L,
  "RS", "CDISCPILOT01", "01-701-1028",        2L,  "WEEK 3",         "RECIST 1.1", "OVRLRESP", "Overall Response",                                   "PR",            "PR", "INVESTIGATOR",        NA,        NA, "2013-08-09",    12L,
  "RS", "CDISCPILOT01", "01-701-1028",        3L,  "WEEK 6",         "RECIST 1.1", "OVRLRESP", "Overall Response",                                   "PD",            "PD", "INVESTIGATOR",        NA,        NA, "2013-08-30",    15L,
  "RS", "CDISCPILOT01", "01-701-1028",        4L,  "WEEK 9",         "RECIST 1.1", "OVRLRESP", "Overall Response",                                   "PD",            "PD", "INVESTIGATOR",        NA,        NA, "2013-09-30",    18L,
  "RS", "CDISCPILOT01", "01-701-1034",        2L,  "WEEK 3",         "RECIST 1.1", "OVRLRESP", "Overall Response",                        "NON-CR/NON-PD", "NON-CR/NON-PD", "INVESTIGATOR",        NA,        NA, "2014-07-22",    12L,
  "RS", "CDISCPILOT01", "01-701-1034",        3L,  "WEEK 6",         "RECIST 1.1", "OVRLRESP", "Overall Response",                                   "CR",            "CR", "INVESTIGATOR",        NA,        NA, "2014-08-20",    15L,
  "RS", "CDISCPILOT01", "01-701-1097",        2L,  "WEEK 3",         "RECIST 1.1", "OVRLRESP", "Overall Response",                                   "SD",            "SD", "INVESTIGATOR",        NA,        NA, "2014-01-22",    12L,
  "RS", "CDISCPILOT01", "01-701-1115",        2L,  "WEEK 3",         "RECIST 1.1", "OVRLRESP", "Overall Response",                                   "SD",            "SD", "INVESTIGATOR",        NA,        NA, "2012-12-21",    12L,
  "RS", "CDISCPILOT01", "01-701-1115",        3L,  "WEEK 6",         "RECIST 1.1", "OVRLRESP", "Overall Response",                                   "PR",            "PR", "INVESTIGATOR",        NA,        NA, "2013-01-11",    15L,
  "RS", "CDISCPILOT01", "01-701-1115",        4L,  "WEEK 9",         "RECIST 1.1", "OVRLRESP", "Overall Response",                                   "CR",            "CR", "INVESTIGATOR",        NA,        NA, "2013-02-01",    18L,
  "RS", "CDISCPILOT01", "01-701-1118",        2L,  "WEEK 3",         "RECIST 1.1", "OVRLRESP", "Overall Response",                                   "SD",            "SD", "INVESTIGATOR",        NA,        NA, "2014-04-02",    12L,
  "RS", "CDISCPILOT01", "01-701-1118",        3L,  "WEEK 6",         "RECIST 1.1", "OVRLRESP", "Overall Response",                                   "CR",            "CR", "INVESTIGATOR",        NA,        NA, "2014-04-23",    15L,
  "RS", "CDISCPILOT01", "01-701-1118",        4L,  "WEEK 9",         "RECIST 1.1", "OVRLRESP", "Overall Response",                                   "NE",            "NE", "INVESTIGATOR",        NA,        NA, "2014-05-14",    18L,
  "RS", "CDISCPILOT01", "01-701-1118",        5L, "WEEK 12",         "RECIST 1.1", "OVRLRESP", "Overall Response",                                   "CR",            "CR", "INVESTIGATOR",        NA,        NA, "2014-06-04",    21L,
  "RS", "CDISCPILOT01", "01-701-1130",        2L,  "WEEK 3",         "RECIST 1.1", "OVRLRESP", "Overall Response",                                   "SD",            "SD", "INVESTIGATOR",        NA,        NA, "2014-03-08",    12L,
  "RS", "CDISCPILOT01", "01-701-1130",        3L,  "WEEK 6",         "RECIST 1.1", "OVRLRESP", "Overall Response",                                   "PD",            "PD", "INVESTIGATOR",        NA,        NA, "2014-03-29",    15L,
  "RS", "CDISCPILOT01", "01-701-1130",        4L,  "WEEK 9",         "RECIST 1.1", "OVRLRESP", "Overall Response",                                   "PD",            "PD", "INVESTIGATOR",        NA,        NA, "2014-04-19",    18L,
  "RS", "CDISCPILOT01", "01-701-1133",        2L,  "WEEK 3",         "RECIST 1.1", "OVRLRESP", "Overall Response",                                   "PR",            "PR", "INVESTIGATOR",        NA,        NA, "2012-11-18",    12L,
  "RS", "CDISCPILOT01", "01-701-1133",        3L,  "WEEK 6",         "RECIST 1.1", "OVRLRESP", "Overall Response",                                   "PR",            "PR", "INVESTIGATOR",        NA,        NA, "2012-12-09",    15L,
  "RS", "CDISCPILOT01", "01-701-1133",        4L,  "WEEK 9",         "RECIST 1.1", "OVRLRESP", "Overall Response",                                   "PR",            "PR", "INVESTIGATOR",        NA,        NA, "2012-12-30",    18L,
  "RS", "CDISCPILOT01", "01-701-1015",        2L,  "WEEK 3", "RECIST 1.1 - CA125", "OVRLRESP", "Overall Response",                       "Stable Disease",            "SD", "INVESTIGATOR",        NA,        NA, "2014-01-23",    21L,
  "RS", "CDISCPILOT01", "01-701-1015",        3L,  "WEEK 6", "RECIST 1.1 - CA125", "OVRLRESP", "Overall Response",                        "Not Evaluable",            "NE", "INVESTIGATOR",        NA,        NA,    "2014-02",    24L,
  "RS", "CDISCPILOT01", "01-701-1015",        4L,  "WEEK 9", "RECIST 1.1 - CA125", "OVRLRESP", "Overall Response",                     "Partial Response",            "PR", "INVESTIGATOR",        NA,        NA, "2014-03-06",    27L,
  "RS", "CDISCPILOT01", "01-701-1028",        2L,  "WEEK 3", "RECIST 1.1 - CA125", "OVRLRESP", "Overall Response",                  "Progressive Disease",            "PD", "INVESTIGATOR",        NA,        NA, "2013-08-09",    21L,
  "RS", "CDISCPILOT01", "01-701-1028",        3L,  "WEEK 6", "RECIST 1.1 - CA125", "OVRLRESP", "Overall Response",                  "Progressive Disease",            "PD", "INVESTIGATOR",        NA,        NA, "2013-08-30",    24L,
  "RS", "CDISCPILOT01", "01-701-1028",        4L,  "WEEK 9", "RECIST 1.1 - CA125", "OVRLRESP", "Overall Response",                  "Progressive Disease",            "PD", "INVESTIGATOR",        NA,        NA, "2013-09-30",    27L,
  "RS", "CDISCPILOT01", "01-701-1034",        2L,  "WEEK 3", "RECIST 1.1 - CA125", "OVRLRESP", "Overall Response",                    "Complete Response",            "CR", "INVESTIGATOR",        NA,        NA, "2014-07-22",    21L,
  "RS", "CDISCPILOT01", "01-701-1034",        3L,  "WEEK 6", "RECIST 1.1 - CA125", "OVRLRESP", "Overall Response",                    "Complete Response",            "CR", "INVESTIGATOR",        NA,        NA, "2014-08-20",    24L,
  "RS", "CDISCPILOT01", "01-701-1097",        2L,  "WEEK 3", "RECIST 1.1 - CA125", "OVRLRESP", "Overall Response",                       "Stable Disease",            "SD", "INVESTIGATOR",        NA,        NA, "2014-01-22",    21L,
  "RS", "CDISCPILOT01", "01-701-1115",        2L,  "WEEK 3", "RECIST 1.1 - CA125", "OVRLRESP", "Overall Response",                     "Partial Response",            "PR", "INVESTIGATOR",        NA,        NA, "2012-12-21",    21L,
  "RS", "CDISCPILOT01", "01-701-1115",        3L,  "WEEK 6", "RECIST 1.1 - CA125", "OVRLRESP", "Overall Response",                     "Partial Response",            "PR", "INVESTIGATOR",        NA,        NA, "2013-01-11",    24L,
  "RS", "CDISCPILOT01", "01-701-1115",        4L,  "WEEK 9", "RECIST 1.1 - CA125", "OVRLRESP", "Overall Response",                    "Complete Response",            "CR", "INVESTIGATOR",        NA,        NA, "2013-02-01",    27L,
  "RS", "CDISCPILOT01", "01-701-1118",        2L,  "WEEK 3", "RECIST 1.1 - CA125", "OVRLRESP", "Overall Response",                       "Stable Disease",            "SD", "INVESTIGATOR",        NA,        NA, "2014-04-02",    21L,
  "RS", "CDISCPILOT01", "01-701-1118",        3L,  "WEEK 6", "RECIST 1.1 - CA125", "OVRLRESP", "Overall Response",                    "Complete Response",            "CR", "INVESTIGATOR",        NA,        NA, "2014-04-23",    24L,
  "RS", "CDISCPILOT01", "01-701-1118",        4L,  "WEEK 9", "RECIST 1.1 - CA125", "OVRLRESP", "Overall Response",                        "Not Evaluable",            "NE", "INVESTIGATOR",        NA,        NA, "2014-05-14",    27L,
  "RS", "CDISCPILOT01", "01-701-1118",        5L, "WEEK 12", "RECIST 1.1 - CA125", "OVRLRESP", "Overall Response",                    "Complete Response",            "CR", "INVESTIGATOR",        NA,        NA, "2014-06-04",    30L,
  "RS", "CDISCPILOT01", "01-701-1130",        2L,  "WEEK 3", "RECIST 1.1 - CA125", "OVRLRESP", "Overall Response",                       "Stable Disease",            "SD", "INVESTIGATOR",        NA,        NA, "2014-03-08",    21L,
  "RS", "CDISCPILOT01", "01-701-1130",        3L,  "WEEK 6", "RECIST 1.1 - CA125", "OVRLRESP", "Overall Response",                  "Progressive Disease",            "PD", "INVESTIGATOR",        NA,        NA, "2014-03-29",    24L,
  "RS", "CDISCPILOT01", "01-701-1130",        4L,  "WEEK 9", "RECIST 1.1 - CA125", "OVRLRESP", "Overall Response",                  "Progressive Disease",            "PD", "INVESTIGATOR",        NA,        NA, "2014-04-19",    27L,
  "RS", "CDISCPILOT01", "01-701-1133",        2L,  "WEEK 3", "RECIST 1.1 - CA125", "OVRLRESP", "Overall Response",                     "Partial Response",            "PR", "INVESTIGATOR",        NA,        NA, "2012-11-18",    21L,
  "RS", "CDISCPILOT01", "01-701-1133",        3L,  "WEEK 6", "RECIST 1.1 - CA125", "OVRLRESP", "Overall Response",                  "Progressive Disease",            "PD", "INVESTIGATOR",        NA,        NA, "2012-12-09",    24L,
  "RS", "CDISCPILOT01", "01-701-1133",        4L,  "WEEK 9", "RECIST 1.1 - CA125", "OVRLRESP", "Overall Response",                  "Progressive Disease",            "PD", "INVESTIGATOR",        NA,        NA, "2012-12-30",    27L
) %>%
  mutate(
    STUDYID = "CDISCPILOT01",
    DOMAIN = "RS",
    # RSCAT = "IMWG",
    RSEVAL = "INVESTIGATOR"
  ) %>%
  relocate(
    STUDYID, DOMAIN, USUBJID, RSSEQ, RSTESTCD, RSTEST, RSCAT, RSORRES,
    RSSTRESC, RSEVAL, VISITNUM, VISIT, RSDTC
  )

attr(rs_onco_ca125, "label") <- "Disease Response (CA125)"

usethis::use_data(rs_onco_ca125, overwrite = TRUE)

# Create supprs_onco_imwg ----
supprs_onco_ca125 <- tibble::tribble(
        ~STUDYID, ~RDOMAIN,      ~USUBJID,  ~IDVAR, ~IDVARVAL,      ~QNAM,                                    ~QLABEL, ~QVAL,
  "CDISCPILOT01",     "RS", "01-701-1133", "RSSEQ",        3L, "CA125EFL",                "CA-125 response evaluable",   "Y",
  "CDISCPILOT01",     "RS", "01-701-1133", "RSSEQ",        6L, "CA125EFL",                "CA-125 response evaluable",   "Y",
  "CDISCPILOT01",     "RS", "01-701-1133", "RSSEQ",        9L, "CA125EFL",                "CA-125 response evaluable",   "Y",
  "CDISCPILOT01",     "RS", "01-701-1133", "RSSEQ",        3L, "CA2XULRR",             "CA-125 pre-treatment 2x ULRR",   "Y",
  "CDISCPILOT01",     "RS", "01-701-1133", "RSSEQ",        6L, "CA2XULRR",             "CA-125 pre-treatment 2x ULRR",   "Y",
  "CDISCPILOT01",     "RS", "01-701-1133", "RSSEQ",        9L, "CA2XULRR",             "CA-125 pre-treatment 2x ULRR",   "Y",
  "CDISCPILOT01",     "RS", "01-701-1133", "RSSEQ",        6L, "CANORM2X",    "CA125 normal, lab increased >=2x ULRR",   "Y",
  "CDISCPILOT01",     "RS", "01-701-1133", "RSSEQ",        9L, "CANORM2X",    "CA125 normal, lab increased >=2x ULRR",   "Y",
  "CDISCPILOT01",     "RS", "01-701-1130", "RSSEQ",        3L, "CA125EFL",                "CA-125 response evaluable",   "Y",
  "CDISCPILOT01",     "RS", "01-701-1130", "RSSEQ",        6L, "CA125EFL",                "CA-125 response evaluable",   "Y",
  "CDISCPILOT01",     "RS", "01-701-1130", "RSSEQ",        9L, "CA125EFL",                "CA-125 response evaluable",   "Y",
  "CDISCPILOT01",     "RS", "01-701-1130", "RSSEQ",        3L, "CA2XULRR",             "CA-125 pre-treatment 2x ULRR",   "Y",
  "CDISCPILOT01",     "RS", "01-701-1130", "RSSEQ",        6L, "CA2XULRR",             "CA-125 pre-treatment 2x ULRR",   "Y",
  "CDISCPILOT01",     "RS", "01-701-1130", "RSSEQ",        9L, "CA2XULRR",             "CA-125 pre-treatment 2x ULRR",   "Y",
  "CDISCPILOT01",     "RS", "01-701-1130", "RSSEQ",        6L, "CNOTNORM", "CA125 not norm, lab increased >=2x nadir",   "Y",
  "CDISCPILOT01",     "RS", "01-701-1130", "RSSEQ",        9L, "CNOTNORM", "CA125 not norm, lab increased >=2x nadir",   "Y",
  "CDISCPILOT01",     "RS", "01-701-1028", "RSSEQ",        3L, "CA125EFL",                "CA-125 response evaluable",   "N",
  "CDISCPILOT01",     "RS", "01-701-1028", "RSSEQ",        6L, "CA125EFL",                "CA-125 response evaluable",   "N",
  "CDISCPILOT01",     "RS", "01-701-1028", "RSSEQ",        9L, "CA125EFL",                "CA-125 response evaluable",   "N",
  "CDISCPILOT01",     "RS", "01-701-1028", "RSSEQ",        3L, "CA2XULRR",             "CA-125 pre-treatment 2x ULRR",   "N",
  "CDISCPILOT01",     "RS", "01-701-1028", "RSSEQ",        6L, "CA2XULRR",             "CA-125 pre-treatment 2x ULRR",   "N",
  "CDISCPILOT01",     "RS", "01-701-1028", "RSSEQ",        9L, "CA2XULRR",             "CA-125 pre-treatment 2x ULRR",   "N",
  "CDISCPILOT01",     "RS", "01-701-1028", "RSSEQ",        3L, "CNOTNORM", "CA125 not norm, lab increased >=2x nadir",   "Y",
  "CDISCPILOT01",     "RS", "01-701-1028", "RSSEQ",        6L, "CNOTNORM", "CA125 not norm, lab increased >=2x nadir",   "Y",
  "CDISCPILOT01",     "RS", "01-701-1028", "RSSEQ",        9L, "CNOTNORM", "CA125 not norm, lab increased >=2x nadir",   "Y",
  "CDISCPILOT01",     "RS", "01-701-1034", "RSSEQ",        3L, "CA125EFL",                "CA-125 response evaluable",   "Y",
  "CDISCPILOT01",     "RS", "01-701-1034", "RSSEQ",        6L, "CA125EFL",                "CA-125 response evaluable",   "Y",
  "CDISCPILOT01",     "RS", "01-701-1034", "RSSEQ",        3L, "CA2XULRR",             "CA-125 pre-treatment 2x ULRR",   "Y",
  "CDISCPILOT01",     "RS", "01-701-1034", "RSSEQ",        6L, "CA2XULRR",             "CA-125 pre-treatment 2x ULRR",   "Y",
  "CDISCPILOT01",     "RS", "01-701-1034", "RSSEQ",        3L,  "CA50RED",             ">50% reduction from baseline",   "Y",
  "CDISCPILOT01",     "RS", "01-701-1034", "RSSEQ",        6L,  "CA50RED",             ">50% reduction from baseline",   "Y",
  "CDISCPILOT01",     "RS", "01-701-1097", "RSSEQ",        3L, "CA125EFL",                "CA-125 response evaluable",   "Y",
  "CDISCPILOT01",     "RS", "01-701-1097", "RSSEQ",        3L, "CA2XULRR",             "CA-125 pre-treatment 2x ULRR",   "Y",
  "CDISCPILOT01",     "RS", "01-701-1015", "RSSEQ",        3L, "CA125EFL",                "CA-125 response evaluable",   "Y",
  "CDISCPILOT01",     "RS", "01-701-1015", "RSSEQ",        6L, "CA125EFL",                "CA-125 response evaluable",   "Y",
  "CDISCPILOT01",     "RS", "01-701-1015", "RSSEQ",        9L, "CA125EFL",                "CA-125 response evaluable",   "Y",
  "CDISCPILOT01",     "RS", "01-701-1015", "RSSEQ",        3L, "CA2XULRR",             "CA-125 pre-treatment 2x ULRR",   "Y",
  "CDISCPILOT01",     "RS", "01-701-1015", "RSSEQ",        6L, "CA2XULRR",             "CA-125 pre-treatment 2x ULRR",   "Y",
  "CDISCPILOT01",     "RS", "01-701-1015", "RSSEQ",        9L, "CA2XULRR",             "CA-125 pre-treatment 2x ULRR",   "Y",
  "CDISCPILOT01",     "RS", "01-701-1015", "RSSEQ",        9L,  "CA50RED",             ">50% reduction from baseline",   "Y",
  "CDISCPILOT01",     "RS", "01-701-1015", "RSSEQ",        6L, "MOUSEANT",                "Received mouse antibodies",   "Y",
  "CDISCPILOT01",     "RS", "01-701-1115", "RSSEQ",        3L, "CA125EFL",                "CA-125 response evaluable",   "Y",
  "CDISCPILOT01",     "RS", "01-701-1115", "RSSEQ",        6L, "CA125EFL",                "CA-125 response evaluable",   "Y",
  "CDISCPILOT01",     "RS", "01-701-1115", "RSSEQ",        9L, "CA125EFL",                "CA-125 response evaluable",   "Y",
  "CDISCPILOT01",     "RS", "01-701-1115", "RSSEQ",        3L, "CA2XULRR",             "CA-125 pre-treatment 2x ULRR",   "Y",
  "CDISCPILOT01",     "RS", "01-701-1115", "RSSEQ",        6L, "CA2XULRR",             "CA-125 pre-treatment 2x ULRR",   "Y",
  "CDISCPILOT01",     "RS", "01-701-1115", "RSSEQ",        9L, "CA2XULRR",             "CA-125 pre-treatment 2x ULRR",   "Y",
  "CDISCPILOT01",     "RS", "01-701-1115", "RSSEQ",        3L,  "CA50RED",             ">50% reduction from baseline",   "Y",
  "CDISCPILOT01",     "RS", "01-701-1115", "RSSEQ",        6L,  "CA50RED",             ">50% reduction from baseline",   "Y",
  "CDISCPILOT01",     "RS", "01-701-1115", "RSSEQ",        9L,  "CA50RED",             ">50% reduction from baseline",   "Y",
  "CDISCPILOT01",     "RS", "01-701-1118", "RSSEQ",        3L, "CA125EFL",                "CA-125 response evaluable",   "Y",
  "CDISCPILOT01",     "RS", "01-701-1118", "RSSEQ",        6L, "CA125EFL",                "CA-125 response evaluable",   "Y",
  "CDISCPILOT01",     "RS", "01-701-1118", "RSSEQ",        9L, "CA125EFL",                "CA-125 response evaluable",   "Y",
  "CDISCPILOT01",     "RS", "01-701-1118", "RSSEQ",       12L, "CA125EFL",                "CA-125 response evaluable",   "Y",
  "CDISCPILOT01",     "RS", "01-701-1118", "RSSEQ",        3L, "CA2XULRR",             "CA-125 pre-treatment 2x ULRR",   "Y",
  "CDISCPILOT01",     "RS", "01-701-1118", "RSSEQ",        6L, "CA2XULRR",             "CA-125 pre-treatment 2x ULRR",   "Y",
  "CDISCPILOT01",     "RS", "01-701-1118", "RSSEQ",        9L, "CA2XULRR",             "CA-125 pre-treatment 2x ULRR",   "Y",
  "CDISCPILOT01",     "RS", "01-701-1118", "RSSEQ",       12L, "CA2XULRR",             "CA-125 pre-treatment 2x ULRR",   "Y",
  "CDISCPILOT01",     "RS", "01-701-1118", "RSSEQ",        3L,  "CA50RED",             ">50% reduction from baseline",   "Y",
  "CDISCPILOT01",     "RS", "01-701-1118", "RSSEQ",        9L,  "CA50RED",             ">50% reduction from baseline",   "Y",
  "CDISCPILOT01",     "RS", "01-701-1118", "RSSEQ",       12L,  "CA50RED",             ">50% reduction from baseline",   "Y"
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

attr(supprs_onco_ca125, "label") <- "Supplemental Qualifiers for RS_ONCO_CA125"

usethis::use_data(supprs_onco_ca125, overwrite = TRUE)
