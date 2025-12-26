# This file only processes and saves the BE domain from that shared data source.
# Dataset: BE
# A synthetic SDTM BE domain representing specimen collection, aliquoting
# and culturing events with linkage to MB (mb) and MS (ms) domains

# NOTE: To add or modify records in the BE domain, you must edit the data structure in 'mb.R'.
# All synthetic microbiology data (patients, specimens, results) are defined in 'mb.R'.

# Source microbiology synthetic data
source("data-raw/mb.R")

be <- be %>%
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

# Save dataset
usethis::use_data(be, overwrite = TRUE, internal = FALSE)
