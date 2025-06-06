% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rs_onco_imwg.R
\docType{data}
\name{rs_onco_imwg}
\alias{rs_onco_imwg}
\title{Disease Response (IMWG)}
\format{
A data frame with 17 columns:
\describe{
\item{STUDYID}{Study Identifier}
\item{DOMAIN}{Domain Abbreviation}
\item{USUBJID}{Unique Subject Identifier}
\item{RSSEQ}{Sequence Number}
\item{RSLNKGRP}{Link Group ID}
\item{RSTESTCD}{Assessment Short Name}
\item{RSTEST}{Assessment Name}
\item{RSCAT}{Category for Assessment}
\item{RSORRES}{Result or Finding in Original Units}
\item{RSSTRESC}{Character Result/Finding in Std Format}
\item{RSSTAT}{Completion Status}
\item{RSREASND}{Reason Not Done}
\item{RSEVAL}{Evaluator}
\item{VISITNUM}{Visit Number}
\item{VISIT}{Visit Name}
\item{RSDTC}{Date/Time of Assessment}
\item{RSDY}{Study Day of Assessment}
}
}
\source{
Derived from tr_onco_recist
}
\usage{
rs_onco_imwg
}
\description{
A SDTM RS dataset using IMWG criteria intended for examples of ADaM dataset creation
}
\details{
Disease Response (IMWG)

A SDTM RS dataset using IMWG criteria intended for examples of ADaM dataset creation

Contains a set of 1 unique Test Short Name and Test Name: \tabular{ll}{
\strong{RSTESTCD} \tab \strong{RSTEST} \cr
OVRLRESP \tab Overall Response
}
}
\author{
Vinh Nguyen
}
\keyword{dataset}
