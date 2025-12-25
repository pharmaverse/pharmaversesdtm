library(dplyr)
library(labelled)

micro_df <- list(
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
              resistance_ab = c("PENICILLIN", "VANCOMYCIN"),
              aliquot_preparation_dt = "2025-06-15T09:30",
              culture_start_dt = "2025-06-15T10:00",
              culture_end_dt = "2025-06-30T10:00",
              MB = list(
                process_mb_gram_stain(test = "Gram Negative Cocci", count = "2+"),
                process_colony_count(orres = 100, orresu = "CFU/mL", stres = 100, stresu = "CFU/mL"),
                process_naat(testcd = "GENE1", genotype = list(TEST = "Complex", TESTCD = "CMPLX"))
              ),
              MS = list(
                process_eppsilometer(
                  ab = "PENICILLIN", orres = 0.5, orresu = "ug/dL", stres = 0.5, stresu = "ug/dL",
                  ab_resistance = TRUE
                ),
                process_disk_diffusion(
                  ab = "VANCOMYCIN", orres = 14, orresu = "mm", stres = 14, stresu = "mm",
                  ab_resistance = FALSE
                )
              )
            ),
            "3" = list(
              organism = "KLEBSIELLA PNEUMONIAE",
              resistance_ab = "",
              aliquot_preparation_dt = "2025-06-15T09:45",
              culture_start_dt = "2025-06-15T11:00",
              culture_end_dt = "2025-06-30T11:00",
              MB = list(
                process_mb_gram_stain(test = "Gram Negative Rods", count = "1+"),
                process_colony_count(orres = 50, orresu = "CFU/mL", stres = 50, stresu = "CFU/mL")
              ),
              MS = list(
                process_eppsilometer(
                  ab = "CIPROFLOXACIN", orres = 0.25, orresu = "ug/dL", stres = 0.25, stresu = "ug/dL",
                  ab_resistance = FALSE
                )
              )
            )
          )
        ),
        # Specimen 2: Kleibsella acquired multidrug resistance
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
                    process_mb_gram_stain(test = "Gram Negative Rods", count = "3+"),
                    process_colony_count(orres = 500, orresu = "CFU/mL", stres = 500, stresu = "CFU/mL")
                  ),
                  MS = list(
                    process_eppsilometer(
                      ab = "CIPROFLOXACIN", orres = 4, orresu = "ug/dL", stres = 4, stresu = "ug/dL",
                      ab_resistance = TRUE
                    ),
                    process_eppsilometer(
                      ab = "AMOXICILLIN/CLAVULANATE", orres = 16, orresu = "ug/dL", stres = 16, stresu = "ug/dL",
                      ab_resistance = TRUE
                    ),
                    process_eppsilometer(
                      ab = "CEFTAZIDIME", orres = 8, orresu = "ug/dL", stres = 8, stresu = "ug/dL",
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
                      process_mb_gram_stain(test = "Gram Positive Cocci", count = "4+"),
                      process_colony_count(orres = 300, orresu = "CFU/mL", stres = 300, stresu = "CFU/mL")
                    ),
                    MS = list(
                      process_disk_diffusion(
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
                      process_disk_diffusion(
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
                        process_eppsilometer(
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
                        process_eppsilometer(
                          ab = "PENICILLIN", orres = 2, orresu = "ug/dL", stres = 2, stresu = "ug/dL",
                          ab_resistance = TRUE
                        ),
                        process_eppsilometer(
                          ab = "CIPROFLOXACIN", orres = 8, orresu = "ug/dL", stres = 8, stresu = "ug/dL",
                          ab_resistance = TRUE
                        ),
                        process_disk_diffusion(
                          ab = "CLINDAMYCIN", orres = 12, orresu = "mm", stres = 12, stresu = "mm",
                          ab_resistance = TRUE
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
                      process_eppsilometer(
                        ab = "PENICILLIN", orres = 1, orresu = "ug/dL", stres = 1, stresu = "ug/dL",
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
                      process_disk_diffusion(
                        ab = "ERYTHROMYCIN", orres = 13, orresu = "mm", stres = 13, stresu = "mm",
                        ab_resistance = FALSE
                      )
                    )
                )
          )
        ),
        # Specimen 2: MDR development
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
                      process_eppsilometer(
                        ab = "PENICILLIN", orres = 4, orresu = "ug/dL", stres = 4, stresu = "ug/dL",
                        ab_resistance = TRUE
                      ),
                      process_eppsilometer(
                        ab = "VANCOMYCIN", orres = 32, orresu = "ug/dL", stres = 32, stresu = "ug/dL",
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
                      process_disk_diffusion(
                        ab = "ERYTHROMYCIN", orres = 10, orresu = "mm", stres = 10, stresu = "mm",
                        ab_resistance = TRUE
                      ),
                      process_disk_diffusion(
                        ab = "CLARITHROMYCIN", orres = 11, orresu = "mm", stres = 11, stresu = "mm",
                        ab_resistance = TRUE
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
                MB = list(process_no_growth())
              ),
              "2" = list(
                aliquot_preparation_dt = "2025-11-01T09:30",
                culture_start_dt = "2025-11-01T10:00",
                culture_end_dt = "2025-11-16T10:00",
                MB = list(process_no_growth())
              )
            )
         )
    )
)


studyid = "MI"
lab = "ABC LABS"
domain <- "MB"

be <- data.frame()
ms <- data.frame()
mb <- data.frame()
for (i in seq_len(length(micro_df))) {
    subjid <- names(micro_df)[i]
    subj_info <- micro_df[[i]]

    usubjid <- paste0(studyid, "-", sprintf("%02d", as.integer(subjid)))
    visitnum <- 0
    msgrpid <- 0
    mbgrpid <- 0
    beseq <- 0
    mbseq <- 0
    msseq <- 0

    for (j in seq_len(length(subj_info))) {
        spec_nr <- names(subj_info)[j]
        specid <- paste0("SP", i, ".", j)
        spec_info <- subj_info[[j]]

        spec <- spec_info$specimen
        specloc <- spec_info$spec_location
        collection_date <- spec_info$collection_date
        beseq <- beseq + 1
        visitnum <- visitnum + 1

        be <- rbind(
            be,
            data.frame(
                STUDYID = studyid,
                DOMAIN = "BE",
                USUBJID = usubjid,
                BESEQ = beseq,
                BEREFID = spec_nr,
                BELNKID = NA,
                BETERM = "Collecting",
                BECAT = "COLLECTION",
                BELOC = specloc,
                VISITNUM = visitnum,
                BEDTC = collection_date,
                BESTDTC = collection_date,
                BEENDTC = NA
            )
        )

        for (a_nc in seq_len(length(spec_info$not_cultured_aliquots))) {
            aliquot_nr <- names(spec_info$not_cultured_aliquots)[a_nc]
            aliquot_id <- gsub("SP", "AL", paste0(specid, ".",  aliquot_nr))
            aliquot_info <- spec_info$not_cultured_aliquots[[a_nc]]

            beseq <- beseq + 1

            be <- rbind(
                be,
                data.frame(
                    STUDYID = studyid,
                    DOMAIN = "BE",
                    USUBJID = usubjid,
                    BESEQ = beseq,
                    BEREFID = aliquot_id,
                    BELNKID = NA,
                    BETERM = "Aliquoting",
                    BECAT = "PREPARATION",
                    BELOC = specloc,
                    VISITNUM = visitnum,
                    BEDTC = collection_date,
                    BESTDTC = aliquot_info$aliquot_preparation_dt,
                    BEENDTC = NA
                )
            )
        }

        for (k in seq_len(length(spec_info$cultured_aliquots))) {
            aliquot_nr <- names(spec_info$cultured_aliquots)[k]
            aliquot_id <- gsub("SP", "AL", paste0(specid, ".",  aliquot_nr))
            culture_id <- paste0(aliquot_id, "-C")
            aliquot_info <- spec_info$cultured_aliquots[[k]]

            nhoid <- aliquot_info$organism
            ab_resist <- aliquot_info$resistance_ab
            bestdtc_prep <- aliquot_info$aliquot_preparation_dt
            bestdtc_cult <- aliquot_info$culture_start_dt
            beendtc_cult <- aliquot_info$culture_end_dt

            beseq <- beseq + 1
            be <- rbind(
                be,
                data.frame(
                    STUDYID = studyid,
                    DOMAIN = "BE",
                    USUBJID = usubjid,
                    BESEQ = beseq,
                    BEREFID = aliquot_id,
                    BELNKID = NA,
                    BETERM = "Aliquoting",
                    BECAT = "PREPARATION",
                    BELOC = specloc,
                    VISITNUM = visitnum,
                    BEDTC = collection_date,
                    BESTDTC = bestdtc_prep,
                    BEENDTC = NA
                ),
                data.frame(
                    STUDYID = studyid,
                    DOMAIN = "BE",
                    USUBJID = usubjid,
                    BESEQ = beseq + 1,
                    BEREFID = aliquot_id,
                    BELNKID = culture_id,
                    BETERM = "Culturing",
                    BECAT = "CULTURE",
                    BELOC = specloc,
                    VISITNUM = visitnum,
                    BEDTC = collection_date,
                    BESTDTC = bestdtc_cult,
                    BEENDTC = beendtc_cult
                )
            )
            beseq <- beseq + 1

            # MB: rbind the precomputed MB data.frame if present
            if (!is.null(aliquot_info$MB)) {
              for (res_grp in seq_len(length(aliquot_info$MB))) {
                mbgrpid <- mbgrpid + 1
                mbseq <- mbseq + 1

                res <- aliquot_info$MB[[res_grp]] %>%
                  dplyr::mutate(
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
            # MS: keep as before (methods list)
            if (!is.null(aliquot_info$MS)) {
              for (res_grp in seq_len(length(aliquot_info$MS))) {
                msgrpid <- msgrpid + 1
                msseq <- msseq + 1

                res <- aliquot_info$MS[[res_grp]] %>%
                  dplyr::mutate(
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
                ms <- dplyr::bind_rows(ms, res)
              }
            }
          }
        }
    }
}

be <- be %>%
  # Derive BESEQ properly
  arrange(STUDYID, USUBJID, BEDTC, BESTDTC) %>%
  group_by(USUBJID) %>%
  mutate(
    BESEQ = row_number()
  ) %>%
  ungroup() %>%
  # Order columns
  select(
    STUDYID,
    DOMAIN,
    USUBJID,
    BESEQ,
    BEREFID,
    BELNKID,
    BETERM,
    BECAT,
    BELOC,
    VISITNUM,
    BEDTC,
    BESTDTC,
    BEENDTC
  ) %>%
  # Label columns (as per CDISC SDTM v3.4)
  set_variable_labels(
    STUDYID = "Study Identifier",
    DOMAIN = "Domain Abbreviation",
    USUBJID = "Unique Subject Identifier",
    BESEQ = "Sequence Number",
    BEREFID = "Reference ID",
    BELNKID = "Link Identifier",
    BETERM = "Reported Term for the Biospecimen Event",
    BECAT = "Category for Biospecimen Event",
    BELOC = "Anatomical Location of Event",
    VISITNUM = "Visit Number",
    BEDTC = "Date/Time of Specimen Collection",
    BESTDTC = "Start Date/Time of Biospecimen Event",
    BEENDTC = "End Date/Time of Biospecimen Event"
  )


# Helper function: process GRAM STAIN for MB domain (CDISC v3.4)
process_mb_gram_stain <- function(
    test, count = NULL, presence = TRUE
) {
  # Detection record (presence/absence)
  detection <- data.frame(
    DOMAIN = "MB",
    MBTEST = test,
    MBTESTCD = switch(
      test,
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
  # Quantification record (if count provided)
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
        MBSTRESN = switch(
            count,
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

process_colony_count <- function(
    orres, orresu = NULL, stres = NULL, stresu = NULL
) {
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

process_naat <- function(
    testcd, genotype = NULL
) {
  # Detection record
  detection <- data.frame(
    DOMAIN = "MB",
    MBTEST = "Nucleic Acid Amplification Test",
    MBTESTCD = "MCNAAT",
    MBTSTDTL = "DETECTION",
    MBORRES = "PRESENT",
    MBSTRESC = "PRESENT",
    MBMETHOD = "NUCLEIC ACID AMPLIFICATION TEST",
    MBRSLSCL = "Ord",
    MBORRESU = NA_character_,
    MBSTRESN = NA_character_,
    MBSTRESU = NA_character_,
    stringsAsFactors = FALSE
  )
  # Genotype record (if genotype provided)
  geno <- NULL
  if (!is.null(genotype)) {
    geno <- data.frame(
        DOMAIN = "MB",
        MBTEST = detection$MBTEST,
        MBTESTCD = detection$MBTESTCD,
        MBTSTDTL = "GENOTYPE",
        MBORRES = as.character(genotype$TEST),
        MBSTRESC = genotype$TEST,
        MBMETHOD = "NUCLEIC ACID AMPLIFICATION TEST",
        MBRSLSCL = "Nom",
        MBORRESU = NA_character_,
        MBSTRESN = NA_character_,
        MBSTRESU = NA_character_,
        stringsAsFactors = FALSE
    )
  }
  if (!is.null(geno)) {
    rbind(detection, geno)
  } else {
    detection
  }
}

process_eppsilometer <- function(
    ab, orres, orresu = "ug/dL", stres = orres, stresu = orresu, ab_resistance = FALSE
) {
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
    MSMETHOD = "E-TEST",
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

process_disk_diffusion <- function(
   ab, orres = 20, orresu = "mm", stres = orres, stresu = orresu, ab_resistance
) {
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
      MSSTRESC = MSORRES,
      MSSTRESN = NA_character_,
      MSSTRESU = NA_character_
    )
  rbind(res, conclusion)
}

process_naat_ms <- function(
    ab_genotype_list
) {
  for (ab in names(ab_gen_list)) {
    genotype <- ab_gen_list[[ab]]
    data.frame(
      DOMAIN = "MS",
      MSTEST = toupper(AMR::ab_name(ab)),
      MSTESTCD = toupper(as.character(ab)),
      MSTESTDTL = "GENOTYPE",
      MSORRES = genotype,
      MSSTRESC = genotype,
      MSMETHOD = "NUCLEIC ACID AMPLIFICATION TEST",
      MSRSLSCL = "Nom",
      MSORRESU = NA_character_,
      MSSTRESN = NA_character_,
      MSSTRESU = NA_character_,
      stringsAsFactors = FALSE
    )
  }
}

process_no_growth <- function() {
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
