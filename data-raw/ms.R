# Dataset: ms
# Description: A synthetic SDTM MS domain with susceptibility results
# and linkage to MB domain (mb).

# Load libraries -----
library(dplyr)
library(tidyselect)

# Example subjects, organisms, antibiotics, and labs
studyid <- "MIC"
subjects <- paste0(studyid, "-", c("001", "002", "003"))

# Treatments table: SDTM-compliant MSTESTCD, MSTEST, MSTEST, MSMETHOD, MSCAT
treatments_table <- data.frame(
  MSTESTCD = c(
    "AMX", "AMX", "CIP", "CIP", "VAN", "VAN"
  ),
  MSTEST = c(
    "Amoxicillin", "Amoxicillin", "Ciprofloxacin", "Ciprofloxacin", "Vancomycin", "Vancomycin"
  ),
  MSMETHOD = c(
    "E-TEST", "DISK DIFFUSSION", "E-TEST", "DISK DIFFUSION", "E-TEST", "DISK DIFFUSION"
  ),
  MSCAT = rep("SUSCEPTIBILITY", 6),
  stringsAsFactors = FALSE
)

# Define each of the samples collected for each subject
samples_table <- data.frame(
    STUDYID = rep(studyid, each = 6),
	USUBJID = rep(subjects, each = 2),
    MSSPEC = rep(c("URINE", "SKIN TISSUE"), times = length(subjects)),
    NHOID = rep(c("ENTEROCOCCUS FAECALIS", "STAPHYLOCOCCUS AUREUS"), times = length(subjects)),
	VISITNUM = rep(c(1, 2), times = length(subjects)),
	NHOID = rep(organisms, length.out = 6),
	MSLNKGRP = paste0("GRP-", rep(subjects, each = 2), "-", rep(organisms, length.out = 6)),

    # Define an arbitrary base resistance per sample for variability
    base_resistance = c(0, 0, 1, 0.5, 0, 1)
)
samples_table$MSREFID <- paste0(samples_table$MSSPEC, "-", samples_table$VISITNUM)
samples_table$MSGRPID <- paste0(samples_table$MSSPEC, "-", samples_table$VISITNUM, "-", samples_table$NHOID)


# Clinical breakpoints table for agent/method combinations
breakpoints <- data.frame(
	NHOID = c(
		"ENTEROCOCCUS FAECALIS", "ENTEROCOCCUS FAECALIS", "CIP", "CIP", "VAN", "VAN",
		"STAPHYLOCOCCUS AUREUS", "STAPHYLOCOCCUS AUREUS", "CIP", "CIP", "VAN", "VAN"
	),
	MSTEST = c(
		"Amoxicillin", "Amoxicillin", "Ciprofloxacin", "Ciprofloxacin", "Vancomycin", "Vancomycin",
		"Amoxicillin", "Amoxicillin", "Ciprofloxacin", "Ciprofloxacin", "Vancomycin", "Vancomycin"
	),
	MSMETHOD = c(
		"E-TEST", "DISK DIFFUSION", "E-TEST", "DISK DIFFUSION", "E-TEST", "DISK DIFFUSION",
		"E-TEST", "DISK DIFFUSION", "E-TEST", "DISK DIFFUSION", "E-TEST", "DISK DIFFUSION"
	),
	S_breakpoint = c(0.0001, 14.75, 4, 14.75, 4, 11, 0.5, 31.8, 0.6, 19, 2, 11),
	R_breakpoint = c(4, 14.75, 4, 14.75, 4, 11, 0.5, 19, 1.2, 19, 8.7, 11),
	stringsAsFactors = FALSE
)

# Helper function to generate results per sample, using base resistance and breakpoints
calculate_susceptibility_finding <- function(agent, method, base_resistance, org) {
	# Use MSTESTCD for agent lookup in breakpoints
	bp_sample <- breakpoints[breakpoints$NHOID == org & breakpoints$MSTEST == agent & breakpoints$MSMETHOD == method, ]
	# Ensure S_bp and R_bp are scalars
	if (nrow(bp_sample) > 0) {
		S_bp <- bp_sample$S_breakpoint[1]
		R_bp <- bp_sample$R_breakpoint[1]
	} else {
		S_bp <- 1
		R_bp <- 4
	}
	# E-TEST = MIC, DISK DIFFUSION = disk
	if (method == "E-TEST") {
		val <- S_bp + (R_bp - S_bp) * base_resistance
		val <- round(val, 3)
		sus <- if (val <= S_bp) "SUSCEPTIBLE" else if (val >= R_bp) "RESISTANT" else "INTERMEDIATE"
		return(list(MSCONC = val, MSCONCU = "ug/dL", MSORRES = as.character(val), MSORRESU = "ug/dL", MSSTRESC = sus, MSSTRESN = val, MSSTRESU = "ug/dL"))
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
	for (j in seq_len(nrow(treatments_table))) {
		treatment <- treatments_table[j,]
		res <- calculate_susceptibility_finding(
			treatment$MSTEST,
			treatment$MSMETHOD,
			sample$base_resistance,
			sample$NHOID
		)
		ms[[length(ms) + 1]] <- data.frame(
			STUDYID = sample$STUDYID,
			DOMAIN = "MS",
			USUBJID = sample$USUBJID,
			NHOID = sample$NHOID,
            MSSPEC = sample$MSSPEC,
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
