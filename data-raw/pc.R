# Dataset: PC
# Description: Create PC test SDTM dataset

# Load libraries ----
library(haven)
library(plyr)
library(dplyr)
library(lubridate)
library(labelled)
library(admiral)
library(ggplot2)

# Create pc ----
ex <- pharmaversesdtm::ex
dm <- pharmaversesdtm::dm

## set seed to get same results each run ----
set.seed(999)

## Remove screen failures, they will not make it to drug infusion ----
dm1 <- dm %>%
  filter(ARMCD != "Scrnfail")

## use subjects in both datasets (ex,dm1) to create pc ----
dmex <- merge(dm1[, c(1, 3)], ex, by = c("STUDYID", "USUBJID"))

## Calculate only PC on Baseline, so filter only visit = BASELINE ----
dmex1 <- dmex %>%
  filter(VISIT == "BASELINE")

# We can check on figure 2 that the patch behaves like
# 2 phases (absorption up to the plateau, and elimination)
# Samples
t <- c(-0.5, 0.08, 0.5, 1, 1.5, 2, 4, 6, 8, 12, 16, 24, 36, 48)

# k0: rate of drug infusion units per time
# add Calculate some noise
nrows <- dim(dmex1)[1]
noise <- runif(n = nrows, min = -5, max = 5)
dmex1$k0 <- 100 + noise
# K is the elimination rate (absorption significantly larger)
# add Calculate some noise
noise <- runif(n = nrows, min = -0.05, max = 0.05)
dmex1$K <- 0.7 + noise
dmex1$V <- dmex1$EXDOSE / (dmex1$K)

## Start setting up dataset
PC <- NULL
for (t0 in t) {
  dmex1$t <- t0
  # dmex1$Conc = ifelse(dmex1$EXDOSE>0,(k0 * (1 - exp(-K*t0)))/(V*K),0)
  # Zero order
  # T = t0;
  # if (t0>10) {T = 10}
  # dmex1$Conc = ifelse(dmex1$EXDOSE>0,
  #                    (k0 * (exp(K*T) - 1) * exp(-K*t0))/(V*K),0)

  # First order
  if (t0 > 8) {
    dmex1$Conc <- ifelse(dmex1$EXDOSE > 0,
      dmex1$k0 / (dmex1$V * dmex1$K) * exp(-(dmex1$K * (t0 - 8)) / 2.303), 0
    )
  } else {
    dmex1$Conc <- ifelse(dmex1$EXDOSE > 0,
      (dmex1$k0 * (1 - exp(-dmex1$K * t0))) / (dmex1$V * dmex1$K), 0
    )
  }
  # Urine estimate
  dmex1$Urine <- -dmex1$K * t0 + dmex1$V / 2.5

  if (t0 == -0.5) { # If first timepoint

    PC <- dmex1
  } else { # Otherwise
    PC <- rbind(PC, dmex1)
  }
}

## Constant vars ----
PC$DOMAIN <- "PC"
PC$PCTESTCD <- "XAN"
PC$PCTEST <- "XANOMELINE"
PC$PCORRESU <- "ug/ml"
PC$PCSTRESU <- "ug/ml"
PC$PCNAM <- "Imaginary Labs"
PC$PCSPEC <- "PLASMA"
PC$PCLLOQ <- 0.01
PC$PCTPTNUM <- PC$t

## PCTPT ----
PC$PCTPT <- ifelse(PC$PCTPTNUM == -0.5, "Pre-dose",
  ifelse(PC$PCTPTNUM == 0.08, "5 Min Post-dose",
    ifelse(PC$PCTPTNUM == 0.5, "30 Min Post-dose", paste0(PC$PCTPTNUM, "h Post-dose"))
  )
)


PC_Urine <- PC %>%
  filter(PCTPTNUM %in% c(6.00, 12.00, 24.00, 48.00)) %>%
  mutate(
    PCSPEC = "URINE",
    PCTPT = case_when(
      PCTPT == "6h Post-dose" ~ "0-6h Post-dose",
      PCTPT == "12h Post-dose" ~ "6-12h Post-dose",
      PCTPT == "24h Post-dose" ~ "12-24h Post-dose",
      PCTPT == "48h Post-dose" ~ "24-48h Post-dose"
    ),
    PCTPTNUM = case_when(
      PCTPT == "0-6h Post-dose" ~ 3,
      PCTPT == "6-12h Post-dose" ~ 9,
      PCTPT == "12-24h Post-dose" ~ 18,
      PCTPT == "24-48h Post-dose" ~ 37
    ),
    Conc = Urine
  )

PC <- bind_rows(PC, PC_Urine)

## Concentration-related code ----
### Remove neg values due to pre-dose negative time ----
PC$Conc <- ifelse(PC$Conc < 0, 0, PC$Conc)

PC$PCSTRESN <- PC$Conc

## Usually as per SAP, only predose BLQ can be set to 0 ----
PC$PCSTRESN <- ifelse(PC$PCSTRESN < 0.01 & PC$t == -0.5, 0, PC$PCSTRESN)

# otherwise set it to missing
PC$PCSTRESN <- ifelse(PC$PCSTRESN < 0.01 & PC$t != -0.5, NA, PC$PCSTRESN)

## set blqs if NA ----
PC$Conc <- ifelse(PC$Conc < 0.01, "<BLQ", PC$Conc)
PC$PCORRES <- PC$Conc
PC$PCSTRESC <- PC$Conc

## PCDTC ----
PC$PCDTC <- format(as.Date(PC$EXSTDTC) + minutes(round(PC$t * 60)), "%Y-%m-%dT%H:%M:%S")
PC$PCDY <- ifelse(PC$t == -0.5, -1,
  ifelse(PC$t == 48, 3,
    ifelse(PC$t >= 24, 2, 1)
  )
)

## PCSEQ; ----
PC <- PC %>%
  group_by(STUDYID, USUBJID) %>%
  dplyr::mutate(PCSEQ = row_number())

## Select vars of interest ----
PC <- subset(PC, select = c(
  "STUDYID", "DOMAIN", "USUBJID", "PCSEQ", "PCTESTCD", "PCTEST",
  "PCORRES", "PCORRESU", "PCSTRESC", "PCSTRESN", "PCSTRESU",
  "PCNAM", "PCSPEC", "PCLLOQ", "VISIT", "VISITNUM", "PCDTC", "PCDY", "PCTPT", "PCTPTNUM"
))

## Ungroup and sort ----
pc <- PC %>%
  ungroup() %>%
  arrange(STUDYID, USUBJID, PCSEQ)

## add labels ----
pc <- pc %>%
  set_variable_labels(
    STUDYID = "Study Identifier",
    DOMAIN = "Domain Abbreviation",
    USUBJID = "Unique Subject Identifier",
    PCSEQ = "Sequence Number",
    PCTESTCD = "Pharmacokinetic Test Short Name",
    PCTEST = "Pharmacokinetic Test Name",
    PCORRES = "Result or Finding in Original Units",
    PCORRESU = "Original Units",
    PCSTRESC = "Character Result/Finding in Std Format",
    PCSTRESN = "Numeric Result/Finding in Standard Units",
    PCSTRESU = "Standard Units",
    PCNAM = "Vendor Name",
    PCSPEC = "Specimen Material Type",
    PCLLOQ = "Lower Limit of Quantitation",
    VISIT = "Visit Name",
    VISITNUM = "Visit Number",
    PCDTC = "Date/Time of Specimen Collection",
    PCDY = "Actual Study Day of Specimen Collection",
    PCTPT = "Planned Time Point Name",
    PCTPTNUM = "Planned Time Point Number"
  )

## Subset for plots
pc_plasma <- pc %>%
  filter(PCSPEC == "PLASMA")

pc_urine <- pc %>%
  filter(PCSPEC == "URINE")

## Test to look the overall figure ----
plot <- ggplot(pc_plasma, aes(x = PCTPTNUM, y = PCSTRESN, group = USUBJID)) +
  geom_line() +
  geom_point()

plot2 <- ggplot(pc_urine, aes(x = PCTPTNUM, y = PCSTRESN, group = USUBJID)) +
  geom_line() +
  geom_point()

# Label dataset ----
attr(pc, "label") <- "Pharmacokinetics Concentrations"

# Save dataset ----
usethis::use_data(pc, overwrite = TRUE)
