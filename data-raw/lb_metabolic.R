# Dataset: lb_metabolic
# Description: Create LB test SDTM dataset for metabolic studies

# Load libraries ----
library(dplyr)
library(admiral)
library(purrr)

# Read input data ----
lb <- pharmaversesdtm::lb

# Subset participants (based on admiralmetabolic_dm) ----
lb_metabolic_1 <- lb %>%
  filter(USUBJID %in% c(
    "01-701-1015", "01-701-1023", "01-701-1028",
    "01-701-1033", "01-701-1034"
  ))

# Keep only metabolically relevant parameters ----
lb_metabolic_2 <- lb_metabolic_1 %>%
  filter(LBTESTCD %in% c("ALB", "ALP", "AST", "CHOL", "GLUC", "GGT"))

# Define new parameters ----
# Setup data
visits <- c(
  "SCREENING 1", "WEEK 2", "WEEK 6", "WEEK 8",
  "WEEK 12", "WEEK 16", "WEEK 20", "WEEK 24", "WEEK 26"
)
subject_ids <- c(
  "01-701-1015", "01-701-1023", "01-701-1028", "01-701-1033",
  "01-701-1034"
)
visit_subject_grid <- expand.grid(
  VISIT = visits,
  USUBJID = subject_ids,
  stringsAsFactors = FALSE
)

# Generate data
set.seed(123)
metabolic_data_1 <- map2(
  .x = visit_subject_grid$VISIT,
  .y = visit_subject_grid$USUBJID,
  .f = function(x, y) {
    tibble::tribble(
      ~VISIT, ~USUBJID, ~LBTESTCD, ~LBTEST, ~LBORNRLO, ~LBORNRHI, ~LBORRES, ~LBORRESU,
      x, y, "INSULIN", "Insulin", "2", "25", round(runif(1, min = 2, max = 45), 1), "mIU/L",
      x, y, "HBA1CHGB", "Hemoglobin A1C/Hemoglobin", "4.0", "5.7", round(runif(1, min = 4.0, max = 9.0), 1), "%",
      x, y, "TRIG", "Triglycerides", "0", "150", round(runif(1, min = 15, max = 250), 1), "mg/dL"
    )
  }
) %>%
  list_rbind() %>%
  mutate(LBORRES = as.character(LBORRES))

# Join and filter based on variables from lb
lb_metabolic_2_subset <- lb_metabolic_2 %>%
  select(
    USUBJID, VISIT, STUDYID, VISITDY, LBDTC,
    LBDY, LBBLFL, DOMAIN, VISITNUM
  ) %>%
  distinct()

metabolic_data_2 <- metabolic_data_1 %>%
  inner_join(lb_metabolic_2_subset,
    by = c("USUBJID", "VISIT")
  )

# Set additional variables
metabolic_data_3 <- metabolic_data_2 %>%
  mutate(
    LBCAT = "CHEMISTRY",
    LBSTRESN = dplyr::case_when(
      LBTESTCD == "INSULIN" ~ as.numeric(LBORRES) * 6,
      LBTESTCD == "TRIG" ~ as.numeric(LBORRES) * 0.01129,
      TRUE ~ as.numeric(LBORRES)
    ),
    LBSTRESC = as.character(LBSTRESN),
    LBSTRESU = case_when(
      LBTESTCD == "INSULIN" ~ "pmol/L",
      LBTESTCD == "TRIG" ~ "mmol/L",
      TRUE ~ LBORRESU
    ),
    LBSTNRLO = dplyr::case_when(
      LBTESTCD == "INSULIN" ~ as.numeric(LBORNRLO) * 6,
      LBTESTCD == "TRIG" ~ as.numeric(LBORNRLO) * 0.01129,
      TRUE ~ as.numeric(LBORNRLO)
    ),
    LBSTNRHI = dplyr::case_when(
      LBTESTCD == "INSULIN" ~ as.numeric(LBORNRHI) * 6,
      LBTESTCD == "TRIG" ~ as.numeric(LBORNRHI) * 0.01129,
      TRUE ~ as.numeric(LBORNRHI)
    ),
    LBNRIND = case_when(
      LBSTRESN < LBSTNRLO ~ "LOW",
      LBSTRESN > LBSTNRHI ~ "HIGH",
      TRUE ~ "NORMAL"
    )
  )

# Bind metabolic parameters with lb ----
lb_metabolic_3 <- lb_metabolic_2 %>%
  bind_rows(metabolic_data_3)

# Define analysis sequence number ----
lb_metabolic_4 <- lb_metabolic_3 %>%
  group_by(USUBJID) %>%
  arrange(VISIT, LBTESTCD) %>%
  mutate(LBSEQ = row_number()) %>%
  ungroup()

# Assign labels ----
walk(
  .x = colnames(lb_metabolic_4),
  .f = \(x) attr(lb_metabolic_4[[x]], "label") <<- attr(lb_metabolic_2[[x]], "label")
)
attr(lb_metabolic_4, "label") <- "Laboratory Test Results"

# Save dataset ----
lb_metabolic <- lb_metabolic_4
usethis::use_data(lb_metabolic, overwrite = TRUE)
