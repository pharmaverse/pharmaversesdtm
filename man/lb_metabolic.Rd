% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/lb_metabolic.R
\docType{data}
\name{lb_metabolic}
\alias{lb_metabolic}
\title{Laboratory Measurements Dataset-metabolic}
\format{
A data frame with 24 columns:
\describe{
\item{STUDYID}{Study Identifier}
\item{DOMAIN}{Domain Abbreviation}
\item{USUBJID}{Unique Subject Identifier}
\item{LBSEQ}{Sequence Number}
\item{LBTESTCD}{Lab Test or Examination Short Name}
\item{LBTEST}{Lab Test or Examination Name}
\item{LBCAT}{Category for Lab Test}
\item{LBORRES}{Result or Finding in Original Units}
\item{LBORRESU}{Original Units}
\item{LBORNRLO}{Reference Range Lower Limit in Orig Unit}
\item{LBORNRHI}{Reference Range Upper Limit in Orig Unit}
\item{LBSTRESC}{Character Result/Finding in Std Format}
\item{LBSTRESN}{Numeric Result/Finding in Standard Units}
\item{LBSTRESU}{Standard Units}
\item{LBSTNRLO}{Reference Range Lower Limit-Std Units}
\item{LBSTNRHI}{Reference Range Upper Limit-Std Units}
\item{LBNRIND}{Reference Range Indicator}
\item{LBBLFL}{Baseline Flag}
\item{LBFAST}{Fasting Status}
\item{VISITNUM}{Visit Number}
\item{VISIT}{Visit Name}
\item{VISITDY}{Planned Study Day of Visit}
\item{LBDTC}{Date/Time of Specimen Collection}
\item{LBDY}{Study Day of Specimen Collection}
}
}
\source{
Constructed by {admiralmetabolic} developers
}
\usage{
lb_metabolic
}
\description{
A SDTM LB dataset containing relevant laboratory measurements for metabolic studies
}
\details{
Laboratory Measurements Dataset-metabolic

A SDTM LB dataset containing relevant laboratory measurements for metabolic studies

Contains a set of 9 unique Test Short Names and Test Names: \tabular{ll}{
\strong{LBTESTCD} \tab \strong{LBTEST} \cr
ALB      \tab Albumin                   \cr
ALP      \tab Alkaline Phosphatase      \cr
AST      \tab Aspartate Aminotransferase\cr
CHOL     \tab Cholesterol               \cr
GGT      \tab Gamma Glutamyl Transferase\cr
GLUC     \tab Glucose                   \cr
HBA1CHGB \tab Hemoglobin A1C/Hemoglobin \cr
INSULIN  \tab Insulin                   \cr
TRIG     \tab Triglycerides
}
}
\keyword{dataset}
