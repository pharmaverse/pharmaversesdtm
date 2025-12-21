# Dataset: MS
# Description: A synthetic SDTM MS domain with susceptibility results
# and linkage to MB domain (mb).

# Load libraries -----
library(dplyr)
library(tidyselect)
library(labelled)

# Load MB domain to get organism information -----
samples_table <- mb %>%
  filter(
    MBGRPID != ""
  ) %>%
  # Rename or change variables to MS domain names
  rename(
    MSGRPID = MBGRPID,
    MSLOC = MBLOC,
    MSSPEC = MBSPEC
  ) %>%
  mutate(
    DOMAIN = "MS"
  ) %>%
  mutate(
    ab_resist = ifelse(
      grepl(MBORRES, pattern = "RESISTANT$"),
      gsub(MBORRES, pattern = ".*, (.*) RESISTANT$", replacement = "\\1"),
      ""
    ),
    mo = gsub(MBORRES, pattern = "(.*), .*", replacement = "\\1")
  )

tested_antimicrobials <- unique(samples_table$ab_resist[samples_table$ab_resist != ""])
found_organisms <- unique(samples_table$mo)



## Use the AMR package to get clinical breakpoints -----
treatments_table <- AMR::clinical_breakpoints %>%
  # Select only relevant records and summarise them
  dplyr::filter(
    ab %in% AMR::as.ab(c(tested_antimicrobials)),
    mo %in% AMR::as.mo(c(found_organisms)),
    method %in% c("MIC", "DISK"),
    host == "human"
  ) %>%
  group_by(mo, ab, method, disk_dose) %>%
  summarise(
    S_breakpoint = signif(mean(breakpoint_S, na.rm = TRUE), 2),
    R_breakpoint = signif(mean(breakpoint_R, na.rm = TRUE), 2)
  ) %>%
  filter(!duplicated(paste0(mo, ab, method))) %>%
  as.data.frame() %>%
  # Derive MS domain variables associated with the susceptibility test
  mutate(
    MSTEST = toupper(AMR::ab_name(ab)),
    MSTESTCD = toupper(as.character(ab)),
    MSMETHOD = case_when(
      method == "MIC" ~ "E-TEST",
      method == "DISK" ~ "DISK DIFFUSION",
      TRUE ~ method
    ),
    organism = toupper(AMR::mo_name(mo))
  )

# Loop through each sample and each relevant treatment to create MS records -----
ms <- data.frame()
for (i in seq_len(nrow(samples_table))) {
  sample <- samples_table[i, ]
  treatments <- treatments_table %>%
    filter(organism == sample$mo) %>%
    mutate(is_resistant = MSTEST %in% sample$ab_resist)

  for (j in seq_len(nrow(treatments))) {
    trt <- treatments[j, ]

    ms_trt <- sample %>%
      mutate(
        MSTESTCD = trt$MSTESTCD,
        MSTEST = trt$MSTEST,
        MSMETHOD = trt$MSMETHOD,
        MSCAT = "SUSCEPTIBILITY",
        MSORRES = ifelse(trt$is_resistant, trt$R_breakpoint, trt$S_breakpoint),
        MSRESCAT = ifelse(trt$is_resistant, "RESISTANT", "SUSCEPTIBLE"),
        MSORRESU = ifelse(trt$MSMETHOD == "E-TEST", "ug/mL", "mm"),
        MSSTRESC = MSORRES,
        MSSTRESN = as.numeric(MSORRES),
        MSSTRESU = MSORRESU
      )
    ms <- bind_rows(ms, ms_trt)
  }
}

# Derive MSSEQ: for each subject, MSSEQ is 1 to n (number of samples for that subject)
ms <- ms %>%
  dplyr::group_by(USUBJID) %>%
  dplyr::mutate(MSSEQ = dplyr::row_number()) %>%
  dplyr::ungroup()


# Reorder columns according to CDISC SDTM MS standards
ms <- ms %>%
  select(
    STUDYID,
    DOMAIN,
    USUBJID,
    MSSEQ,
    MSGRPID,
    MSLOC,
    MSSPEC,
    MSTESTCD,
    MSTEST,
    MSCAT,
    MSORRES,
    MSORRESU,
    MSSTRESC,
    MSSTRESN,
    MSSTRESU,
    MSMETHOD,
    VISITNUM
  )

# Add variable labels
ms <- ms %>%
  set_variable_labels(
    STUDYID = "Study Identifier",
    DOMAIN = "Domain Abbreviation",
    USUBJID = "Unique Subject Identifier",
    MSSEQ = "Sequence Number",
    MSGRPID = "Group ID",
    MSLOC = "Location Used for the Measurement",
    MSSPEC = "Specimen Type",
    MSTESTCD = "Short Name of Assessment",
    MSTEST = "Name of Assessment",
    MSCAT = "Category of Assessment",
    MSORRES = "Result or Finding in Original Units",
    MSORRESU = "Original Units",
    MSSTRESC = "Result or Finding in Standard Format",
    MSSTRESN = "Numeric Result/Finding in Standard Units",
    MSSTRESU = "Standard Units",
    MSMETHOD = "Method of Test or Examination",
    VISITNUM = "Visit Number"
  )

# Save dataset
usethis::use_data(ms, overwrite = TRUE)
