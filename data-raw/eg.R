library(dplyr)

studyid <- "CDISCPILOT01"
domain <- "EG"
usubjids <- unique(vs$USUBJID)
egtestcds <- c("QT", "HR", "RR", "ECGINT")
visits <- c(
  "SCREENING 1",
  "SCREENING 2",
  "BASELINE",
  "AMBUL ECG PLACEMENT",
  "WEEK 2",
  "WEEK 4",
  "AMBUL ECG REMOVAL",
  "WEEK 6",
  "WEEK 8",
  "WEEK 12",
  "WEEK 16",
  "WEEK 20",
  "WEEK 24",
  "WEEK 26",
  "RETRIEVAL"
)

egtpts <- c(
  "AFTER LYING DOWN FOR 5 MINUTES",
  "AFTER STANDING FOR 1 MINUTE",
  "AFTER STANDING FOR 3 MINUTES"
)


visitnum_mapping <- c(
  "SCREENING 1" = 1,
  "SCREENING 2" = 2,
  "BASELINE" = 3,
  "AMBUL ECG PLACEMENT" = 3.5,
  "WEEK 2" = 4,
  "WEEK 4" = 5,
  "AMBUL ECG REMOVAL" = 6,
  "WEEK 6" = 7,
  "WEEK 8" = 8,
  "WEEK 12" = 9,
  "WEEK 16" = 10,
  "WEEK 20" = 11,
  "WEEK 24" = 12,
  "WEEK 26" = 13,
  "RETRIEVAL" = 201
)

visitdy_mapping <- c(
  "SCREENING 1" = -7,
  "SCREENING 2" = -1,
  "BASELINE" = 1,
  "AMBUL ECG PLACEMENT" = 13,
  "WEEK 2" = 14,
  "WEEK 4" = 28,
  "AMBUL ECG REMOVAL" = 30,
  "WEEK 6" = 42,
  "WEEK 8" = 56,
  "WEEK 12" = 84,
  "WEEK 16" = 112,
  "WEEK 20" = 140,
  "WEEK 24" = 168,
  "WEEK 26" = 182,
  "RETRIEVAL" = 168
)

egtptnum_mapping <- c(
  "AFTER LYING DOWN FOR 5 MINUTES" = 815,
  "AFTER STANDING FOR 1 MINUTE" = 816,
  "AFTER STANDING FOR 3 MINUTES" = 817
)

egeltm_mapping <- c(
  "AFTER LYING DOWN FOR 5 MINUTES" = "PT5M",
  "AFTER STANDING FOR 1 MINUTE" = "PT1M",
  "AFTER STANDING FOR 3 MINUTES" = "PT3M"
)

egtest_mapping <- c(
  "QT" = "QT Duration",
  "HR" = "Heart Rate",
  "RR" = "RR Duration",
  "ECGINT" = "ECG Interpretation"
)

egorresu_mapping <- c(
  "QT" = "mmHg",
  "HR" = "BEATS/MIN",
  "RR" = "mmHg",
  "ECGINT" = "LB"
)

egstresu_mapping <- c(
  "QT" = "msec",
  "HR" = "BEATS/MIN",
  "RR" = "msec",
  "ECGINT" = NA
)

egdtc = select(vs, USUBJID, VISIT, VSDTC) %>% distinct()


add_patient <- function(usubjid) {
  patient <-  expand.grid(
    USUBJID = usubjid,
    EGTESTCD = egtestcds,
    EGTPT = egtpts,
    VISIT = visits
  )  %>% arrange(EGTESTCD) %>%
    group_by(VISIT) %>%
    filter(!(EGTESTCD == "ECGINT" & duplicated(EGTESTCD))) %>%
    ungroup() %>% left_join(egdtc, by = c("USUBJID", "VISIT")) %>%
    mutate(
      STUDYID = studyid,
      USUBJID = as.character(USUBJID),
      DOMAIN = domain,
      EGSEQ = row_number(),
      EGTESTCD = as.character(EGTESTCD),
      EGTEST = egtest_mapping[EGTESTCD],
      EGORRESU = egorresu_mapping[EGTESTCD],
      EGBLFL = ifelse(VISIT == "BASELINE", "Y", ""),
      VISITNUM = visitnum_mapping[VISIT],
      VISITDY = visitdy_mapping[VISIT],
      EGTPTNUM = ifelse(EGTESTCD == "ECGINT", NA, egtptnum_mapping[EGTPT]),
      EGELTM = ifelse(EGTESTCD == "ECGINT", "", egeltm_mapping[EGTPT]),
      EGTPTREF = ifelse(
        EGTESTCD == "ECGINT",
        "",
        ifelse(EGELTM == "PT5M", "PATIENT SUPINE", "PATIENT STANDING")
      ),
      EGSTAT = "",
      EGSTRESU = egstresu_mapping[EGTESTCD],
      EGSTRESN = case_when(
        EGTESTCD == "RR" &
          EGELTM == "PT5M" ~ floor(rnorm(n(), 543.9985, 80)),
        EGTESTCD == "RR" &
          EGELTM == "PT3M" ~ floor(rnorm(n(), 536.0161, 80)),
        EGTESTCD == "RR" &
          EGELTM == "PT1M" ~ floor(rnorm(n(), 532.3233, 80)),
        EGTESTCD == "HR" &
          EGELTM == "PT5M" ~ floor(rnorm(n(), 70.04389, 10)),
        EGTESTCD == "HR" &
          EGELTM == "PT3M" ~ floor(rnorm(n(), 74.27798, 10)),
        EGTESTCD == "HR" &
          EGELTM == "PT1M" ~ floor(rnorm(n(), 74.77461, 10)),
        EGTESTCD == "QT" &
          EGELTM == "PT5M" ~ floor(rnorm(n(), 450.9781, 60)),
        EGTESTCD == "QT" &
          EGELTM == "PT3M" ~ floor(rnorm(n(), 457.7265, 60)),
        EGTESTCD == "QT" &
          EGELTM == "PT1M" ~ floor(rnorm(n(), 455.3394, 60))
      ),
      EGSTRESC = ifelse(EGTESTCD == "ECGINT", sample(c(
        "NORMAL", "ABNORMAL"
      ), 1), as.character(EGSTRESN)),
      EGORRES = EGSTRESC,
      EGLOC = "",
      EGDY = VISITDY,
      EGTPT = ifelse(EGTESTCD == "ECGINT", "", EGTPT),
      EGDTC = VSDTC
    ) %>%  filter(!is.na(EGDTC)) %>% filter(!(EGTESTCD == "ECGINT" & (VISIT == "AMBUL ECG PLACEMENT" | VISIT == "AMBUL ECG REMOVAL" | VISIT == "RETRIEVAL" | VISIT == "SCREENING 2")))
}

patients <- lapply(usubjids, add_patient) %>%
  bind_rows()  %>%
  select(
    STUDYID,
    DOMAIN,
    USUBJID,
    EGSEQ,
    EGTESTCD,
    EGTEST,
    EGORRES,
    EGORRESU,
    EGSTRESC,
    EGSTRESN,
    EGSTRESU,
    EGSTAT,
    EGLOC,
    EGBLFL,
    VISITNUM,
    VISIT,
    VISITDY,
    EGDTC,
    EGDY,
    EGTPT,
    EGTPTNUM,
    EGELTM,
    EGTPTREF
  )

View(patients)
# HR - 40 to 134
# RR - 280 to 868
# QT - 234 to 708
