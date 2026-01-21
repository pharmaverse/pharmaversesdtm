# This file only processes and saves the MS domain from that shared data source.
# Dataset: MS
# Description: A synthetic SDTM MS domain with susceptibility results
# and linkage to MB (mb.R) and BE (be.R) domains. Follows v3.4 CDISC SDTM standards.

# NOTE: To add or modify records in the MS domain, you must edit the data structure in 'mb.R'.
# All synthetic microbiology data (patients, specimens, results) are defined in 'mb.R'.

# Source synthetic data
source("data-raw/mb.R")

# Reorder columns according to CDISC SDTM MS standards (v3.4)
ms <- ms %>%
  select(
    STUDYID,
    DOMAIN,
    USUBJID,
    MSSEQ,
    MSREFID,
    NHOID,
    MSGRPID,
    MSLNKID,
    MSTESTCD,
    MSTEST,
    MSAGENT,
    MSCONC,
    MSCONCU,
    MSORRES,
    MSORRESU,
    MSSTRESC,
    MSSTRESN,
    MSSTRESU,
    MSSPEC,
    MSLOC,
    MSMETHOD,
    VISITNUM,
    MSDTC
  )

# Add variable labels
ms <- ms %>%
  set_variable_labels(
    STUDYID = "Study Identifier",
    DOMAIN = "Domain Abbreviation",
    USUBJID = "Unique Subject Identifier",
    MSSEQ = "Sequence Number",
    MSREFID = "Reference ID",
    NHOID = "Non-host Organism ID",
    MSGRPID = "Group ID",
    MSLNKID = "Link ID",
    MSTESTCD = "Short Name of Assessment",
    MSTEST = "Name of Assessment",
    MSAGENT = "Agent Name",
    MSCONC = "Agent Concentration",
    MSCONCU = "Agent Concentration Units",
    MSORRES = "Result or Finding in Original Units",
    MSORRESU = "Original Units",
    MSSTRESC = "Result or Finding in Standard Format",
    MSSTRESN = "Numeric Result/Finding in Standard Units",
    MSSTRESU = "Standard Units",
    MSSPEC = "Specimen Material Type",
    MSLOC = "Location Used for the Measurement",
    MSMETHOD = "Method of Test or Examination",
    VISITNUM = "Visit Number",
    MSDTC = "Date/Time of Collection"
  )

# Save dataset
usethis::use_data(ms, overwrite = TRUE)
