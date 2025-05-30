# This file is automatically generated by data-raw/create_sdtms_data.R.
# For updating it please edit inst/extdata/sdtms-specs.json and rerun create_sdtms_data.R.
# Manual edits are not recommended, as changes may be overwritten.
#' Immunogenicity Specimen Assessments for Vaccine
#'
#' An example SDTM IS for vaccine studies
#'
#' @name is_vaccine
#' @title Immunogenicity Specimen Assessments for Vaccine
#' @keywords dataset
#' @description An example SDTM IS for vaccine studies
#' @docType data
#' @format A data frame with 24 columns:
#'   \describe{
#'     \item{STUDYID}{Study Identifier}
#'     \item{DOMAIN}{Domain Abbreviation}
#'     \item{USUBJID}{Unique Subject Identifier}
#'     \item{ISSEQ}{Sequence Number}
#'     \item{ISTESTCD}{Immunogenicity Test/Exam Short Name}
#'     \item{ISTEST}{Immunogenicity Test or Exam Name}
#'     \item{ISCAT}{Category for Immunogenicity Test}
#'     \item{ISORRES}{Result or Finding in Original Units}
#'     \item{ISORRESU}{Original Units}
#'     \item{ISSTRESC}{Character Result/Finding in Std Format}
#'     \item{ISSTRESN}{Numeric Result/Finding in Standard Units}
#'     \item{ISSTRESU}{Standard Units}
#'     \item{ISSTAT}{Completion Status}
#'     \item{ISREASND}{Reason Not Done}
#'     \item{ISNAM}{Vendor Name}
#'     \item{ISSPEC}{Specimen Type}
#'     \item{ISMETHOD}{Method of Test or Examination}
#'     \item{ISBLFL}{Baseline Flag}
#'     \item{ISLLOQ}{Lower Limit of Quantitation}
#'     \item{VISITNUM}{Visit Number}
#'     \item{EPOCH}{Epoch}
#'     \item{ISDTC}{Date/Time of Collection}
#'     \item{ISDY}{Study Day of Collection}
#'     \item{ISULOQ}{Upper Limit of Quantitation}
#'   }
#'
#' @source Constructed by {admiralvaccine} developers
#' @details Contains a set of 4 unique Test Short Names and Test Names: \tabular{ll}{
#'   \strong{ISTESTCD} \tab \strong{ISTEST} \cr
#'   I0019NT \tab I0019NT Antibody\cr
#'   J0033VN \tab J0033VN Antibody\cr
#'   M0019LN \tab M0019LN Antibody\cr
#'   R0003MA \tab R0003MA Antibody
#' }

"is_vaccine"
