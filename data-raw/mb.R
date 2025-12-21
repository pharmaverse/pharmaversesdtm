# Dataset: MB
# Description: A synthetic SDTM MB domain representing microbiology findings
# and linkage to MS domain (ms).
# Dataset: MB (from scratch)
# Description: Synthetic SDTM MB domain, not derived from MS, but fully controlled by user-defined mapping.

library(dplyr)
library(labelled)

# For each subject, define the samples collected and the organisms identified
samples_identified_per_patient = list(
  # Case 1: organism with no infection and no resistance
  data.frame(
    subject = 1,
    organism = rep("STAPHYLOCOCCUS AUREUS", 2),
    ms_finding = rep("", 2),
    specimen = rep("SKIN TISSUE", 2),
    spec_location = rep("SKIN OF THE AXILLA", 2),
    collection_date = c("2025-06-16T08:00", "2025-06-23T08:00"),
    infection = c(FALSE, FALSE)
  ),
  # Case 2: organism with no infection initially, then infection later
  data.frame(
    subject = 2,
    organism = rep("ENTEROCOCCUS FAECALIS", 2),
    ms_finding = rep("AMOXICILLIN RESISTANT", 2),
    specimen = c("URINE", "URINE"),
    spec_location = c("URINARY SYSTEM", "URINARY SYSTEM"),
    growth_date = c("2025-07-16T08:00", "2025-07-23T08:00"),
    infection = c(FALSE, TRUE)
  ),
  # Case 3: organism with initial VAN resistant and then MDR (multi-drug resistant)
  data.frame(
    subject = 3,
    organism = rep("STAPHYLOCOCCUS AUREUS", 2),
    ms_finding = c("VANCOMYCIN RESISTANT", "MDR"),
    specimen = c("SKIN TISSUE", "SKIN TISSUE"),
    spec_location = c("SKIN OF THE AXILLA", "SKIN OF THE AXILLA"),
    growth_date = c("2025-08-12T08:00", "2025-08-30T08:00"),
    infection = c(TRUE, TRUE)
  ),
  # Case 4: Multiple organisms identified in same specimen
  data.frame(
    subject = 5,
    organism = c("STAPHYLOCOCCUS AUREUS", "STREPTOCOCCUS PNEUMONIAE"),
    ms_finding = c("", ""),
    specimen = c("SPUTUM", "SPUTUM"),
    spec_location = c("LUNG", "LUNG"),
    growth_date = c("2025-10-05T08:00", "2025-10-05T08:00"),
    infection = c(TRUE, TRUE)
  ),
  # Case 5: Nothing grown from specimen
  data.frame(
    subject = 6,
    organism = "NO GROWTH",
    ms_finding = "",
    specimen = "SPUTUM",
    spec_location = "LUNG",
    growth_date = "2025-11-01T08:00",
    infection = FALSE
  )
)

# Merge all patients data and derive relevant variables
mb <- bind_rows(samples_identified_per_patient) %>%
  # Get the defined variables with the proper names
  mutate(
    SUBJID = sprintf("%02d", subject),
    MBSPEC = specimen,
    MBLOC = spec_location,
    MBDTC = growth_date,
    MBORRES = paste0(organism, ifelse(ms_finding != "", paste0(", ", ms_finding), "")),
    MBRESCAT = case_when(
      MBORRES == "NO GROWTH" ~ "",
      infection ~ "INFECTING",
      TRUE ~ "COLONIZER"
    )
  ) %>%
  # Define fixed variables
  mutate(
    STUDYID = "DEF",
    DOMAIN = "MB",
    MBMETHOD = "CULTURE PLATE",
    MBTESTCD = "ORGANISM",
    MBTEST = "Organism Present",
    MBSTRESC = as.character(MBORRES)
  ) %>%
  # Derive the rest of the variables below
  mutate(
    USUBJID = paste0(STUDYID, "-", SUBJID),
  ) %>%
  group_by(USUBJID) %>%
  mutate(
    VISITNUM = as.integer(as.factor(MBDTC)),
    VISIT = paste0("Visit ", VISITNUM),
  ) %>%
  ungroup() %>%
  mutate(
    # Identifiers: MBSPID (subject-organism-lab), MBREFID (subject-specimen-visit)
    MBSPID = paste0("ORG", sprintf("%02d", as.integer(factor(paste0(USUBJID, "-", organism))))),
    MBREFID = paste0(USUBJID, "-", MBSPEC, "-", VISITNUM),
    MBREFID = paste0("SPEC", sprintf("%02d", as.integer(factor(MBREFID)))),

    # Group ID for linking with MS (one-to-many): subject-specimen-visit-organism
    MBGRPID = paste0(USUBJID, "-", MBSPEC, "-", VISITNUM, "-", MBORRES),
    MBGRPID = paste0("GRP", sprintf("%02d", as.integer(factor(MBGRPID)))),
    MBGRPID = ifelse(MBTESTCD == "ORGANISM" & MBORRES != "NO GROWTH", MBGRPID, NA_character_),

    # Visit variables based on MBDTC
    VISITNUM = as.integer(as.factor(MBDTC)),
    VISIT = paste0("Visit ", VISITNUM),

    # Identifiers: MBSPID (subject-organism-lab), MBREFID (subject-specimen-visit)
    MBSPID = paste0("ORG", sprintf("%02d", as.integer(factor(paste0(USUBJID, "-", organism))))),
    MBREFID = paste0(USUBJID, "-", MBSPEC, "-", VISITNUM),
    MBREFID = paste0("SPEC", sprintf("%02d", as.integer(factor(MBREFID)))),

    # Group ID for linking with MS (one-to-many): subject-specimen-visit-organism
    MBGRPID = paste0(USUBJID, "-", MBSPEC, "-", VISITNUM, "-", MBORRES),
    MBGRPID = paste0("GRP", sprintf("%02d", as.integer(factor(MBGRPID)))),
    MBGRPID = ifelse(MBTESTCD == "ORGANISM" & MBORRES != "NO GROWTH", MBGRPID, NA_character_)
  )

## Assign MBSEQ for each record within each subject ----
mb <- mb %>%
  group_by(USUBJID) %>%
  mutate(MBSEQ = row_number()) %>%
  ungroup()

## Select and order columns per SDTM ----
mb <- mb %>%
  select(
    STUDYID, DOMAIN, USUBJID, MBSEQ, MBSPID, MBGRPID, MBREFID,
    MBTESTCD, MBTEST, MBORRES, MBSTRESC, MBRESCAT, MBLOC, MBSPEC,
    MBMETHOD, VISIT, VISITNUM, MBDTC
  )

# Add variable labels
mb <- mb %>%
  set_variable_labels(
    STUDYID = "Study Identifier",
    DOMAIN = "Domain Abbreviation",
    USUBJID = "Unique Subject Identifier",
    MBSEQ = "Sequence Number",
    MBSPID = "Sponsor-Defined Identifier",
    MBGRPID = "Group ID",
    MBMETHOD = "Method of Microbiology Test",
    MBREFID = "Reference ID",
    MBTESTCD = "Microbiology Test or Finding Short Name",
    MBTEST = "Microbiology Test or Finding Name",
    MBORRES = "Original Result",
    MBSTRESC = "Character Result/Finding in Standard Format",
    MBRESCAT = "Result Category",
    MBLOC = "Specimen Collection Location",
    MBSPEC = "Specimen Type",
    VISIT = "Visit Name",
    VISITNUM = "Visit Number",
    MBDTC = "Date/Time of Specimen Collection"
  )

# Save MB domain
usethis::use_data(mb, overwrite = TRUE)
