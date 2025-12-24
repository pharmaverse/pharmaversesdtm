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
              methods = list(
                MB = list(
                    `GRAM STAIN` = list(test = "Gram Negative Cocci", count = "2+"),
                    `COLONY COUNT` = list(orres = 100, orresu = "CFU/mL", stres = 100, stresu = "CFU/mL"),
                    `NUCLEIC ACID AMPLIFICATION TEST` = list(
                        testcd = "GENE1",
                        genotype = list(TEST = "Complex", TESTCD = "CMPLX")
                    )
                ),
                MS = list(
                    `EPSILOMETER` = list(
                        "PENICILLIN" = list(ORRES = 0.25, ORRESU = "ug/dL", STRES = 0.25, STRESU = "ug/dL")
                    ),
                    `DISK DIFFUSION` = list(
                        "VANCOMYCIN" = list(ORRES = 15, ORRESU = "mm", STRES = 15, STRESU = "mm"),
                        "PENICILLIN" = list(ORRES = 20, ORRESU = "mm", STRES = 20, STRESU = "mm")
                    ),
                    `NUCLEIC ACID AMPLIFICATION TEST` = list(
                        PENICILLIN = "GENE1",
                        VANCOMYCIN = "GENE2"
                    )
                )
              )
            ),
            "3" = list(
              organism = "KLEBSIELLA PNEUMONIAE",
              resistance_ab = "",
              aliquot_preparation_dt = "2025-06-15T09:45",
              culture_start_dt = "2025-06-15T11:00",
              culture_end_dt = "2025-06-30T11:00",
              methods = list(
                MB = list(
                    `GRAM STAIN` = list(testcd = "Gram Negative Rods")
                ),
                MS = list(
                    `EPSILOMETER` = list(
                        "CIPROFLOXACIN" = list(ORRES = 0.5, ORRESU = "ug/dL", STRES = 0.5, STRESU = "ug/dL")
                    ) 
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
                  methods = list(
                    MB = list(
                      `GRAM STAIN` = list(test = "Gram Negative Rods"),
                      `COLONY COUNT` = list(orres = 500, orresu = "CFU/mL", stres = 500, stresu = "CFU/mL")
                    ),
                    MS = list(
                      `EPSILOMETER` = list(
                          "CIPROFLOXACIN" = list(ORRES = 4, ORRESU = "ug/dL", STRES = 4, STRESU = "ug/dL"),
                          "AMOXICILLIN/CLAVULANATE" = list(ORRES = 16, ORRESU = "ug/dL", STRES = 16, STRESU = "ug/dL"),
                          "CEFTAZIDIME" = list(ORRES = 8, ORRESU = "ug/dL", STRES = 8, STRESU = "ug/dL")
                      )
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
                    methods = list(
                      MB = list(
                          `GRAM STAIN` = list(test = "Gram Positive Cocci", count = "3+"),
                          `COLONY COUNT` = list(orres = 200, orresu = "CFU/mL", stres = 200, stresu = "CFU/mL")
                      ),
                      MS = list(
                          `DISK DIFFUSION` = list(
                              "AMOXICILLIN" = list(ORRES = 8, ORRESU = "mm", STRES = 8, STRESU = "mm")
                          )
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
                    methods = list(
                      MB = list(),
                      MS = list(
                          `DISK DIFFUSION` = list(
                              "AMOXICILLIN" = list(ORRES = 10, ORRESU = "mm", STRES = 10, STRESU = "mm")
                          )
                      )
                    )
                )
            )
        )
    )
    # Patient 3: organism identified with infection and multidrug resistance
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

    usubjid <- paste0(studyid, sprintf("%02d", as.integer(subjid)))
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

        be <- rbind(
            be,
            data.frame(
                STUDYID = studyid,
                DOMAIN = "BE",
                USUBJID = usubjid,
                BESEQ = beseq,
                BEREFID = spec_nr,
                BETERM = "Collecting",
                BECAT = "COLLECTION",
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
                    BEDTC = collection_date,
                    BESTDTC = bestdtc_cult,
                    BEENDTC = beendtc_cult
                )
            )
            beseq <- beseq + 1

            for (d in seq_len(length(aliquot_info$methods))) {
                domain <- names(aliquot_info$methods)[d]
                methods <- aliquot_info$methods[[domain]]

              for (m in seq_len(length(methods))) {
                  method <- names(methods)[m]
                  method_info <- methods[[m]]

                  # Process each test_info as needed to create MB/MS records
                  if (domain == "MB") {
                    mbseq <- mbseq + 1
                    fun_results <- switch(
                      method,
                      `GRAM STAIN` = process_mb_gram_stain,
                      `COLONY COUNT` = process_colony_count,
                      `NUCLEIC ACID AMPLIFICATION TEST` = process_naat,
                      `EPSILOMETER` = process_eppsilometer,
                      `DISK DIFFUSION` = process_disk_diffusion,
                      next()
                    )
                    res <- do.call(fun_results, method_info) %>%
                      mutate(
                        STUDYID = studyid,
                        USUBJID = usubjid,
                        MBSEQ = mbseq,
                        MBREFID = aliquot_id,
                        MBLNKGRP = culture_id,
                        MBSPEC = spec,
                        MBLOC = specloc,
                        MBDTC = collection_date,
                        VISITNUM = as.integer(as.factor(collection_date)),
                        VISIT = paste0("Visit ", VISITNUM),
                      )
                    mb <- bind_rows(mb, res) 
                  } else if (domain == "MS") {
                    msseq <- msseq + 1
                    fun_results <- switch(
                      method,
                      `EPSILOMETER` = process_eppsilometer,
                      `DISK DIFFUSION` = process_disk_diffusion,
                      `NUCLEIC ACID AMPLIFICATION TEST` = process_naat_ms,
                      next()
                    )
                    res <- do.call(fun_results, method_info)
                    res <- res %>%
                      mutate(
                        STUDYID = studyid,
                        USUBJID = usubjid,
                        NHOID = nhoid,
                        MSSEQ = msseq,
                        MBREFID = aliquot_id,
                        MSLNKID = culture_id,
                        MSSPEC = spec,
                        MSLOC = specloc,
                        MSDTC = collection_date,
                        NHOID = nhoid,
                        VISITNUM = as.integer(as.factor(collection_date)),
                        VISIT = paste0("Visit ", VISITNUM),
                      )
                    ms <- bind_rows(ms, res)
                  }
              }
        }
    }
}

# Helper function: process GRAM STAIN for MB domain (CDISC v3.4)
process_mb_gram_stain <- function(
    test, count = NULL
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
    MBORRES = "PRESENT",
    MBSTRESC = "PRESENT",
    MBMETHOD = "GRAM STAIN",
    MBRSLSCL = "Ord", # Determines if the operation is ordinal, nominal or quantitative
    MBORRESU = NA,
    MBSTRESN = NA,
    stringsAsFactors = FALSE
  )
  # Quantification record (if count provided)
  quant <- NULL
  if (!is.null(count)) {
    quant <- data.frame(
        DOMAIN = "MB",
        MBTEST = detection$MBTEST,
        MBTESTCD = detection$MBTESTCD,
        MBTSTDTL = "QUANTIFICATION",
        MBORRES = count,
        MBSTRESC = count,
        MBMETHOD = "GRAM STAIN",
        MBRSLSCL = "Ord",
        MBORRESU = "Semi-quantitative",
        MBSTRESN = switch(
            count,
            "1+" = 1,
            "2+" = 2,
            "3+" = 3,
            "4+" = 4,
            NA_real_
        ),
        stringsAsFactors = FALSE
    )
  }
  if (!is.null(quant)) {
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
    MBORRES = orres,
    MBSTRESC = if (!is.null(stres) && !is.na(stres)) as.character(stres) else as.character(orres),
    MBMETHOD = "COLONY COUNT",
    MBRSLSCL = "Quant",
    MBORRESU = if (!is.null(orresu) && !is.na(orresu)) orresu else "CFU/mL",
    MBSTRESN = if (!is.null(stresu) && !is.na(stresu)) stresu else orresu,
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
    MBORRESU = NA,
    MBSTRESN = NA,
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
        MBORRES = genotype$TEST,
        MBSTRESC = genotype$TEST,
        MBMETHOD = "NUCLEIC ACID AMPLIFICATION TEST",
        MBRSLSCL = "Nom",
        MBORRESU = NA,
        MBSTRESN = NA,
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
    ab, orres, orresu = NULL, stres = NULL, stresu = NULL
) {
  data.frame(
    DOMAIN = "MS",
    MSTEST = toupper(AMR::ab_name(ab)),
    MSTESTCD = toupper(as.character(ab)),
    MSTESTDTL = "QUANTIFICATION",
    MSORRES = orres,
    MSSTRESC = if (!is.null(stres) && !is.na(stres)) as.character(stres) else as.character(orres),
    MSMETHOD = "E-TEST",
    MSRSLSCL = "Quant",
    MSORRESU = if (!is.null(orresu) && !is.na(orresu)) orresu else "ug/dL",
    MSSTRESN = if (!is.null(stres) && !is.na(stres)) stres else orres,
    MSSTRESU = stresu,
    stringsAsFactors = FALSE
  )
}

process_disk_diffusion <- function(
    ab, orres, orresu = NULL, stres = NULL, stresu = NULL
) {
  data.frame(
    DOMAIN = "MS",
    MSTEST = toupper(AMR::ab_name(ab)),
    MSTESTCD = toupper(as.character(ab)),
    MSTESTDTL = "QUANTIFICATION",
    MSORRES = orres,
    MSSTRESC = if (!is.null(stres) && !is.na(stres)) as.character(stres) else as.character(orres),
    MSMETHOD = "DISK DIFFUSION",
    MSRSLSCL = "Quant",
    MSORRESU = if (!is.null(orresu) && !is.na(orresu)) orresu else "mm",
    MSSTRESN = if (!is.null(stres) && !is.na(stres)) stres else orres,
    MSSTRESU = stresu,
    stringsAsFactors = FALSE
  )
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
      MSORRESU = NA,
      MSSTRESN = NA,
      stringsAsFactors = FALSE
    )
  }
}