% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rs_onco.R
\docType{data}
\name{rs_onco}
\alias{rs_onco}
\title{Disease Response for Oncology}
\format{
A data frame with 19 columns:
\describe{
\item{STUDYID}{Study Identifier}
\item{DOMAIN}{Domain Abbreviation}
\item{USUBJID}{Unique Subject Identifier}
\item{RSSEQ}{Sequence Number}
\item{RSLNKGRP}{Link Group}
\item{RSTESTCD}{Response Assessment Short Name}
\item{RSTEST}{Response Assessment Name}
\item{RSCAT}{Category for Response Assessment}
\item{RSORRES}{Response Assessment Original Result}
\item{RSSTRESC}{Response Assessment Result in Std Format}
\item{RSSTAT}{Completion Status}
\item{RSREASND}{Reason Response Assessment Not Performed}
\item{RSEVAL}{Evaluator}
\item{RSEVALID}{Evaluator Identifier}
\item{RSACPTFL}{Accepted Record Flag}
\item{VISITNUM}{Visit Number}
\item{VISIT}{Visit Name}
\item{RSDTC}{Date/Time of Response Assessment}
\item{RSDY}{Study Day of Response Assessment}
}
}
\source{
\href{https://github.com/pharmaverse/pharmaversesdtm/blob/main/data/tr_onco_recist.rda}{Access the source of the Disease Response for Oncology dataset.}
}
\usage{
rs_onco
}
\description{
A SDTM RS dataset simulated by Gopi Vegesna
}
\details{
Disease Response for Oncology

A SDTM RS dataset simulated by Gopi Vegesna

Contains a set of 4 unique Test Short Names and Test Names: \tabular{ll}{
\strong{RSTESTCD} \tab \strong{RSTEST} \cr
NEWLPROG \tab New Lesion Progression\cr
NTRGRESP \tab Non-target Response   \cr
OVRLRESP \tab Overall Response      \cr
TRGRESP  \tab Target Response
}
}
\author{
Gopi Vegesna
}
\keyword{dataset}
