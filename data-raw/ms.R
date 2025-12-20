# Dataset: MS
# Description: A synthetic SDTM MS domain with susceptibility results
# and linkage to MB domain (mb).

# Load libraries -----
library(dplyr)
library(tidyselect)
library(labelled)

# Example subjects, organisms, antibiotics, and labs
studyid <- "MIC"
subjects <- paste0(studyid, "-", c("001", "002", "003"))

# Define each of the samples collected for each subject
# First subject: two urine samples (Enterococcus faecalis)
# Second and third subjects: two skin tissue samples each (Staphylococcus aureus)
samples_table <- data.frame(
  STUDYID = rep(studyid, 6),
  USUBJID = c(rep(subjects[1], 2), rep(subjects[2], 2), rep(subjects[3], 2)),
  MSSPEC = c(rep("URINE", 2), rep("SKIN TISSUE", 4)),
  MSLOC = c(rep("URINARY SYSTEM", 2), rep("SKIN OF THE AXILLA", 4)),
  NHOID = c(rep("ENTEROCOCCUS FAECALIS", 2), rep("STAPHYLOCOCCUS AUREUS", 4)),
  VISITNUM = rep(c(1, 2), 3),
  # Define an arbitrary base resistance per sample for variability
  base_resistance = c(0.3, 0.7, 1, 1, 0, 0)
)
samples_table$MSREFID <- paste0(samples_table$MSSPEC, "-", samples_table$VISITNUM)
samples_table$MSGRPID <- paste0(samples_table$MSSPEC, "-", samples_table$VISITNUM, "-", samples_table$NHOID)
samples_table$MSLNKGRP <- paste0("LNKGRP-", samples_table$USUBJID, "-", samples_table$NHOID)


# Treatments table with breakpoints
treatments <- data.frame(
	NHOID = c("ENTEROCOCCUS FAECALIS", "STAPHYLOCOCCUS AUREUS", "STAPHYLOCOCCUS AUREUS", "STAPHYLOCOCCUS AUREUS"),
	MSTESTCD = c("AMX", "CIP", "CIP", "VAN"),
	MSMETHOD = c("E-TEST", "DISK DIFFUSION", "E-TEST", "E-TEST"),
	disk_dose = c(NA, "5 mcg", NA, NA),
	S_breakpoint = c(0.0001, 39, 0.38, 2),
	R_breakpoint = c(4, 20, 1.2, 9.5),
	MSTEST = c("Amoxicillin", "Ciprofloxacin", "Ciprofloxacin", "Vancomycin"),
	MSCAT = c("SUSCEPTIBILITY", "SUSCEPTIBILITY", "SUSCEPTIBILITY", "SUSCEPTIBILITY"),
	stringsAsFactors = FALSE
)

# Helper function to generate results per sample, using base resistance and breakpoints
calculate_susceptibility_finding <- function(treatment_row, base_resistance) {
  S_bp <- treatment_row$S_breakpoint
  R_bp <- treatment_row$R_breakpoint
  method <- treatment_row$MSMETHOD

  if (method == "E-TEST") {
    val <- S_bp + (R_bp - S_bp) * base_resistance
    val <- round(val, 3)
    sus <- if (val <= S_bp) "SUSCEPTIBLE" else if (val >= R_bp) "RESISTANT" else "INTERMEDIATE"
    return(list(MSCONC = val, MSCONCU = "ug/mL", MSORRES = as.character(val), MSORRESU = "ug/mL", MSSTRESC = sus, MSSTRESN = val, MSSTRESU = "ug/mL"))
  } else if (method == "DISK DIFFUSION") {
    val <- S_bp + (R_bp - S_bp) * (1 - base_resistance)
    val <- round(val, 2)
    sus <- if (val >= S_bp) "SUSCEPTIBLE" else if (val <= R_bp) "RESISTANT" else "INTERMEDIATE"
    return(list(MSCONC = val, MSCONCU = "mm", MSORRES = as.character(val), MSORRESU = "mm", MSSTRESC = sus, MSSTRESN = val, MSSTRESU = "mm"))
  } else {
    return(list(MSCONC = NA, MSCONCU = NA, MSORRES = NA, MSORRESU = NA, MSSTRESC = NA, MSSTRESN = NA, MSSTRESU = NA))
  }
}

# Build MS dataset with correct keys and linking variables
set.seed(123)
seqnum <- 1
ms <- list()

for (i in seq_len(nrow(samples_table))) {
	sample <- samples_table[i,]
	mslnkid <- paste0("LNK-", sample$USUBJID)
	# Subset treatments for this sample's NHOID
	available_treatments <- treatments[treatments$NHOID == sample$NHOID, ]
	for (j in seq_len(nrow(available_treatments))) {
		treatment <- available_treatments[j,]
		res <- calculate_susceptibility_finding(
			treatment,
			sample$base_resistance
		)
		ms[[length(ms) + 1]] <- data.frame(
			STUDYID = sample$STUDYID,
			DOMAIN = "MS",
			USUBJID = sample$USUBJID,
			NHOID = sample$NHOID,
			MSSPEC = sample$MSSPEC,
			MSLOC = sample$MSLOC,
			MSGRPID = sample$MSGRPID,
			MSSEQ = seqnum,
			MSREFID = sample$MSREFID,
			MSLNKID = mslnkid,
			MSLNKGRP = sample$MSLNKGRP,
			MSTESTCD = treatment$MSTESTCD,
			MSTEST = treatment$MSTEST,
			MSCAT = treatment$MSCAT,
			MSCONC = res$MSCONC,
			MSCONCU = res$MSCONCU,
			MSORRES = res$MSORRES,
			MSORRESU = res$MSORRESU,
			MSSTRESC = res$MSSTRESC,
			MSSTRESN = res$MSSTRESN,
			MSSTRESU = res$MSSTRESU,
			MSMETHOD = treatment$MSMETHOD,
			MSDTC = paste0("2005-06-", 19 + (seqnum %% 10), "T08:00"),
			VISITNUM = sample$VISITNUM,
			stringsAsFactors = FALSE
		)
		seqnum <- seqnum + 1
	}
}

ms <- dplyr::bind_rows(ms)
# Reassign MSSEQ: for each subject, MSSEQ is 1 to n (number of samples for that subject)
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
		MSREFID,
		MSLNKID,
		MSLNKGRP,
		NHOID,
		MSSPEC,
		MSTESTCD,
		MSTEST,
		MSCAT,
		MSCONC,
		MSCONCU,
		MSORRES,
		MSORRESU,
		MSSTRESC,
		MSSTRESN,
		MSSTRESU,
		MSMETHOD,
		MSDTC,
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
		MSREFID = "Reference ID",
		MSLNKID = "Link ID",
		MSLNKGRP = "Link Group ID",
		NHOID = "Non-host Organism ID",
		MSSPEC = "Specimen Type",
		MSTESTCD = "Short Name of Assessment",
		MSTEST = "Name of Assessment",
		MSCAT = "Category of Assessment",
		MSCONC = "Agent Concentration",
		MSCONCU = "Agent Concentration Units",
		MSORRES = "Result or Finding in Original Units",
		MSORRESU = "Original Units",
		MSSTRESC = "Result or Finding in Standard Format",
		MSSTRESN = "Numeric Result/Finding in Standard Units",
		MSSTRESU = "Standard Units",
		MSMETHOD = "Method of Test or Examination",
		MSDTC = "Date/Time of Specimen Collection",
		VISITNUM = "Visit Number"
	)

# Save dataset
usethis::use_data(ms, overwrite = TRUE)

## Note: Clinical breakpoints were derived from the AMR package
## (Reference: )
## using the next commented R code:
##
## treatments <- AMR::clinical_breakpoints %>%
##   dplyr::filter(
##     ab %in% AMR::as.ab(c("Amoxicillin", "Ciprofloxacin", "Vancomycin")),
##     method %in% c("MIC", "DISK"),
##     mo %in% AMR::as.mo(c("Enterococcus faecalis", "Staphylococcus aureus")),
##     host == "human"
##   ) %>%
##   group_by(mo, ab, method, disk_dose) %>%
##   summarise(
##     S_breakpoint = signif(mean(breakpoint_S, na.rm = TRUE), 2),
##     R_breakpoint = signif(mean(breakpoint_R, na.rm = TRUE), 2)
##   ) %>%
##   ungroup() %>%
##   rename(
##     NHOID = mo,
##     MSTESTCD = ab,
##     MSMETHOD = method
##   ) %>%
##   as.data.frame() %>%
##   mutate(
##     MSTEST = recode(MSTESTCD, AMX = "Amoxicillin", CIP = "Ciprofloxacin", VAN = "Vancomycin"),
##     MSMETHOD = recode(MSMETHOD, MIC = "E-TEST", DISK = "DISK DIFFUSION"),
##     NHOID = recode(NHOID, ENTRC_FCLS = "ENTEROCOCCUS FAECALIS", STPFY_AURS = "STAPHYLOCOCCUS AUREUS")
##   )
