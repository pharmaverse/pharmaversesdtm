# Packages: ---------------------------------------------------------------
library(dplyr)

# Tribble data: -----------------------------------------------------------

rs_onco_imwg <- tibble::tribble(
       ~USUBJID, ~RSSEQ, ~RSLNKGRP,  ~RSTESTCD,            ~RSTEST, ~RSORRES, ~RSSTRESC, ~RSSTAT, ~RSREASND,        ~RSEVAL, ~VISITNUM,            ~VISIT,       ~RSDTC, ~RSDY,
  "01-701-1015",     7L,      "A2", "OVRLRESP", "Overall Response",     "PD",      "PD",      NA,        NA, "INVESTIGATOR",         7,          "WEEK 6", "2014-02-12",   42L,
  "01-701-1028",     7L,      "A2", "OVRLRESP", "Overall Response",    "sCR",     "sCR",      NA,        NA, "INVESTIGATOR",         7,          "WEEK 6",    "2013-08",    NA,
  "01-701-1028",    16L,      "A3", "OVRLRESP", "Overall Response",    "sCR",     "sCR",      NA,        NA, "INVESTIGATOR",         9,         "WEEK 12", "2013-10-09",   84L,
  "01-701-1028",    21L,      "A4", "OVRLRESP", "Overall Response",     "CR",      "CR",      NA,        NA, "INVESTIGATOR",        10,         "WEEK 18", "2013-11-20",  126L,
  "01-701-1034",     7L,      "A2", "OVRLRESP", "Overall Response",     "CR",      "CR",      NA,        NA, "INVESTIGATOR",         7,          "WEEK 6", "2014-08-11",   42L,
  "01-701-1034",    16L,      "A3", "OVRLRESP", "Overall Response",     "CR",      "CR",      NA,        NA, "INVESTIGATOR",         9,         "WEEK 12", "2014-09-25",   84L,
  "01-701-1034",    26L,        NA, "OVRLRESP", "Overall Response",    "sCR",     "sCR",      NA,        NA, "INVESTIGATOR",        10,         "WEEK 18", "2014-11-04",  126L,
  "01-701-1097",     7L,      "A2", "OVRLRESP", "Overall Response",     "PD",      "PD",      NA,        NA, "INVESTIGATOR",         7,          "WEEK 6", "2014-02-11",   42L,
  "01-701-1115",     7L,      "A2", "OVRLRESP", "Overall Response",     "PD",      "PD",      NA,        NA, "INVESTIGATOR",         7,          "WEEK 6", "2013-01-10",   42L,
  "01-701-1118",     7L,      "A2", "OVRLRESP", "Overall Response",    "sCR",     "sCR",      NA,        NA, "INVESTIGATOR",         7,          "WEEK 6", "2014-04-23",   42L,
  "01-701-1118",    16L,      "A3", "OVRLRESP", "Overall Response",   "VPGR",    "VPGR",      NA,        NA, "INVESTIGATOR",         9,         "WEEK 12", "2014-06-05",   84L,
  "01-701-1118",    26L,        NA, "OVRLRESP", "Overall Response",     "CR",      "CR",      NA,        NA, "INVESTIGATOR",      10.1,         "WEEK 18", "2014-07-16",  126L,
  "01-701-1118",    34L,      "A4", "OVRLRESP", "Overall Response",   "VPGR",    "VPGR",      NA,        NA, "INVESTIGATOR",        12,         "WEEK 24", "2014-08-27",  168L,
  "01-701-1130",     7L,      "A2", "OVRLRESP", "Overall Response",   "VPGR",    "VPGR",      NA,        NA, "INVESTIGATOR",         7,          "WEEK 6", "2014-03-29",   42L,
  "01-701-1130",    16L,      "A3", "OVRLRESP", "Overall Response",    "sCR",     "sCR",      NA,        NA, "INVESTIGATOR",         9,         "WEEK 12", "2014-05-16",   84L,
  "01-701-1130",    26L,        NA, "OVRLRESP", "Overall Response",   "VPGR",    "VPGR",      NA,        NA, "INVESTIGATOR",        10,         "WEEK 18", "2014-06-21",  126L,
  "01-701-1130",    34L,      "A4", "OVRLRESP", "Overall Response",   "VPGR",    "VPGR",      NA,        NA, "INVESTIGATOR",        12,         "WEEK 24", "2014-08-02",  168L,
  "01-701-1133",     7L,      "A2", "OVRLRESP", "Overall Response",    "sCR",     "sCR",      NA,        NA, "INVESTIGATOR",         7,          "WEEK 6", "2012-12-11",   42L,
  "01-701-1133",    16L,      "A3", "OVRLRESP", "Overall Response",     "PR",      "PR",      NA,        NA, "INVESTIGATOR",         9,         "WEEK 12", "2013-01-22",   84L,
  "01-701-1133",    26L,        NA, "OVRLRESP", "Overall Response",     "CR",      "CR",      NA,        NA, "INVESTIGATOR",      10.1,         "WEEK 18", "2013-03-04",  126L,
  "01-701-1133",    34L,      "A4", "OVRLRESP", "Overall Response",     "PR",      "PR",      NA,        NA, "INVESTIGATOR",        12,         "WEEK 24", "2013-04-18",  168L,
  "01-701-1146",     7L,      "A2", "OVRLRESP", "Overall Response",     "PD",      "PD",      NA,        NA, "INVESTIGATOR",         7,          "WEEK 6", "2013-06-30",   42L,
  "01-701-1148",     7L,      "A2", "OVRLRESP", "Overall Response",   "VPGR",    "VPGR",      NA,        NA, "INVESTIGATOR",         7,          "WEEK 6", "2013-10-03",   42L,
  "01-701-1148",    16L,      "A3", "OVRLRESP", "Overall Response",     "PR",      "PR",      NA,        NA, "INVESTIGATOR",         9,         "WEEK 12", "2013-11-17",   84L,
  "01-701-1148",    26L,        NA, "OVRLRESP", "Overall Response",     "PR",      "PR",      NA,        NA, "INVESTIGATOR",      10.1,         "WEEK 18", "2013-12-27",  126L,
  "01-701-1148",    36L,      "A4", "OVRLRESP", "Overall Response",     "PR",      "PR",      NA,        NA, "INVESTIGATOR",        12,         "WEEK 24", "2014-02-08",  168L,
  "01-701-1153",     7L,      "A2", "OVRLRESP", "Overall Response",    "sCR",     "sCR",      NA,        NA, "INVESTIGATOR",         7,          "WEEK 6", "2013-11-04",   42L,
  "01-701-1153",    16L,      "A3", "OVRLRESP", "Overall Response",     "MR",      "MR",      NA,        NA, "INVESTIGATOR",         9,         "WEEK 12", "2013-12-16",   84L,
  "01-701-1153",    26L,        NA, "OVRLRESP", "Overall Response",    "sCR",     "sCR",      NA,        NA, "INVESTIGATOR",       9.2, "UNSCHEDULED 9.2", "2014-01-08",    NA,
  "01-701-1153",    35L,        NA, "OVRLRESP", "Overall Response",     "SD",      "SD",      NA,        NA, "INVESTIGATOR",       9.3, "UNSCHEDULED 9.3", "2013-12-30",    NA,
  "01-701-1153",    43L,      "A4", "OVRLRESP", "Overall Response",     "MR",      "MR",      NA,        NA, "INVESTIGATOR",        12,         "WEEK 24", "2014-03-11",  168L,
  "01-701-1203",     7L,      "A2", "OVRLRESP", "Overall Response",     "CR",      "CR",      NA,        NA, "INVESTIGATOR",         7,          "WEEK 6", "2013-03-16",   42L,
  "01-701-1203",    16L,      "A3", "OVRLRESP", "Overall Response",     "MR",      "MR",      NA,        NA, "INVESTIGATOR",         9,         "WEEK 12", "2013-05-09",   84L,
  "01-701-1203",    26L,        NA, "OVRLRESP", "Overall Response",     "CR",      "CR",      NA,        NA, "INVESTIGATOR",      10.1,         "WEEK 18", "2013-06-08",  126L,
  "01-701-1203",    34L,      "A4", "OVRLRESP", "Overall Response",     "SD",      "SD",      NA,        NA, "INVESTIGATOR",        12,         "WEEK 24", "2013-07-22",  168L,
  "01-701-1211",     7L,      "A2", "OVRLRESP", "Overall Response",   "VGPR",    "VGPR",      NA,        NA, "INVESTIGATOR",         7,          "WEEK 6", "2012-12-25",   42L,
  "01-701-1211",    16L,      "A3", "OVRLRESP", "Overall Response",     "MR",      "MR",      NA,        NA, "INVESTIGATOR",         9,         "WEEK 12", "2013-01-14",   84L,
  "01-701-1239",     7L,      "A2", "OVRLRESP", "Overall Response",     "PR",      "PR",      NA,        NA, "INVESTIGATOR",         7,          "WEEK 6", "2014-02-19",   42L,
  "01-701-1239",    16L,      "A3", "OVRLRESP", "Overall Response",     "MR",      "MR",      NA,        NA, "INVESTIGATOR",         9,         "WEEK 12", "2014-04-02",   84L,
  "01-701-1239",    26L,        NA, "OVRLRESP", "Overall Response",     "MR",      "MR",      NA,        NA, "INVESTIGATOR",      10.1,         "WEEK 18", "2014-05-14",  126L,
  "01-701-1239",    34L,      "A4", "OVRLRESP", "Overall Response",   "VGPR",    "VGPR",      NA,        NA, "INVESTIGATOR",        12,         "WEEK 24", "2014-06-27",  168L,
  "01-701-1275",     7L,      "A2", "OVRLRESP", "Overall Response",     "MR",      "MR",      NA,        NA, "INVESTIGATOR",         7,          "WEEK 6", "2014-03-22",   42L,
  "01-701-1275",    16L,      "A3", "OVRLRESP", "Overall Response",     "PR",      "PR",      NA,        NA, "INVESTIGATOR",         9,         "WEEK 12", "2014-05-03",   84L,
  "01-701-1287",     7L,      "A2", "OVRLRESP", "Overall Response",     "PR",      "PR",      NA,        NA, "INVESTIGATOR",         7,          "WEEK 6", "2014-03-06",   42L,
  "01-701-1287",    16L,      "A3", "OVRLRESP", "Overall Response",     "PR",      "PR",      NA,        NA, "INVESTIGATOR",         9,         "WEEK 12", "2014-04-17",   84L,
  "01-701-1287",    26L,        NA, "OVRLRESP", "Overall Response",     "PD",      "PD",      NA,        NA, "INVESTIGATOR",      10.1,         "WEEK 18", "2014-05-29",  126L,
  "01-701-1287",    36L,      "A4", "OVRLRESP", "Overall Response",     "PD",      "PD",      NA,        NA, "INVESTIGATOR",        12,         "WEEK 24", "2014-07-12",  168L,
  "01-701-1294",     7L,      "A2", "OVRLRESP", "Overall Response",     "PR",      "PR",      NA,        NA, "INVESTIGATOR",         7,          "WEEK 6", "2013-05-08",   42L,
  "01-701-1294",    16L,      "A3", "OVRLRESP", "Overall Response",     "SD",      "SD",      NA,        NA, "INVESTIGATOR",         9,         "WEEK 12", "2013-06-14",   84L,
  "01-701-1302",     7L,      "A2", "OVRLRESP", "Overall Response",     "PD",      "PD",      NA,        NA, "INVESTIGATOR",         7,          "WEEK 6", "2013-10-08",   42L,
  "01-701-1302",    16L,      "A3", "OVRLRESP", "Overall Response",     "CR",      "CR",      NA,        NA, "INVESTIGATOR",         9,         "WEEK 12", "2013-11-05",   84L,
  "01-701-1345",     7L,      "A2", "OVRLRESP", "Overall Response",     "MR",      "MR",      NA,        NA, "INVESTIGATOR",         7,          "WEEK 6", "2013-11-19",   42L,
  "01-701-1345",    16L,      "A3", "OVRLRESP", "Overall Response",     "MR",      "MR",      NA,        NA, "INVESTIGATOR",         9,         "WEEK 12", "2013-12-31",   84L,
  "01-701-1345",    26L,        NA, "OVRLRESP", "Overall Response",     "PD",      "PD",      NA,        NA, "INVESTIGATOR",      10.1,         "WEEK 18", "2014-02-11",  126L,
  "01-701-1345",    34L,      "A4", "OVRLRESP", "Overall Response",     "PR",      "PR",      NA,        NA, "INVESTIGATOR",        12,         "WEEK 24", "2014-03-18",  168L,
  "01-701-1363",     7L,      "A2", "OVRLRESP", "Overall Response",     "NE",      "NE",      NA,        NA, "INVESTIGATOR",         7,          "WEEK 6", "2013-07-10",   42L,
  "01-701-1363",    16L,      "A3", "OVRLRESP", "Overall Response",     "CR",      "CR",      NA,        NA, "INVESTIGATOR",         9,         "WEEK 12", "2013-08-21",   84L,
  "01-701-1415",     7L,      "A2", "OVRLRESP", "Overall Response",     "PR",      "PR",      NA,        NA, "INVESTIGATOR",         7,          "WEEK 6", "2013-11-04",   42L,
  "01-701-1415",    16L,      "A3", "OVRLRESP", "Overall Response",     "NE",      "NE",      NA,        NA, "INVESTIGATOR",         9,         "WEEK 12", "2013-12-21",   84L,
  "01-701-1415",    26L,        NA, "OVRLRESP", "Overall Response",     "MR",      "MR",      NA,        NA, "INVESTIGATOR",      10.1,         "WEEK 18", "2014-01-27",  126L,
  "01-701-1415",    34L,      "A4", "OVRLRESP", "Overall Response",     "MR",      "MR",      NA,        NA, "INVESTIGATOR",        12,         "WEEK 24", "2014-03-10",  168L,
  "01-702-1082",     7L,      "A2", "OVRLRESP", "Overall Response",     "PD",      "PD",      NA,        NA, "INVESTIGATOR",         7,          "WEEK 6", "2013-09-06",   42L,
  "01-702-1082",    16L,      "A3", "OVRLRESP", "Overall Response",     "CR",      "CR",      NA,        NA, "INVESTIGATOR",         9,         "WEEK 12", "2013-11-17",   84L,
  "01-703-1076",     7L,      "A2", "OVRLRESP", "Overall Response",     "NE",      "NE",      NA,        NA, "INVESTIGATOR",         7,          "WEEK 6", "2013-12-04",   42L
  ) %>%
  mutate(
    STUDYID = "CDISCPILOT01",
    DOMAIN = "RS",
    RSCAT = "IMWG",
    RSEVAL = "INVESTIGATOR"
  ) %>%
  relocate(
    STUDYID, DOMAIN, USUBJID, RSSEQ, RSLNKGRP, RSTESTCD, RSTEST, RSCAT, RSORRES,
    RSSTRESC, RSSTAT, RSREASND, RSEVAL, VISITNUM, VISIT, RSDTC,
    RSDY
  )


usethis::use_data(rs_onco_imwg, overwrite = TRUE)


supprs_onco_imwg <- tibble::tribble(
       ~USUBJID, ~IDVARVAL,     ~QNAM,                            ~QLABEL,        ~QVAL,
  "01-701-1015",        7L,   "PDOFL",       "Progressive Disease: Other",          "Y",
  "01-701-1015",        7L, "DTHPDFL", "Death Due to Progressive Disease",          "Y",
  "01-701-1097",        7L,   "PDOFL",       "Progressive Disease: Other",          "Y",
  "01-701-1097",        7L,  "NACTDT",     "New Anti-Cancer Therapy Date", "2014-02-10",
  "01-701-1115",        7L,   "PDIFL",     "Progressive Disease: Imaging",          "Y",
  "01-701-1146",        7L,   "PDOFL",       "Progressive Disease: Other",          "Y",
  "01-701-1148",        7L,  "NACTDT",     "New Anti-Cancer Therapy Date", "2014-02-07",
  "01-701-1148",       16L,  "NACTDT",     "New Anti-Cancer Therapy Date", "2014-02-07",
  "01-701-1148",       26L,  "NACTDT",     "New Anti-Cancer Therapy Date", "2014-02-07",
  "01-701-1148",       36L,  "NACTDT",     "New Anti-Cancer Therapy Date", "2014-02-07",
  "01-701-1302",        7L,   "PDIFL",     "Progressive Disease: Imaging",          "Y",
  "01-701-1345",       26L,   "PDOFL",       "Progressive Disease: Other",          "Y",
  "01-701-1287",        7L,   "PDOFL",       "Progressive Disease: Other",          "Y",
  "01-701-1287",        7L,  "NACTDT",     "New Anti-Cancer Therapy Date", "2014-05-30",
  "01-701-1287",       16L,  "NACTDT",     "New Anti-Cancer Therapy Date", "2014-05-30",
  "01-701-1287",       26L,  "NACTDT",     "New Anti-Cancer Therapy Date", "2014-05-30",
  "01-701-1287",       36L,  "NACTDT",     "New Anti-Cancer Therapy Date", "2014-05-30",
  "01-701-1287",       36L,   "PDOFL",       "Progressive Disease: Other",          "Y",
  "01-702-1082",        7L,   "PDOFL",       "Progressive Disease: Other",          "Y"
  )%>%
  mutate(
    STUDYID = "CDISCPILOT01",
    RDOMAIN = "RS",
    IDVAR = "RSSEQ",
    QORIG = "CRF",
    IDVARVAL=as.character(IDVARVAL)
  ) %>%
  relocate(
    STUDYID, RDOMAIN, USUBJID, IDVAR, IDVARVAL, QNAM, QLABEL, QVAL, QORIG
  )

usethis::use_data(supprs_onco_imwg, overwrite = TRUE)
