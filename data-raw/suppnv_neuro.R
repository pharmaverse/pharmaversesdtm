# Dataset: suppnv_neuro
# Description: Create SUPPNV test SDTM dataset for Alzheimer's Disease (neuro studies)

#' @importFrom dplyr filter mutate select case_when
#' @importFrom admiral convert_blanks_to_na
#' @importFrom usethis use_data
#' @noRd

# Read input data ----

data("nv_neuro")

# Convert blank to NA ----

nv_neuro <- admiral::convert_blanks_to_na(nv_neuro)

suppnv_neuro <- nv_neuro |>
  dplyr::filter(!is.na(NVLOC)) |>
  dplyr::mutate(
    RDOMAIN = "NV", IDVAR = "NVSEQ", IDVARVAL = NVSEQ, QNAM = "REFREG",
    QLABEL = "Reference Region"
  ) |>
  dplyr::mutate(QVAL = dplyr::case_when(
    NVCAT %in% c("FBP", "FBB") ~ "Whole Cerebellum",
    NVCAT == "FTP" ~ "Inferior Cerebellar Gray Matter",
    TRUE ~ NA_character_
  )) |>
  dplyr::mutate(QORIG = "Assigned", QEVAL = "STATISTICIAN") |>
  dplyr::select(STUDYID, RDOMAIN, USUBJID, IDVAR, IDVARVAL, QNAM, QLABEL, QVAL, QORIG, QEVAL)

# Add labels to variables ----

labels <- list(
  STUDYID = "Study Identifier",
  RDOMAIN = "Related Domain Abbreviation",
  USUBJID = "Unique Subject Identifier",
  IDVAR = "Identifying Variable",
  IDVARVAL = "Identifying Variable Value",
  QNAM = "Qualifier Variable Name",
  QLABEL = "Qualifier Variable Label",
  QVAL = "Data Value",
  QORIG = "Origin",
  QEVAL = "Evaluator"
)

for (var in names(labels)) {
  attr(suppnv_neuro[[var]], "label") <- labels[[var]]
}

# Label SUPPNV dataset ----

attr(suppnv_neuro, "label") <- "Supplemental Qualifiers for Nervous System Findings"

# Save dataset ----

usethis::use_data(suppnv_neuro, overwrite = TRUE)
