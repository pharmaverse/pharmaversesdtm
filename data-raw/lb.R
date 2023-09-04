# Dataset: lb
# Description: Standard LB dataset from CDISC pilot study with added percentage differential lab test rows

# Load libraries -----
library(dplyr)
library(haven)
library(admiral)

# Create LB ----
sdtm_path <- "https://github.com/cdisc-org/sdtm-adam-pilot-project/blob/master/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm/" # nolint
raw_lb <- read_xpt(paste0(sdtm_path, "lb", ".xpt?raw=true"))
lb_orig <- raw_lb %>% convert_blanks_to_na()

## Subset on differential lab tests ----
lb_diff_abs <- lb_orig %>%
  filter(LBTESTCD %in% c("BASO", "EOS", "LYM", "MONO", "NEUT"))

## Subset on a few patients and visits ----
subject_sub <- lb_diff_abs %>%
  distinct(USUBJID) %>%
  head()

lb_sub <- lb_diff_abs %>%
  filter(
    USUBJID %in% subject_sub$USUBJID,
    VISIT %in% c("SCREENING 1", "WEEK 2")
  )

## Create dummy differential lab tests ----
set.seed(1)
rand_diff <- sample(seq(0, 0.5, by = 0.05), replace = T, nrow(lb_sub))

lb_diff <- lb_sub %>%
  mutate(
    LBTESTCD = case_when(
      LBTESTCD == "BASO" ~ "BASOLE",
      LBTESTCD == "EOS" ~ "EOSLE",
      LBTESTCD == "LYM" ~ "LYMLE",
      LBTESTCD == "MONO" ~ "MONOLE",
      LBTESTCD == "NEUT" ~ "NEUTLE"
    ),
    LBTEST = case_when(
      LBTESTCD == "BASOLE" ~ "Basophils/Leukocytes",
      LBTESTCD == "EOSLE" ~ "Eosinophils/Leukocytes",
      LBTESTCD == "LYMLE" ~ "Lymphocytes/Leukocytes",
      LBTESTCD == "MONOLE" ~ "Monocytes/Leukocytes",
      LBTESTCD == "NEUTLE" ~ "Neutrophils/Leukocytes"
    ),
    LBSTNRLO = case_when(
      LBTESTCD == "BASOLE" ~ 0.00,
      LBTESTCD == "EOSLE" ~ 0.00,
      LBTESTCD == "LYMLE" ~ 0.22,
      LBTESTCD == "MONOLE" ~ 0.00,
      LBTESTCD == "NEUTLE" ~ 0.40
    ),
    LBSTNRHI = case_when(
      LBTESTCD == "BASOLE" ~ 0.02,
      LBTESTCD == "EOSLE" ~ 0.04,
      LBTESTCD == "LYMLE" ~ 0.44,
      LBTESTCD == "MONOLE" ~ 0.07,
      LBTESTCD == "NEUTLE" ~ 0.70
    ),
    LBSTRESN = rand_diff,
    LBSTRESU = "FRACTION",
    LBSTRESC = as.character(LBSTRESN),
    LBORRES = LBSTRESC,
    LBORRESU = LBSTRESU,
    LBORNRLO = LBSTNRLO,
    LBORNRHI = LBSTNRHI,
    LBNRIND = case_when(
      LBSTRESN < LBSTNRLO ~ "LOW",
      LBSTRESN > LBSTNRHI ~ "HIGH",
      TRUE ~ "NORMAL"
    )
  )


## Replace original rows with new records ----
lb <- lb_orig %>%
  anti_join(lb_diff, by = c("USUBJID", "VISIT", "LBSEQ")) %>%
  rbind(lb_diff)

# Label dataset ----
attr(lb, "label") <- "Laboratory Test Results"

# Save dataset ----
usethis::use_data(lb, overwrite = TRUE)
