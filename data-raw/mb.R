# Dataset: MB
# Description: Creates microbiology data for the SDTM domains BE, MB and MS.
# The data is defined in a nested R list structure for clarity and ease of extension.
# At this file, MB is saved, while MS is saved in ms.R and BE in be.R.

# ============================================================
# Microbiology SDTM Synthetic Data Generator
# ------------------------------------------------------------
# This script defines a nested R list structure (`study_microb_data`)
# representing synthetic microbiology data.
#
# FILE STRUCTURE:
#   - Helper functions for MB (Microbiology) and MS (Microbial Susceptibility)
#     domain result generation (top of file)
#   - Main nested list (`study_microb_data`) containing all patient/specimen/aliquot/test data
#   - Extraction loop that traverses the nested list and automatically builds linked BE, MB, and MS domains
#   - Finalization and saving of the BE domain (MB saving is done in mb.R, MS in ms.R)
#
# DATA LINKAGE:
#   - The nested list is organized as:
#       study_microb_data[patient][specimen][aliquot][test]
#   - Each level contains relevant metadata (e.g., specimen type, collection date, organism, resistance)
#   - MB and MS test results are generated using the helper functions and stored in the nested list
#   - The extraction loop automatically links all data to the correct SDTM domains:
#       * BE (Biospecimen Events): specimen collection and aliquoting events
#       * MB (Microbiology): microbiology test results
#       * MS (Microbial Susceptibility): susceptibility test results
#   - All linkage (e.g., subject ID, specimen ID, aliquot ID) is handled automatically by the loop
#
# HOW TO ADD NEW DATA CASES:
#   1. Locate the `study_microb_data` list in this file.
#   2. Add a new patient (as a new element in the list), or add new specimens/aliquots/tests to an existing patient.
#   3. Use the provided helper functions (e.g., `mb_gram_stain_result`, `ms_di(can be adapted for MB/MS)sk_diffusion_result`) to generate MB/MS results.
#   4. Ensure each new entry follows the nested structure: patient → specimen → aliquot → MB/MS list.
#   5. The extraction loop will automatically include your new data in the output appropiately to the BE, MB, and MS domains.
#   6. Run all the relevant scripts (mb.R, ms.R, be.R) to generate and save the updated datasets.
#
# ============================================================

# Libraries ----
library(dplyr)
library(labelled)

# Helper Functions ----
# MB domain: Gram stain (CDISC v3.4)
mb_gram_stain_result <- function(test, count = NULL, presence = TRUE) {
  ## Detection record (presence/absence)
  detection <- data.frame(
    DOMAIN = "MB",
    MBTEST = test,
    MBTESTCD = switch(test,
      "Gram Negative Cocci" = "GMNCOC",
      "Gram Positive Cocci" = "GPRCOC",
      "Gram Negative Rods" = "GNROD",
      "Gram Positive Rods" = "GPROD",
      NA_character_
    ),
    MBTSTDTL = "DETECTION",
    MBORRES = if (presence) "PRESENT" else "ABSENT",
    MBSTRESC = if (presence) "PRESENT" else "ABSENT",
    MBMETHOD = "GRAM STAIN",
    MBRSLSCL = "Ord",
    MBORRESU = NA_character_,
    MBSTRESN = NA_character_,
    MBSTRESU = NA_character_,
    stringsAsFactors = FALSE
  )
  ## Quantification record (if count provided)
  quant <- NULL
  if (!is.null(count) && presence) {
    quant <- data.frame(
      DOMAIN = "MB",
      MBTEST = detection$MBTEST,
      MBTESTCD = detection$MBTESTCD,
      MBTSTDTL = "QUANTIFICATION",
      MBORRES = as.character(count),
      MBSTRESC = as.character(count),
      MBMETHOD = "GRAM STAIN",
      MBRSLSCL = "Ord",
      MBORRESU = NA_character_,
      MBSTRESN = switch(count,
        "1+" = 1,
        "2+" = 2,
        "3+" = 3,
        "4+" = 4,
        NA_character_
      ),
      MBSTRESU = NA_character_,
      stringsAsFactors = FALSE
    )
  }
  if (!is.null(quant) && presence) {
    rbind(detection, quant)
  } else {
    detection
  }
}

# MB domain: Colony count
mb_colony_count_result <- function(orres, orresu = NULL, stres = NULL, stresu = NULL) {
  data.frame(
    DOMAIN = "MB",
    MBTEST = "Colony Count",
    MBTESTCD = "MCCOLCNT",
    MBTSTDTL = "QUANTIFICATION",
    MBORRES = as.character(orres),
    MBSTRESC = if (!is.null(stres) && !is.na(stres)) as.character(stres) else as.character(orres),
    MBMETHOD = "COLONY COUNT",
    MBRSLSCL = "Quant",
    MBORRESU = if (!is.null(orresu) && !is.na(orresu)) as.character(orresu) else "CFU/mL",
    MBSTRESN = if (!is.null(stresu) && !is.na(stresu)) as.character(stresu) else as.character(orresu),
    MBSTRESU = stresu,
    stringsAsFactors = FALSE
  )
}

# MB domain: NAAT
mb_naat_result <- function(id_test_org, cd_id_test_org, id_org_successful = TRUE) {
  data.frame(
    DOMAIN = "MB",
    MBTEST = id_test_org,
    MBTESTCD = cd_id_test_org,
    MBTSTDTL = "DETECTION",
    MBORRES = if (id_org_successful) "PRESENT" else "ABSENT",
    MBSTRESC = if (id_org_successful) "PRESENT" else "ABSENT",
    MBMETHOD = "NUCLEIC ACID AMPLIFICATION TEST",
    MBRSLSCL = "Ord",
    MBORRESU = NA_character_,
    MBSTRESN = NA_character_,
    MBSTRESU = NA_character_,
    stringsAsFactors = FALSE
  )
}

# MB domain: No culture growth
mb_no_growth_result <- function() {
  data.frame(
    DOMAIN = "MB",
    MBTEST = "Microbial Organism Identification",
    MBTESTCD = "MCORGIDN",
    MBTSTDTL = "RESULT",
    MBORRES = "NO GROWTH",
    MBSTRESC = "NO GROWTH",
    MBMETHOD = "MICROBIAL CULTURE, SOLID",
    MBRSLSCL = "Nom",
    MBORRESU = NA_character_,
    MBSTRESN = NA_character_,
    MBSTRESU = NA_character_,
    stringsAsFactors = FALSE
  )
}

# MS domain: E-test
ms_epsilometer_result <- function(ab, orres, orresu = "ug/dL", stres = orres, stresu = orresu, ab_resistance = FALSE) {
  res <- data.frame(
    DOMAIN = "MS",
    MSTEST = "Minimum Inhibitory Concentration",
    MSTESTCD = "MIC",
    MSAGENT = ab,
    MSCONC = NA_character_,
    MSCONCU = NA_character_,
    MSORRES = orres,
    MSORRESU = orresu,
    MSSTRESC = as.character(stres),
    MSMETHOD = "EPSILOMETER",
    MSSTRESN = gsub("[^0-9\\.]", "", as.character(stres)),
    MSSTRESU = stresu,
    stringsAsFactors = FALSE
  )
  conclusion <- res %>%
    mutate(
      MSTEST = "Microbial Susceptibility",
      MSTESTCD = "MICROSUS",
      MSORRES = if (ab_resistance) "RESISTANT" else "SUSCEPTIBLE",
      MSORRESU = NA_character_,
      MSSTRESC = MSORRES,
      MSSTRESN = NA_character_,
      MSSTRESU = NA_character_
    )
  rbind(res, conclusion)
}

# MS domain: Disk diffusion
ms_disk_diffusion_result <- function(ab, orres = 20, orresu = "mm", stres = orres, stresu = orresu, ab_resistance) {
  res <- data.frame(
    DOMAIN = "MS",
    MSTEST = "Diameter of the Zone of Inhibition",
    MSTESTCD = "DIAZOINH",
    MSAGENT = ab,
    MSCONC = NA_character_,
    MSCONCU = NA_character_,
    MSORRES = orres,
    MSORRESU = orresu,
    MSSTRESC = as.character(stres),
    MSMETHOD = "DISK DIFFUSION",
    MSSTRESN = gsub("[^0-9\\.]", "", as.character(stres)),
    MSSTRESU = stresu,
    stringsAsFactors = FALSE
  )
  conclusion <- res %>%
    mutate(
      MSTEST = "Microbial Susceptibility",
      MSTESTCD = "MICROSUS",
      MSORRES = ifelse(ab_resistance, "RESISTANT", "SUSCEPTIBLE"),
      MSORRESU = NA_character_,
      MSSTRESC = ifelse(ab_resistance, "RESISTANT", "SUSCEPTIBLE"),
      MSSTRESN = NA_character_,
      MSSTRESU = NA_character_
    )
  rbind(res, conclusion)
}

# MS domain: NAAT
ms_naat_result <- function(ab, ab_resistance = FALSE) {
  data.frame(
    DOMAIN = "MS",
    MSTEST = "Microbial Susceptibility",
    MSTESTCD = "MICROSUS",
    MSAGENT = ab,
    MSCONC = NA_character_,
    MSCONCU = NA_character_,
    MSORRES = if (ab_resistance) "RESISTANT" else "SUSCEPTIBLE",
    MSORRESU = NA_character_,
    MSSTRESC = ifelse(ab_resistance, "RESISTANT", "SUSCEPTIBLE"),
    MSMETHOD = "NUCLEIC ACID AMPLIFICATION TEST",
    MSSTRESN = NA_character_,
    MSSTRESU = NA_character_,
    stringsAsFactors = FALSE
  )
}


# Data Structure: study_microb_data ----
# Nested list defining for a study each of the process steps:
# - Patient studied
#   - Specimen collected
#     - Specimen aliquots
#       - Aliquots cultured
#        - Microbiology tests (MB) performed on the cultured aliquot
#        - Susceptibility tests (MS) performed on the cultured aliquot
#
# Each level contains the relevant information to create the SDTM domains:
# - BE: specimen collection and aliquoting events
# - MB: microbiology test results
# - MS: microbial susceptibility test results
#
# Test results for MB and MS are created using the helper functions defined above.

study_microb_data <- list(
  # Patient 1: organism identified with no infection and no resistance
  "1" = list(
    # Specimen 1
    "1" = list(
      specimen = "SKIN TISSUE",
      spec_location = "SKIN OF THE AXILLA",
      collection_date = "2025-06-14T08:00",
      not_cultured_aliquots = list(
        "1" = list(
          aliquot_preparation_dt = "2025-06-14T09:00"
        )
      ),
      cultured_aliquots = list(
        "2" = list(
          organism = "STAPHYLOCOCCUS AUREUS",
          aliquot_preparation_dt = "2025-06-15T09:30",
          culture_start_dt = "2025-06-15T10:00",
          culture_end_dt = "2025-06-30T10:00",
          MB = list(
            mb_gram_stain_result(test = "Gram Negative Cocci", count = "2+"),
            mb_colony_count_result(orres = 100, orresu = "CFU/mL", stres = 100, stresu = "CFU/mL")
          ),
          MS = list(
            ms_epsilometer_result(
              ab = "VANCOMYCIN", orres = 3, orresu = "ug/dL", stres = 3, stresu = "ug/dL",
              ab_resistance = TRUE
            ),
            ms_disk_diffusion_result(
              ab = "CIPROFLOXACIN", orres = 14, orresu = "mm", stres = 14, stresu = "mm",
              ab_resistance = FALSE
            )
          )
        ),
        "3" = list(
          organism = "KLEBSIELLA PNEUMONIAE",
          aliquot_preparation_dt = "2025-06-15T09:45",
          culture_start_dt = "2025-06-15T11:00",
          culture_end_dt = "2025-06-30T11:00",
          MB = list(
            mb_gram_stain_result(test = "Gram Negative Rods", count = "1+"),
            mb_colony_count_result(orres = 50, orresu = "CFU/mL", stres = 50, stresu = "CFU/mL")
          ),
          MS = list(
            ms_epsilometer_result(
              ab = "AMIKACIN", orres = 1.5, orresu = "ug/dL", stres = 1.5, stresu = "ug/dL",
              ab_resistance = FALSE
            )
          )
        )
      )
    ),
    # Specimen 2
    "2" = list(
      specimen = "SKIN TISSUE",
      spec_location = "SKIN OF THE AXILLA",
      collection_date = "2025-06-21T08:00",
      not_cultured_aliquots = list(),
      cultured_aliquots = list(
        "1" = list(
          organism = "KLEBSIELLA PNEUMONIAE",
          resistance_ab = c("CIPROFLOXACIN", "AMOXICILLIN/CLAVULANATE", "CEFTAZIDIME"),
          aliquot_preparation_dt = "2025-06-22T09:30",
          culture_start_dt = "2025-06-22T10:00",
          culture_end_dt = "2025-07-07T10:00",
          MB = list(
            mb_gram_stain_result(test = "Gram Negative Rods", count = "3+"),
            mb_colony_count_result(orres = 500, orresu = "CFU/mL", stres = 500, stresu = "CFU/mL")
          ),
          MS = list(
            ms_epsilometer_result(
              ab = "AMIKACIN", orres = 10, orresu = "ug/dL", stres = 10, stresu = "ug/dL",
              ab_resistance = TRUE
            )
          )
        )
      )
    )
  ),
  # Patient 2: organism identified with infection and resistance
  "2" = list(
    # Specimen 1
    "1" = list(
      specimen = "URINE",
      spec_location = "URINARY SYSTEM",
      collection_date = "2025-07-15T08:00",
      not_cultured_aliquots = list(
        "1" = list(
          aliquot_preparation_dt = "2025-07-15T09:30"
        )
      ),
      cultured_aliquots = list(
        "2" = list(
          organism = "ENTEROCOCCUS FAECALIS",
          resistance_ab = c("AMOXICILLIN"),
          aliquot_preparation_dt = "2025-07-16T09:30",
          culture_start_dt = "2025-07-16T10:00",
          culture_end_dt = "2025-07-31T10:00",
          MB = list(
            mb_gram_stain_result(test = "Gram Positive Cocci", count = "4+"),
            mb_colony_count_result(orres = 300, orresu = "CFU/mL", stres = 300, stresu = "CFU/mL")
          ),
          MS = list(
            ms_disk_diffusion_result(
              ab = "AMOXICILLIN", orres = 8, orresu = "mm", stres = 8, stresu = "mm",
              ab_resistance = TRUE
            )
          )
        )
      )
    ),
    # Specimen 2
    "2" = list(
      specimen = "URINE",
      spec_location = "URINARY SYSTEM",
      collection_date = "2025-07-22T08:00",
      not_cultured_aliquots = list(),
      cultured_aliquots = list(
        "1" = list(
          organism = "ENTEROCOCCUS FAECALIS",
          resistance_ab = c("AMOXICILLIN"),
          aliquot_preparation_dt = "2025-07-23T09:30",
          culture_start_dt = "2025-07-23T10:00",
          culture_end_dt = "2025-08-07T10:00",
          MS = list(
            ms_disk_diffusion_result(
              ab = "AMOXICILLIN", orres = 7, orresu = "mm", stres = 7, stresu = "mm",
              ab_resistance = TRUE
            )
          )
        )
      )
    )
  ),
  # Patient 3: organism identified with infection and multidrug resistance
  "3" = list(
    # Specimen 1
    "1" = list(
      specimen = "SKIN TISSUE",
      spec_location = "SKIN OF THE AXILLA",
      collection_date = "2025-08-11T08:00",
      not_cultured_aliquots = list(),
      cultured_aliquots = list(
        "1" = list(
          organism = "STAPHYLOCOCCUS AUREUS",
          resistance_ab = c("VANCOMYCIN"),
          aliquot_preparation_dt = "2025-08-12T09:30",
          culture_start_dt = "2025-08-12T10:00",
          culture_end_dt = "2025-08-27T10:00",
          MS = list(
            ms_epsilometer_result(
              ab = "VANCOMYCIN", orres = 32, orresu = "ug/dL", stres = 32, stresu = "ug/dL",
              ab_resistance = TRUE
            )
          )
        ),
        "2" = list(
          organism = "STAPHYLOCOCCUS AUREUS",
          resistance_ab = c("PENICILLIN", "CIPROFLOXACIN", "CLINDAMYCIN"),
          aliquot_preparation_dt = "2025-08-30T09:30",
          culture_start_dt = "2025-08-30T10:00",
          culture_end_dt = "2025-09-14T10:00",
          MS = list(
            ms_epsilometer_result(
              ab = "PENICILLIN", orres = 2, orresu = "ug/dL", stres = 2, stresu = "ug/dL",
              ab_resistance = TRUE
            ),
            ms_epsilometer_result(
              ab = "CIPROFLOXACIN", orres = 8, orresu = "ug/dL", stres = 8, stresu = "ug/dL",
              ab_resistance = TRUE
            ),
            ms_disk_diffusion_result(
              ab = "CLINDAMYCIN", orres = 12, orresu = "mm", stres = 12, stresu = "mm",
              ab_resistance = TRUE
            )
          )
        )
      )
    )
  ),
  # Patient 4: organism identified with infection and no resistance
  "4" = list(
    # Specimen 1
    "1" = list(
      specimen = "SPUTUM",
      spec_location = "LUNG",
      collection_date = "2025-09-10T08:00",
      not_cultured_aliquots = list(),
      cultured_aliquots = list(
        "1" = list(
          organism = "STREPTOCOCCUS PNEUMONIAE",
          resistance_ab = "",
          aliquot_preparation_dt = "2025-09-11T09:30",
          culture_start_dt = "2025-09-11T10:00",
          culture_end_dt = "2025-09-26T10:00",
          MB = list(
            mb_gram_stain_result(test = "Gram Positive Cocci", count = "2+"),
            mb_colony_count_result(orres = 150, orresu = "CFU/mL", stres = 150, stresu = "CFU/mL")
          ),
          MS = list(
            ms_disk_diffusion_result(
              ab = "ERYTHROMYCIN", orres = 6, orresu = "mm", stres = 6, stresu = "mm",
              ab_resistance = FALSE
            )
          )
        )
      )
    )
  ),
  # Patient 5: multiple organisms identified in same specimen with later multidrug resistance (MDR)
  "5" = list(
    # Specimen 1
    "1" = list(
      specimen = "SPUTUM",
      spec_location = "LUNG",
      collection_date = "2025-10-05T08:00",
      not_cultured_aliquots = list(),
      cultured_aliquots = list(
        "1" = list(
          organism = "STAPHYLOCOCCUS AUREUS",
          resistance_ab = c("PENICILLIN"),
          aliquot_preparation_dt = "2025-10-05T09:30",
          culture_start_dt = "2025-10-05T10:00",
          culture_end_dt = "2025-10-20T10:00",
          MS = list(
            ms_disk_diffusion_result(
              ab = "ERYTHROMYCIN", orres = 22, orresu = "mm", stres = 22, stresu = "mm",
              ab_resistance = FALSE
            ),
            ms_disk_diffusion_result(
              ab = "RIFAMPICIN", orres = 28, orresu = "mm", stres = 28, stresu = "mm",
              ab_resistance = FALSE
            ),
            ms_epsilometer_result(
              ab = "CLARITHROMYCIN", orres = 0.1, orresu = "ug/dL", stres = 0.1, stresu = "ug/dL",
              ab_resistance = FALSE
            )
          )
        ),
        "2" = list(
          organism = "STREPTOCOCCUS PNEUMONIAE",
          resistance_ab = c("ERYTHROMYCIN"),
          aliquot_preparation_dt = "2025-10-05T09:45",
          culture_start_dt = "2025-10-05T11:00",
          culture_end_dt = "2025-10-20T11:00",
          MS = list(
            ms_disk_diffusion_result(
              ab = "ERYTHROMYCIN", orres = 25, orresu = "mm", stres = 25, stresu = "mm",
              ab_resistance = FALSE
            ),
            ms_disk_diffusion_result(
              ab = "RIFAMPICIN", orres = 30, orresu = "mm", stres = 30, stresu = "mm",
              ab_resistance = FALSE
            ),
            ms_epsilometer_result(
              ab = "CLARITHROMYCIN", orres = 0.2, orresu = "ug/dL", stres = 0.2, stresu = "ug/dL",
              ab_resistance = FALSE
            )
          )
        )
      )
    ),
    # Specimen 2: MDR development in S. aureus
    "2" = list(
      specimen = "SPUTUM",
      spec_location = "LUNG",
      collection_date = "2025-10-15T08:00",
      not_cultured_aliquots = list(),
      cultured_aliquots = list(
        "1" = list(
          organism = "STAPHYLOCOCCUS AUREUS",
          resistance_ab = c("PENICILLIN", "VANCOMYCIN"),
          aliquot_preparation_dt = "2025-10-16T09:30",
          culture_start_dt = "2025-10-16T10:00",
          culture_end_dt = "2025-10-31T10:00",
          MS = list(
            ms_disk_diffusion_result(
              ab = "ERYTHROMYCIN", orres = 18, orresu = "mm", stres = 18, stresu = "mm",
              ab_resistance = TRUE
            ),
            ms_disk_diffusion_result(
              ab = "RIFAMPICIN", orres = 20, orresu = "mm", stres = 20, stresu = "mm",
              ab_resistance = TRUE
            ),
            ms_epsilometer_result(
              ab = "CLARITHROMYCIN", orres = 2, orresu = "ug/dL", stres = 2, stresu = "ug/dL",
              ab_resistance = TRUE
            )
          )
        ),
        "2" = list(
          organism = "STREPTOCOCCUS PNEUMONIAE",
          resistance_ab = c("ERYTHROMYCIN", "CLARITHROMYCIN"),
          aliquot_preparation_dt = "2025-10-16T09:45",
          culture_start_dt = "2025-10-16T11:00",
          culture_end_dt = "2025-10-31T11:00",
          MS = list(
            ms_disk_diffusion_result(
              ab = "ERYTHROMYCIN", orres = 25, orresu = "mm", stres = 25, stresu = "mm",
              ab_resistance = FALSE
            ),
            ms_disk_diffusion_result(
              ab = "RIFAMPICIN", orres = 30, orresu = "mm", stres = 30, stresu = "mm",
              ab_resistance = FALSE
            ),
            ms_epsilometer_result(
              ab = "CLARITHROMYCIN", orres = 0.2, orresu = "ug/dL", stres = 0.2, stresu = "ug/dL",
              ab_resistance = FALSE
            )
          )
        )
      )
    )
  ),
  # Patient 6: nothing grown from specimen
  "6" = list(
    # Specimen 1
    "1" = list(
      specimen = "SPUTUM",
      spec_location = "LUNG",
      collection_date = "2025-11-01T08:00",
      not_cultured_aliquots = list(),
      cultured_aliquots = list(
        "1" = list(
          aliquot_preparation_dt = "2025-11-01T09:30",
          culture_start_dt = "2025-11-01T10:00",
          culture_end_dt = "2025-11-16T10:00",
          MB = list(mb_no_growth_result())
        ),
        "2" = list(
          aliquot_preparation_dt = "2025-11-01T09:30",
          culture_start_dt = "2025-11-01T10:00",
          culture_end_dt = "2025-11-16T10:00",
          MB = list(mb_no_growth_result())
        )
      )
    )
  ),
  # Patient 7: Mycobacterium tuberculosis complex rifampicin resistant identified by NAAT
  "7" = list(
    # Specimen 1
    "1" = list(
      specimen = "LAVAGE FLUID",
      spec_location = "STOMACH",
      collection_date = "2025-12-01T08:00",
      not_cultured_aliquots = list(
        "1" = list(
          aliquot_preparation_dt = "2025-12-01T09:30"
        )
      ),
      cultured_aliquots = list(
        "1" = list(
          organism = "MYCOBACTERIUM TUBERCULOSIS",
          resistance_ab = c("RIFAMPICIN"),
          aliquot_preparation_dt = "2025-12-02T09:30",
          culture_start_dt = "2025-12-02T10:00",
          culture_end_dt = "2025-12-17T10:00",
          MB = list(
            mb_naat_result(
              id_test_org = "Mycobacterium tuberculosis complex",
              cd_id_test_org = "MTBCMPLX",
              id_org_successful = TRUE
            )
          ),
          MS = list(
            ms_naat_result(
              ab = "RIFAMPICIN",
              ab_resistance = TRUE
            )
          )
        )
      )
    )
  )
)


# Extraction Loop: Build BE, MB, MS Domains ----
dm <- pharmaversesdtm::dm
studyid <- unique(dm$STUDYID)[1]
usubjids <- unique(dm$USUBJID)

be <- data.frame()
ms <- data.frame()
mb <- data.frame()

# Loop over each subject (patient) in the study
for (subj_ix in seq_along(study_microb_data)) {
  usubjid <- usubjids[subj_ix]
  subj_data <- study_microb_data[[subj_ix]]

  # Initialize subject-level counters
  visitnum <- 0
  msgrpid <- 0
  mbgrpid <- 0
  beseq <- 0
  mbseq <- 0
  msseq <- 0

  # Loop over each specimen for the subject
  for (spec_ix in seq_along(subj_data)) {
    specid <- paste0("SPEC", subj_ix, ".", spec_ix)
    spec_data <- subj_data[[spec_ix]]

    # Extract specimen-level metadata
    spec <- spec_data$specimen
    specloc <- spec_data$spec_location
    collection_date <- spec_data$collection_date
    beseq <- beseq + 1
    visitnum <- visitnum + 1

    # Record specimen collection event in BE domain
    be_collection <- data.frame(
      STUDYID = studyid,
      DOMAIN = "BE",
      USUBJID = usubjid,
      BESEQ = beseq,
      BEREFID = specid,
      BELNKID = NA,
      BETERM = "Specimen Collection",
      BECAT = "COLLECTION",
      BELOC = specloc,
      VISITNUM = visitnum,
      BEDTC = collection_date,
      BESTDTC = collection_date,
      BEENDTC = NA
    )
    be <- rbind(be, be_collection)

    # Loop over not cultured aliquots for this specimen
    for (aliq_ix in seq_len(length(spec_data$not_cultured_aliquots))) {
      # Generate aliquot ID and extract data
      aliquot_nr <- names(spec_data$not_cultured_aliquots)[aliq_ix]
      aliquot_id <- gsub("SPEC", "ALIQ", paste0(specid, ".", aliquot_nr))
      aliquot_data <- spec_data$not_cultured_aliquots[[aliq_ix]]

      # Record aliquoting event in BE domain
      beseq <- beseq + 1
      be <- rbind(
        be,
        be_collection %>%
          mutate(
            BESEQ = beseq,
            BEREFID = aliquot_id,
            BETERM = "Aliquoting",
            BECAT = "PREPARATION",
            BESTDTC = aliquot_data$aliquot_preparation_dt
          )
      )
    }

    # Loop over cultured aliquots for this specimen
    for (aliq_ix in seq_len(length(spec_data$cultured_aliquots))) {
      # Generate IDs and extract data
      aliquot_nr <- names(spec_data$cultured_aliquots)[aliq_ix]
      aliquot_id <- gsub("SPEC", "ALIQ", paste0(specid, ".", aliquot_nr))
      culture_id <- paste0(aliquot_id, "-C")
      aliquot_data <- spec_data$cultured_aliquots[[aliq_ix]]

      # Extract organism and resistance info
      nhoid <- aliquot_data$organism
      ab_resist <- aliquot_data$resistance_ab
      bestdtc_prep <- aliquot_data$aliquot_preparation_dt
      bestdtc_cult <- aliquot_data$culture_start_dt
      beendtc_cult <- aliquot_data$culture_end_dt

      # Record aliquoting and culturing events in BE domain
      beseq <- beseq + 2
      be <- rbind(
        be,
        be_collection %>% mutate(
          BESEQ = beseq - 1,
          BEREFID = aliquot_id,
          BETERM = "Aliquoting",
          BECAT = "PREPARATION",
          BESTDTC = bestdtc_prep
        ),
        be_collection %>% mutate(
          BESEQ = beseq,
          BEREFID = culture_id,
          BETERM = "Culturing",
          BECAT = "CULTURE",
          BESTDTC = bestdtc_cult,
          BEENDTC = beendtc_cult
        )
      )

      # Add MB results if present
      if (!is.null(aliquot_data$MB)) {
        for (res_grp_ix in seq_len(length(aliquot_data$MB))) {
          mbgrpid <- mbgrpid + 1
          res_grp_data <- aliquot_data$MB[[res_grp_ix]]
          mbseq <- mbseq + nrow(res_grp_data)

          # Add MB rows to MB domain
          res <- res_grp_data %>%
            mutate(
              STUDYID = studyid,
              USUBJID = usubjid,
              MBSEQ = seq(mbseq - nrow(.) + 1, mbseq),
              MBREFID = aliquot_id,
              MBGRPID = mbgrpid,
              MBLNKGRP = culture_id,
              MBSPEC = spec,
              MBLOC = specloc,
              VISITNUM = visitnum,
              MBDTC = collection_date
            )
          mb <- rbind(mb, res)
        }
      }

      # Add MS results if present
      if (!is.null(aliquot_data$MS)) {
        for (res_grp_ix in seq_len(length(aliquot_data$MS))) {
          msgrpid <- msgrpid + 1
          res_grp_data <- aliquot_data$MS[[res_grp_ix]]
          msseq <- msseq + nrow(res_grp_data)

          # Add MS rows to MS domain
          res <- res_grp_data %>%
            mutate(
              STUDYID = studyid,
              USUBJID = usubjid,
              MSSEQ = seq(msseq - nrow(.) + 1, msseq),
              MSREFID = aliquot_id,
              NHOID = nhoid,
              MSGRPID = msgrpid,
              MSLNKID = culture_id,
              MSSPEC = spec,
              MSLOC = specloc,
              VISITNUM = visitnum,
              MSDTC = collection_date
            )
          ms <- bind_rows(ms, res)
        }
      }
    }
  }
}


# Finalize and save MB domain ----

# Reorder columns according to CDISC SDTM MS standards (v3.4)
mb <- mb %>%
  select(
    STUDYID,
    DOMAIN,
    USUBJID,
    MBSEQ,
    MBGRPID,
    MBGRPID,
    MBREFID,
    MBLNKGRP,
    MBTESTCD,
    MBTEST,
    MBTSTDTL,
    MBORRES,
    MBORRESU,
    MBRSLSCL,
    MBSTRESC,
    MBSTRESC,
    MBSTRESN,
    MBSTRESU,
    MBSPEC,
    MBLOC,
    MBMETHOD,
    VISITNUM,
    MBDTC
  ) %>%
  # Add variable labels
  set_variable_labels(
    STUDYID = "Study Identifier",
    DOMAIN = "Domain Abbreviation",
    USUBJID = "Unique Subject Identifier",
    MBSEQ = "Sequence Number",
    MBREFID = "Reference ID",
    MBGRPID = "Group ID",
    MBLNKGRP = "Link Group ID",
    MBMETHOD = "Method of Test or Examination",
    MBREFID = "Reference ID",
    MBTESTCD = "Microbiology Test or Finding Short Name",
    MBTEST = "Microbiology Test or Finding Name",
    MBTSTDTL = "Measurement, Test or Examination Detail",
    MBORRES = "Original Result",
    MBORRESU = "Original Units",
    MBRSLSCL = "Result Scale",
    MBSTRESC = "Result or Finding in Standard Format",
    MBSTRESN = "Numeric Result/Finding in Standard Units",
    MBSTRESU = "Standard Units",
    MBLOC = "Specimen Collection Location",
    MBSPEC = "Specimen Material Type",
    VISITNUM = "Visit Number",
    MBDTC = "Date/Time of Collection"
  )

# Save MB domain
usethis::use_data(mb, overwrite = TRUE)
