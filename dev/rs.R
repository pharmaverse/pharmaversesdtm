# RS
# Please note that tr.R should run first

library(dplyr)
library(tidyselect)
library(admiral)
library(metatools)

# Reading input data
data("admiral_tr")

# Converting blank to NA
tr <- convert_blanks_to_na(admiral_tr)

keyvar <- c(
  "STUDYID", "USUBJID", "TREVAL", "TREVALID",
  "TRDTC", "VISIT", "VISITNUM", "TRDY", "TRACPTFL"
)

# Deriving PCHG
sumdiam1 <- tr %>%
  filter(TRTESTCD == "SUMDIAM") %>%
  select(., c(all_of(keyvar), TRLNKGRP, TRSTRESN, TRSTAT, TRREASND))

sumb <- sumdiam1 %>%
  filter(VISITNUM == 3 & !is.na(TRSTRESN)) %>%
  select(., c(STUDYID, USUBJID, TREVAL, TREVALID, TRSTRESN)) %>%
  rename("BASE" = "TRSTRESN")

sumdiam <- left_join(sumdiam1, sumb,
  by = c("STUDYID", "USUBJID", "TREVAL", "TREVALID")
) %>%
  mutate("PCHG" = (TRSTRESN - BASE) * 100 / BASE)

# Dummy Data Nadir Not Used In PD Derivation (>5 mm and 20% increase from nadir)
trgresp <- sumdiam %>% mutate(
  "TRGRESP" = case_when(
    !is.na(PCHG) & PCHG <= -100 ~ "CR",
    !is.na(PCHG) & PCHG <= -30 ~ "PR",
    !is.na(PCHG) & PCHG > -30 & PCHG < 20 ~ "SD",
    !is.na(PCHG) & PCHG >= 20 ~ "PD",
    is.na(PCHG) & TRREASND == "SCAN NOT PERFORMED" ~ " ",
    is.na(PCHG) ~ "NE",
    TRUE ~ "CHECK"
  ),
  "TRTESTCD" = "TRGRESP"
)

# Select Non-target Response Per Visit
ntar <- tr %>%
  filter(TRTESTCD == "TUMSTATE" & TRGRPID == "NON-TARGET") %>%
  select(., c(all_of(keyvar), TRORRES, TRREASND)) %>%
  mutate("NTARN" = case_when(
    TRORRES == "ABSENT" ~ 1,
    TRORRES == "PRESENT" ~ 2,
    TRREASND == "NOT ASSESSABLE: Image obscured" ~ 3,
    TRORRES == "UNEQUIVOCAL" ~ 4,
    TRUE ~ NA_real_
  )) %>%
  rename("NTAR" = "TRORRES") %>%
  group_by(STUDYID, USUBJID, TREVAL, TREVALID, VISIT, VISITNUM) %>%
  arrange(NTARN) %>%
  do(tail(., 1)) %>%
  ungroup()

ntrgresp <- ntar %>% mutate(
  "NTRGRESP" = case_when(
    NTAR == "UNEQUIVOCAL" ~ "PD",
    NTAR == "ABSENT" ~ "CR",
    NTAR == "PRESENT" ~ "NON-CR/NON-PD",
    is.na(NTAR) & TRREASND == "NOT ASSESSABLE: Image obscured" ~ "NE"
  ),
  "TRTESTCD" = "NTRGRESP"
)

# Select New Lesions Per Visit
nle <- tr %>%
  filter(TRTESTCD == "TUMSTATE" & TRGRPID == "NEW") %>%
  select(., c(all_of(keyvar), TRORRES)) %>%
  mutate("NLRN" = case_when(
    is.na(TRORRES) ~ 1,
    TRORRES == "EQUIVOCAL" ~ 2,
    TRORRES == "UNEQUIVOCAL" ~ 3
  )) %>%
  rename("NEWL" = "TRORRES") %>%
  group_by(STUDYID, USUBJID, TREVAL, TREVALID, VISIT, VISITNUM) %>%
  arrange(NLRN) %>%
  do(tail(., 1)) %>%
  ungroup()

newlprog <- nle %>% mutate(
  "NEWLPROG" = NEWL,
  "TRTESTCD" = "NEWLPROG"
)

# Merging All Visit Level Data
rs1 <- full_join(trgresp, ntrgresp, by = c(all_of(keyvar)))
rs2 <- full_join(rs1, newlprog, by = c(all_of(keyvar)))

# Deriving Overall Response
ovrlresp <- rs2 %>%
  filter(VISITNUM > 3) %>%
  mutate(
    "OVRLRESP" = case_when(
      TRGRESP == "CR" & NTRGRESP == "CR" &
        (is.na(NEWLPROG) | NEWLPROG == "EQUIVOCAL") ~ "CR",
      TRGRESP %in% c("CR", "PR") &
        NTRGRESP %in% c("NE", "NON-CR/NON-PD", "CR") &
        (is.na(NEWLPROG) | NEWLPROG == "EQUIVOCAL") ~ "PR",
      TRGRESP == "SD" &
        NTRGRESP %in% c("NE", "NON-CR/NON-PD", "CR") &
        (is.na(NEWLPROG) | NEWLPROG == "EQUIVOCAL") ~ "SD",
      TRGRESP == "NE" &
        NTRGRESP %in% c("NE", "NON-CR/NON-PD", "CR") &
        (is.na(NEWLPROG) | NEWLPROG == "EQUIVOCAL") ~ "NE",
      TRGRESP == "PD" |
        NTRGRESP == "PD" |
        NEWLPROG == "UNEQUIVOCAL" ~ "PD",
      TRUE ~ "CHECK"
    ),
    "TRTESTCD" = "OVRLRESP",
    "TRREASND" = case_when(
      !is.na(TRREASND.x) & !is.na(TRREASND.y) &
        TRREASND.x != TRREASND.y &
        OVRLRESP == "NE" ~ trimws(paste(TRREASND.x, TRREASND.y, sep = ", ")),
      !is.na(TRREASND.x) &
        !is.na(TRREASND.y) &
        TRREASND.x == TRREASND.y & OVRLRESP == "NE" ~ TRREASND.x,
      !is.na(TRREASND.x) &
        OVRLRESP == "NE" ~ TRREASND.x,
      !is.na(TRREASND.y) & OVRLRESP == "NE" ~ TRREASND.y
    )
  )

# Setting All Data And Adding Other Variables
rs5 <- bind_rows(
  select(trgresp, c(all_of(keyvar), "TRREASND", "TRTESTCD", "TRGRESP"))
  %>% rename("RSORRES" = "TRGRESP"),
  select(ntrgresp, c(all_of(keyvar), "TRREASND", "TRTESTCD", "NTRGRESP"))
  %>% rename("RSORRES" = "NTRGRESP"),
  select(newlprog, c(all_of(keyvar), "TRTESTCD", "NEWLPROG"))
  %>% rename("RSORRES" = "NEWLPROG"),
  select(
    ovrlresp,
    c(all_of(keyvar), "TRREASND", "TRTESTCD", "OVRLRESP", "TRLNKGRP")
  )
  %>% rename("RSORRES" = "OVRLRESP")
) %>%
  filter(VISITNUM > 3) %>%
  rename(
    "RSDTC" = "TRDTC",
    "RSDY" = "TRDY",
    "RSREASND" = "TRREASND",
    "RSTESTCD" = "TRTESTCD",
    "RSEVAL" = "TREVAL",
    "RSEVALID" = "TREVALID",
    "RSACPTFL" = "TRACPTFL",
    "RSLNKGRP" = "TRLNKGRP"
  ) %>%
  mutate(
    "DOMAIN" = "RS",
    "RSCAT" = "RECIST 1.1",
    "RSSTRESC" = RSORRES,
    "RSTEST" = case_when(
      RSTESTCD == "TRGRESP" ~ "Target Response",
      RSTESTCD == "NTRGRESP" ~ "Non-target Response",
      RSTESTCD == "OVRLRESP" ~ "Overall Response",
      RSTESTCD == "NEWLPROG" ~ "New Lesion Progression"
    ),
    "RSSTAT" = case_when(!is.na(RSREASND) ~ "NOT DONE")
  )

# RSSEQ
rs6 <- rs5 %>%
  arrange(
    STUDYID, USUBJID, VISITNUM, RSDTC,
    RSEVAL, RSEVALID, RSLNKGRP, RSTESTCD
  ) %>%
  group_by(STUDYID, USUBJID) %>%
  mutate(RSSEQ = row_number()) %>%
  ungroup()

# Creating RS
rs <- select(rs6, c(
  STUDYID, DOMAIN, USUBJID, RSSEQ, RSLNKGRP, RSTESTCD,
  RSTEST, RSCAT, RSORRES, RSSTRESC,
  RSSTAT, RSREASND, RSEVAL, RSEVALID, RSACPTFL,
  VISITNUM, VISIT, RSDTC, RSDY
))

rs <- rs %>% add_labels(
  STUDYID = "Study Identifier",
  DOMAIN = "Domain Abbreviation",
  USUBJID = "Unique Subject Identifier",
  RSSEQ = "Sequence Number",
  RSLNKGRP = "Link Group",
  RSTESTCD = "Response Assessment Short Name",
  RSTEST = "Response Assessment Name",
  RSCAT = "Category for Response Assessment",
  RSORRES = "Response Assessment Original Result",
  RSSTRESC = "Response Assessment Result in Std Format",
  RSSTAT = "Completion Status",
  RSREASND = "Reason Response Assessment Not Performed",
  RSEVAL = "Evaluator",
  RSEVALID = "Evaluator Identifier",
  RSACPTFL = "Accepted Record Flag",
  VISITNUM = "Visit Number",
  VISIT = "Visit Name",
  RSDTC = "Date/Time of Response Assessment",
  RSDY = "Study Day of Response Assessment"
)

attr(rs, "label") <- "Disease Response"

admiral_rs <- rs
save(admiral_rs, file = "data/admiral_rs.rda", compress = "bzip2")
