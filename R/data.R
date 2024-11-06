#' Adverse Events
#'
#' An updated SDTM AE dataset that uses the CDISC pilot project
#'
#' @name ae
#' @docType data
#' @format A data frame with 35 columns:
#'   \describe{
#'     \item{ STUDYID }{Study Identifier}
#'     \item{ DOMAIN }{Domain Abbreviation}
#'     \item{ USUBJID }{Unique Subject Identifier}
#'     \item{ AESEQ }{Sequence Number}
#'     \item{ AESPID }{Sponsor-Defined Identifier}
#'     \item{ AETERM }{Reported Term for the Adverse Event}
#'     \item{ AELLT }{Lowest Level Term}
#'     \item{ AELLTCD }{Lowest Level Term Code}
#'     \item{ AEDECOD }{Dictionary-Derived Term}
#'     \item{ AEPTCD }{Preferred Term Code}
#'     \item{ AEHLT }{High Level Term}
#'     \item{ AEHLTCD }{High Level Term Code}
#'     \item{ AEHLGT }{High Level Group Term}
#'     \item{ AEHLGTCD }{High Level Group Term Code}
#'     \item{ AEBODSYS }{Body System or Organ Class}
#'     \item{ AEBDSYCD }{Body System or Organ Class Code}
#'     \item{ AESOC }{Primary System Organ Class}
#'     \item{ AESOCCD }{Primary System Organ Class Code}
#'     \item{ AESEV }{Severity/Intensity}
#'     \item{ AESER }{Serious Event}
#'     \item{ AEACN }{Action Taken with Study Treatment}
#'     \item{ AEREL }{Causality}
#'     \item{ AEOUT }{Outcome of Adverse Event}
#'     \item{ AESCAN }{Involves Cancer}
#'     \item{ AESCONG }{Congenital Anomaly or Birth Defect}
#'     \item{ AESDISAB }{Persist or Signif Disability/Incapacity}
#'     \item{ AESDTH }{Results in Death}
#'     \item{ AESHOSP }{Requires or Prolongs Hospitalization}
#'     \item{ AESLIFE }{Is Life Threatening}
#'     \item{ AESOD }{Occurred with Overdose}
#'     \item{ AEDTC }{Date/Time of Collection}
#'     \item{ AESTDTC }{Start Date/Time of Adverse Event}
#'     \item{ AEENDTC }{End Date/Time of Adverse Event}
#'     \item{ AESTDY }{Study Day of Start of Adverse Event}
#'     \item{ AEENDY }{Study Day of End of Adverse Event}
#'   }
#'
#' @source \url{https://github.com/pharmaverse/pharmaversesdtm/blob/main/data/ae.rda}
"ae"

#' Adverse Events for Ophthalmology
#'
#' An example Adverse Events SDTM dataset with ophthalmology-specific variable `AELAT`
#'
#' @name ae_ophtha
#' @docType data
#' @format A data frame with 36 columns:
#'   \describe{
#'     \item{ STUDYID }{Study Identifier}
#'     \item{ DOMAIN }{Domain Abbreviation}
#'     \item{ USUBJID }{Unique Subject Identifier}
#'     \item{ AESEQ }{Sequence Number}
#'     \item{ AESPID }{Sponsor-Defined Identifier}
#'     \item{ AETERM }{Reported Term for the Adverse Event}
#'     \item{ AELLT }{Lowest Level Term}
#'     \item{ AELLTCD }{Lowest Level Term Code}
#'     \item{ AEDECOD }{Dictionary-Derived Term}
#'     \item{ AEPTCD }{Preferred Term Code}
#'     \item{ AEHLT }{High Level Term}
#'     \item{ AEHLTCD }{High Level Term Code}
#'     \item{ AEHLGT }{High Level Group Term}
#'     \item{ AEHLGTCD }{High Level Group Term Code}
#'     \item{ AEBODSYS }{Body System or Organ Class}
#'     \item{ AEBDSYCD }{Body System or Organ Class Code}
#'     \item{ AESOC }{Primary System Organ Class}
#'     \item{ AESOCCD }{Primary System Organ Class Code}
#'     \item{ AESEV }{Severity/Intensity}
#'     \item{ AESER }{Serious Event}
#'     \item{ AEACN }{Action Taken with Study Treatment}
#'     \item{ AEREL }{Causality}
#'     \item{ AEOUT }{Outcome of Adverse Event}
#'     \item{ AESCAN }{Involves Cancer}
#'     \item{ AESCONG }{Congenital Anomaly or Birth Defect}
#'     \item{ AESDISAB }{Persist or Signif Disability/Incapacity}
#'     \item{ AESDTH }{Results in Death}
#'     \item{ AESHOSP }{Requires or Prolongs Hospitalization}
#'     \item{ AESLIFE }{Is Life Threatening}
#'     \item{ AESOD }{Occurred with Overdose}
#'     \item{ AEDTC }{Date/Time of Collection}
#'     \item{ AESTDTC }{Start Date/Time of Adverse Event}
#'     \item{ AEENDTC }{End Date/Time of Adverse Event}
#'     \item{ AESTDY }{Study Day of Start of Adverse Event}
#'     \item{ AEENDY }{Study Day of End of Adverse Event}
#'     \item{ AELAT }{Laterality}
#'   }
#'
#' @source Constructed using `ae` from the `{pharmaversesdtm}` package.
"ae_ophtha"

#' Concomitant Medication
#'
#' A SDTM CM dataset from the CDISC pilot project
#'
#' @name cm
#' @docType data
#' @format A data frame with 21 columns:
#'   \describe{
#'     \item{ STUDYID }{Study Identifier}
#'     \item{ DOMAIN }{Domain Abbreviation}
#'     \item{ USUBJID }{Unique Subject Identifier}
#'     \item{ CMSEQ }{Sequence Number}
#'     \item{ CMSPID }{Sponsor-Defined Identifier}
#'     \item{ CMTRT }{Reported Name of Drug, Med, or Therapy}
#'     \item{ CMDECOD }{Standardized Medication Name}
#'     \item{ CMINDC }{Indication}
#'     \item{ CMCLAS }{Medication Class}
#'     \item{ CMDOSE }{Dose per Administration}
#'     \item{ CMDOSU }{Dose Units}
#'     \item{ CMDOSFRQ }{Dosing Frequency per Interval}
#'     \item{ CMROUTE }{Route of Administration}
#'     \item{ VISITNUM }{Visit Number}
#'     \item{ VISIT }{Visit Name}
#'     \item{ VISITDY }{Planned Study Day of Visit}
#'     \item{ CMDTC }{Date/Time of Collection}
#'     \item{ CMSTDTC }{Start Date/Time of Medication}
#'     \item{ CMENDTC }{End Date/Time of Medication}
#'     \item{ CMSTDY }{Study Day of Start of Medication}
#'     \item{ CMENDY }{Study Day of End of Medication}
#'   }
#'
#' @source \url{https://github.com/cdisc-org/sdtm-adam-pilot-project/blob/master/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm/cm.xpt?raw=true}  # nolint
"cm"

#' Demography
#'
#' A SDTM DM dataset from the CDISC pilot project
#'
#' @name dm
#' @docType data
#' @format A data frame with 25 columns:
#'   \describe{
#'     \item{ STUDYID }{Study Identifier}
#'     \item{ DOMAIN }{Domain Abbreviation}
#'     \item{ USUBJID }{Unique Subject Identifier}
#'     \item{ SUBJID }{Subject Identifier for the Study}
#'     \item{ RFSTDTC }{Subject Reference Start Date/Time}
#'     \item{ RFENDTC }{Subject Reference End Date/Time}
#'     \item{ RFXSTDTC }{Date/Time of First Study Treatment}
#'     \item{ RFXENDTC }{Date/Time of Last Study Treatment}
#'     \item{ RFICDTC }{Date/Time of Informed Consent}
#'     \item{ RFPENDTC }{Date/Time of End of Participation}
#'     \item{ DTHDTC }{Date/Time of Death}
#'     \item{ DTHFL }{Subject Death Flag}
#'     \item{ SITEID }{Study Site Identifier}
#'     \item{ AGE }{Age}
#'     \item{ AGEU }{Age Units}
#'     \item{ SEX }{Sex}
#'     \item{ RACE }{Race}
#'     \item{ ETHNIC }{Ethnicity}
#'     \item{ ARMCD }{Planned Arm Code}
#'     \item{ ARM }{Description of Planned Arm}
#'     \item{ ACTARMCD }{Actual Arm Code}
#'     \item{ ACTARM }{Description of Actual Arm}
#'     \item{ COUNTRY }{Country}
#'     \item{ DMDTC }{Date/Time of Collection}
#'     \item{ DMDY }{Study Day of Collection}
#'   }
#'
#' @source \url{https://github.com/cdisc-org/sdtm-adam-pilot-project/blob/master/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm/dm.xpt?raw=true}  # nolint
"dm"

#' Disposition
#'
#' An updated SDTM DS dataset that uses the CDISC pilot project
#'
#' @name ds
#' @docType data
#' @format A data frame with 13 columns:
#'   \describe{
#'     \item{ STUDYID }{Study Identifier}
#'     \item{ DOMAIN }{Domain Abbreviation}
#'     \item{ USUBJID }{Unique Subject Identifier}
#'     \item{ DSSEQ }{Sequence Number}
#'     \item{ DSSPID }{Sponsor-Defined Identifier}
#'     \item{ DSTERM }{Reported Term for the Disposition Event}
#'     \item{ DSDECOD }{Standardized Disposition Term}
#'     \item{ DSCAT }{Category for Disposition Event}
#'     \item{ VISITNUM }{Visit Number}
#'     \item{ VISIT }{Visit Name}
#'     \item{ DSDTC }{Date/Time of Collection}
#'     \item{ DSSTDTC }{Start Date/Time of Disposition Event}
#'     \item{ DSSTDY }{Study Day of Start of Disposition Event}
#'   }
#'
#' @source \url{https://github.com/pharmaverse/pharmaversesdtm/blob/main/data/ds.rda}
#' @author Gopi Vegesna
"ds"

#' Electrocardiogram
#'
#' An example of standard SDTM EG dataset to be used in deriving ADEG dataset
#'
#' @name eg
#' @docType data
#' @format A data frame with 24 columns:
#'   \describe{
#'     \item{ STUDYID }{Study Identifier}
#'     \item{ DOMAIN }{No description available}
#'     \item{ USUBJID }{Unique Subject Identifier}
#'     \item{ EGSEQ }{Sequence Number}
#'     \item{ EGTESTCD }{No description available}
#'     \item{ EGTEST }{No description available}
#'     \item{ EGORRES }{No description available}
#'     \item{ EGORRESU }{Original Units}
#'     \item{ EGSTRESC }{No description available}
#'     \item{ EGSTRESN }{No description available}
#'     \item{ EGSTRESU }{No description available}
#'     \item{ EGSTAT }{Completion Status}
#'     \item{ EGLOC }{Location of Vital Signs Measurement}
#'     \item{ EGBLFL }{Baseline Flag}
#'     \item{ VISITNUM }{Visit Number}
#'     \item{ VISIT }{Visit Name}
#'     \item{ VISITDY }{Planned Study Day of Visit}
#'     \item{ EGDTC }{Date/Time of Measurements}
#'     \item{ EGDY }{Study Day of Vital Signs}
#'     \item{ EGTPT }{Planned Time Point Name}
#'     \item{ EGTPTNUM }{Planned Time Point Number}
#'     \item{ EGELTM }{Planned Elapsed Time from Time Point Ref}
#'     \item{ EGTPTREF }{Time Point Reference}
#'     \item{ temp }{No description available}
#'   }
#'
#' @source Generated dataset.
#' @author Vladyslav Shuliar
"eg"

#' Exposure
#'
#' A SDTM EX dataset from the CDISC pilot project
#'
#' @name ex
#' @docType data
#' @format A data frame with 17 columns:
#'   \describe{
#'     \item{ STUDYID }{Study Identifier}
#'     \item{ DOMAIN }{Domain Abbreviation}
#'     \item{ USUBJID }{Unique Subject Identifier}
#'     \item{ EXSEQ }{Sequence Number}
#'     \item{ EXTRT }{Name of Actual Treatment}
#'     \item{ EXDOSE }{Dose per Administration}
#'     \item{ EXDOSU }{Dose Units}
#'     \item{ EXDOSFRM }{Dose Form}
#'     \item{ EXDOSFRQ }{Dosing Frequency per Interval}
#'     \item{ EXROUTE }{Route of Administration}
#'     \item{ VISITNUM }{Visit Number}
#'     \item{ VISIT }{Visit Name}
#'     \item{ VISITDY }{Planned Study Day of Visit}
#'     \item{ EXSTDTC }{Start Date/Time of Treatment}
#'     \item{ EXENDTC }{End Date/Time of Treatment}
#'     \item{ EXSTDY }{Study Day of Start of Treatment}
#'     \item{ EXENDY }{Study Day of End of Treatment}
#'   }
#'
#' @source \url{https://github.com/cdisc-org/sdtm-adam-pilot-project/blob/master/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm/ex.xpt?raw=true}  # nolint
"ex"

#' Exposure for Ophthalmology
#'
#' An example Exposure SDTM dataset with ophthalmology-specific variables such as `EXLOC` and `EXLAT`
#'
#' @name ex_ophtha
#' @docType data
#' @format A data frame with 19 columns:
#'   \describe{
#'     \item{ USUBJID }{Unique Subject Identifier}
#'     \item{ STUDYID }{Study Identifier}
#'     \item{ DOMAIN }{Domain Abbreviation}
#'     \item{ EXSEQ }{Sequence Number}
#'     \item{ EXTRT }{Name of Actual Treatment}
#'     \item{ EXDOSE }{Dose per Administration}
#'     \item{ EXDOSU }{Dose Units}
#'     \item{ EXDOSFRM }{Dose Form}
#'     \item{ EXDOSFRQ }{Dose Frequency per Interval}
#'     \item{ EXROUTE }{Route of Administration}
#'     \item{ EXLOC }{Location of Dose Administration}
#'     \item{ EXLAT }{Laterality}
#'     \item{ VISITNUM }{Visit Number}
#'     \item{ VISIT }{Visit Name}
#'     \item{ VISITDY }{Planned Study Day of Visit}
#'     \item{ EXSTDTC }{Start Date/Time of Treatment}
#'     \item{ EXENDTC }{End Date/Time of Treatment}
#'     \item{ EXSTDY }{Study Day of Start of Treatment}
#'     \item{ EXENDY }{Study Day of End of Treatment}
#'   }
#'
#' @source Constructed using `ex` from the `{pharmaversesdtm}` package
"ex_ophtha"

#' Laboratory Measurements
#'
#' An updated SDTM LB dataset that uses data from the CDISC pilot project
#'
#' @name lb
#' @docType data
#' @format A data frame with 23 columns:
#'   \describe{
#'     \item{ STUDYID }{Study Identifier}
#'     \item{ DOMAIN }{Domain Abbreviation}
#'     \item{ USUBJID }{Unique Subject Identifier}
#'     \item{ LBSEQ }{Sequence Number}
#'     \item{ LBTESTCD }{Lab Test or Examination Short Name}
#'     \item{ LBTEST }{Lab Test or Examination Name}
#'     \item{ LBCAT }{Category for Lab Test}
#'     \item{ LBORRES }{Result or Finding in Original Units}
#'     \item{ LBORRESU }{Original Units}
#'     \item{ LBORNRLO }{Reference Range Lower Limit in Orig Unit}
#'     \item{ LBORNRHI }{Reference Range Upper Limit in Orig Unit}
#'     \item{ LBSTRESC }{Character Result/Finding in Std Format}
#'     \item{ LBSTRESN }{Numeric Result/Finding in Standard Units}
#'     \item{ LBSTRESU }{Standard Units}
#'     \item{ LBSTNRLO }{Reference Range Lower Limit-Std Units}
#'     \item{ LBSTNRHI }{Reference Range Upper Limit-Std Units}
#'     \item{ LBNRIND }{Reference Range Indicator}
#'     \item{ LBBLFL }{Baseline Flag}
#'     \item{ VISITNUM }{Visit Number}
#'     \item{ VISIT }{Visit Name}
#'     \item{ VISITDY }{Planned Study Day of Visit}
#'     \item{ LBDTC }{Date/Time of Specimen Collection}
#'     \item{ LBDY }{Study Day of Specimen Collection}
#'   }
#'
#' @source \url{https://github.com/pharmaverse/pharmaversesdtm/blob/main/data/lb.rda}
#' @author Annie Yang
"lb"

#' Medical History
#'
#' An updated SDTM MH dataset that uses data from the CDISC pilot project
#'
#'#' @name mh
#' @docType data
#' @format A data frame with 28 columns:
#'   \describe{
#'     \item{ STUDYID }{Study Identifier}
#'     \item{ DOMAIN }{Domain Abbreviation}
#'     \item{ USUBJID }{Unique Subject Identifier}
#'     \item{ MHSEQ }{Sequence Number}
#'     \item{ MHSPID }{Sponsor-Defined Identifier}
#'     \item{ MHTERM }{Reported Term for the Medical History}
#'     \item{ MHLLT }{Lowest Level Term}
#'     \item{ MHDECOD }{Dictionary-Derived Term}
#'     \item{ MHHLT }{High Level Term}
#'     \item{ MHHLGT }{High Level Group Term}
#'     \item{ MHCAT }{Category for Medical History}
#'     \item{ MHBODSYS }{Body System or Organ Class}
#'     \item{ MHSEV }{Severity/Intensity}
#'     \item{ VISITNUM }{Visit Number}
#'     \item{ VISIT }{Visit Name}
#'     \item{ VISITDY }{Planned Study Day of Visit}
#'     \item{ MHDTC }{Date/Time of History Collection}
#'     \item{ MHSTDTC }{Start Date/Time of Medical History Event}
#'     \item{ MHDY }{Study Day of History Collection}
#'     \item{ MHENDTC }{End Date/Time of Medical History Event}
#'     \item{ MHPRESP }{Medical History Event Pre-Specified}
#'     \item{ MHOCCUR }{Medical History Occurrence}
#'     \item{ MHSTRTPT }{Start Relative to Reference Time Point}
#'     \item{ MHENRTPT }{End Relative to Reference Time Point}
#'     \item{ MHSTTPT }{Start Reference Time Point}
#'     \item{ MHENTPT }{End Reference Time Point}
#'     \item{ MHENRF }{End Relative to Reference Period}
#'     \item{ MHSTAT }{Completion Status}
#'   }
#'
#' @source \url{https://github.com/cdisc-org/sdtm-adam-pilot-project/blob/master/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm/mh.xpt?raw=true}  # nolint
#' @author Annie Yang
"mh"

#' Ophthalmic Examinations for Ophthalmology
#'
#' A SDTM OE dataset simulated by Ophthalmology team
#'
#' @name oe_ophtha
#' @docType data
#' @format A data frame with 25 columns:
#'   \describe{
#'     \item{ STUDYID }{Study Identifier}
#'     \item{ DOMAIN }{Domain Abbreviation}
#'     \item{ USUBJID }{Unique Subject Identifier}
#'     \item{ OESEQ }{Sequence Number}
#'     \item{ OECAT }{Category for Ophthalmic Test or Exam}
#'     \item{ OESCAT }{Subcategory for Ophthalmic Test or Exam}
#'     \item{ OEDTC }{Date/Time of Collection}
#'     \item{ VISIT }{Visit Name}
#'     \item{ VISITNUM }{Visit Number}
#'     \item{ VISITDY }{Planned Study Day of Visit}
#'     \item{ OESTRESN }{Numeric Result/Finding in Standard Units}
#'     \item{ OESTRESC }{Character Result/Finding in Std Format}
#'     \item{ OEORRES }{Result or Finding in Original Units}
#'     \item{ OETEST }{Name of Ophthalmic Test or Examination}
#'     \item{ OETESTCD }{Short Name of Ophthalmic Test or Exam}
#'     \item{ OETSTDTL }{Ophthalmic Test or Exam Detail}
#'     \item{ OELAT }{Laterality}
#'     \item{ OELOC }{Location Used for the Measurement}
#'     \item{ OEDY }{Study Day of Visit/Collection/Exam}
#'     \item{ OEMETHOD }{Method of Test or Examination}
#'     \item{ OEORRESU }{Original Units}
#'     \item{ OESTRESU }{Standard Units}
#'     \item{ OESTAT }{Completion Status}
#'     \item{ OETPT }{Planned Time Point Name}
#'     \item{ OETPTNUM }{Planned Time Point Number}
#'   }
#'
#' @source Generated dataset.
#' @author Gordon Miller
"oe_ophtha"

#' Pharmacokinetic Concentrations
#'
#' A SDTM PC dataset simulated by Antonio Rodriguez Contesti
#'
#' @name pc
#' @docType data
#' @format A data frame with 20 columns:
#'   \describe{
#'     \item{ STUDYID }{Study Identifier}
#'     \item{ DOMAIN }{Domain Abbreviation}
#'     \item{ USUBJID }{Unique Subject Identifier}
#'     \item{ PCSEQ }{Sequence Number}
#'     \item{ PCTESTCD }{Pharmacokinetic Test Short Name}
#'     \item{ PCTEST }{Pharmacokinetic Test Name}
#'     \item{ PCORRES }{Result or Finding in Original Units}
#'     \item{ PCORRESU }{Original Units}
#'     \item{ PCSTRESC }{Character Result/Finding in Std Format}
#'     \item{ PCSTRESN }{Numeric Result/Finding in Standard Units}
#'     \item{ PCSTRESU }{Standard Units}
#'     \item{ PCNAM }{Vendor Name}
#'     \item{ PCSPEC }{Specimen Material Type}
#'     \item{ PCLLOQ }{Lower Limit of Quantitation}
#'     \item{ VISIT }{Visit Name}
#'     \item{ VISITNUM }{Visit Number}
#'     \item{ PCDTC }{Date/Time of Specimen Collection}
#'     \item{ PCDY }{Actual Study Day of Specimen Collection}
#'     \item{ PCTPT }{Planned Time Point Name}
#'     \item{ PCTPTNUM }{Planned Time Point Number}
#'   }
#'
#' @source \url{https://github.com/pharmaverse/pharmaversesdtm/blob/main/data/pc.rda}
#' @author Antonio Rodriguez Contesti
"pc"

#' Pharmacokinetic Parameters
#'
#' A SDTM PP dataset simulated by Antonio Rodriguez Contesti
#'
#' @name pp
#' @docType data
#' @format A data frame with 14 columns:
#'   \describe{
#'     \item{ STUDYID }{Study Identifier}
#'     \item{ DOMAIN }{Domain Abbreviation}
#'     \item{ USUBJID }{Unique Subject Identifier}
#'     \item{ PPSEQ }{Sequence Number}
#'     \item{ PPTESTCD }{Parameter Short Name}
#'     \item{ PPTEST }{Parameter Name}
#'     \item{ PPCAT }{Parameter Category}
#'     \item{ PPORRES }{Result or Finding in Original Units}
#'     \item{ PPORRESU }{Original Units}
#'     \item{ PPSTRESC }{Character Result/Finding in Std Format}
#'     \item{ PPSTRESN }{Numeric Result/Finding in Standard Units}
#'     \item{ PPSTRESU }{Standard Units}
#'     \item{ PPSPEC }{Specimen Material Type}
#'     \item{ PPRFDTC }{Date/Time of Reference Point}
#'   }
#'
#' @source \url{https://github.com/pharmaverse/pharmaversesdtm/blob/main/data/pp.rda}
#' @author Antonio Rodriguez Contesti
"pp"

#' Questionnaire for Ophthalmology
#'
#' An example Questionnaires SDTM dataset with ophthalmology-specific questionnaire of NEI VFQ-25
#'
#' @name qs_ophtha
#' @docType data
#' @format A data frame with 20 columns:
#'   \describe{
#'     \item{ STUDYID }{No description available}
#'     \item{ DOMAIN }{No description available}
#'     \item{ USUBJID }{No description available}
#'     \item{ QSSEQ }{No description available}
#'     \item{ QSTESTCD }{No description available}
#'     \item{ QSTEST }{No description available}
#'     \item{ QSCAT }{No description available}
#'     \item{ QSSCAT }{No description available}
#'     \item{ QSORRES }{No description available}
#'     \item{ QSORRESU }{No description available}
#'     \item{ QSSTRESC }{No description available}
#'     \item{ QSSTRESN }{No description available}
#'     \item{ QSSTRESU }{No description available}
#'     \item{ QSBLFL }{No description available}
#'     \item{ QSDRVFL }{No description available}
#'     \item{ VISITNUM }{No description available}
#'     \item{ VISIT }{No description available}
#'     \item{ VISITDY }{No description available}
#'     \item{ QSDTC }{No description available}
#'     \item{ QSDY }{No description available}
#'   }
#'
#' @source Constructed using `qs` from the `{pharmaversesdtm}` package
"qs_ophtha"

#' Subject Characteristic for Ophthalmology
#'
#' A SDTM SC dataset simulated by Ophthalmology team
#'
#' @name sc_ophtha
#' @docType data
#' @format A data frame with 12 columns:
#'   \describe{
#'     \item{ STUDYID }{Study Identifier}
#'     \item{ DOMAIN }{Domain Abbreviation}
#'     \item{ USUBJID }{Unique Subject Identifier}
#'     \item{ SCSEQ }{Sequence Number}
#'     \item{ SCTESTCD }{Subject Characteristic Short Name}
#'     \item{ SCTEST }{Subject Characteristic}
#'     \item{ SCCAT }{Category for Subject Characteristic}
#'     \item{ SCORRES }{Result or Finding in Original Units}
#'     \item{ SCSTRESC }{Character Result/Finding in Std Format}
#'     \item{ EPOCH }{Epoch}
#'     \item{ SCDTC }{Date/Time of Collection}
#'     \item{ SCDY }{Study Day of Examination}
#'   }
#'
#' @source Generated dataset.
#' @author Gordon Miller
"sc_ophtha"

#' Tumor Identification for Oncology
#'
#' A SDTM TU dataset simulated by Gopi Vegesna
#'
#' @name tu_onco
#' @docType data
#' @format A data frame with 18 columns:
#'   \describe{
#'     \item{ STUDYID }{Study Identifier}
#'     \item{ DOMAIN }{Domain Abbreviation}
#'     \item{ USUBJID }{Unique Subject Identifier}
#'     \item{ TUSEQ }{Sequence Number}
#'     \item{ TULNKID }{Link ID}
#'     \item{ TUTESTCD }{Tumor Identification Short Name}
#'     \item{ TUTEST }{Tumor Identification Test Name}
#'     \item{ TUORRES }{Tumor Identification Result}
#'     \item{ TUSTRESC }{Tumor Identification Result Std. Format}
#'     \item{ TULOC }{Location of the Tumor}
#'     \item{ TUMETHOD }{Method of Identification}
#'     \item{ TUEVAL }{Evaluator}
#'     \item{ TUEVALID }{Evaluator Identifier}
#'     \item{ TUACPTFL }{Accepted Record Flag}
#'     \item{ VISITNUM }{Visit Number}
#'     \item{ VISIT }{Visit Name}
#'     \item{ TUDTC }{Date/Time of Tumor Identification}
#'     \item{ TUDY }{Study Day of Tumor Identification}
#'   }
#'
#' @source Generated dataset.
#' @author Gopi Vegesna
"tu_onco"

#' Tumor Results for Oncology
#'
#' A SDTM TR dataset simulated by Gopi Vegesna
#'
#' @name tr_onco
#' @docType data
#' @format A data frame with 24 columns:
#'   \describe{
#'     \item{ STUDYID }{Study Identifier}
#'     \item{ DOMAIN }{Domain Abbreviation}
#'     \item{ USUBJID }{Unique Subject Identifier}
#'     \item{ TRSEQ }{Sequence Number}
#'     \item{ TRGRPID }{Group ID}
#'     \item{ TRLNKGRP }{Link Group}
#'     \item{ TRLNKID }{Link ID}
#'     \item{ TRTESTCD }{Tumor Assessment Short Name}
#'     \item{ TRTEST }{Tumor Assessment Test Name}
#'     \item{ TRORRES }{Result or Finding in Original Units}
#'     \item{ TRORRESU }{Original Units}
#'     \item{ TRSTRESC }{Character Result/Finding in Std Format}
#'     \item{ TRSTRESN }{Numeric Result/Finding in Standard Units}
#'     \item{ TRSTRESU }{Standard Units}
#'     \item{ TRSTAT }{Completion Status}
#'     \item{ TRREASND }{Reason Tumor Measurement Not Performed}
#'     \item{ TRMETHOD }{Method used to Identify the Tumor}
#'     \item{ TREVAL }{Evaluator}
#'     \item{ TREVALID }{Evaluator Identifier}
#'     \item{ TRACPTFL }{Accepted Record Flag}
#'     \item{ VISITNUM }{Visit Number}
#'     \item{ VISIT }{Visit Name}
#'     \item{ TRDTC }{Date/Time of Tumor Measurement}
#'     \item{ TRDY }{Study Day of Tumor Measurement}
#'   }
#'
#' @source Generated dataset.
#' @author Gopi Vegesna
"tr_onco"

#' Disease Response for Oncology
#'
#' A SDTM RS dataset simulated by Gopi Vegesna
#'
#' @name rs_onco
#' @docType data
#' @format A data frame with 19 columns:
#'   \describe{
#'     \item{ STUDYID }{Study Identifier}
#'     \item{ DOMAIN }{Domain Abbreviation}
#'     \item{ USUBJID }{Unique Subject Identifier}
#'     \item{ RSSEQ }{Sequence Number}
#'     \item{ RSLNKGRP }{Link Group}
#'     \item{ RSTESTCD }{Response Assessment Short Name}
#'     \item{ RSTEST }{Response Assessment Name}
#'     \item{ RSCAT }{Category for Response Assessment}
#'     \item{ RSORRES }{Response Assessment Original Result}
#'     \item{ RSSTRESC }{Response Assessment Result in Std Format}
#'     \item{ RSSTAT }{Completion Status}
#'     \item{ RSREASND }{Reason Response Assessment Not Performed}
#'     \item{ RSEVAL }{Evaluator}
#'     \item{ RSEVALID }{Evaluator Identifier}
#'     \item{ RSACPTFL }{Accepted Record Flag}
#'     \item{ VISITNUM }{Visit Number}
#'     \item{ VISIT }{Visit Name}
#'     \item{ RSDTC }{Date/Time of Response Assessment}
#'     \item{ RSDY }{Study Day of Response Assessment}
#'   }
#'
#' @source Generated dataset.
#' @author Gopi Vegesna
"rs_onco"

#' Tumor Results (RECIST 1.1) for Oncology
#'
#' A SDTM TR dataset using RECIST 1.1. The dataset contains just a few patients.
#' It is intended for vignettes and examples of ADaM dataset creation.
#'
#' @name tr_onco_recist
#' @docType data
#' @format A data frame with 19 columns:
#'   \describe{
#'     \item{ DOMAIN }{No description available}
#'     \item{ STUDYID }{No description available}
#'     \item{ USUBJID }{No description available}
#'     \item{ TRGRPID }{No description available}
#'     \item{ TRLNKID }{No description available}
#'     \item{ TRTESTCD }{No description available}
#'     \item{ TRTEST }{No description available}
#'     \item{ TRORRES }{No description available}
#'     \item{ TRORRESU }{No description available}
#'     \item{ TRSTRESC }{No description available}
#'     \item{ TRSTRESN }{No description available}
#'     \item{ TRSTRESU }{No description available}
#'     \item{ VISITNUM }{No description available}
#'     \item{ VISIT }{No description available}
#'     \item{ TREVAL }{No description available}
#'     \item{ TREVALID }{No description available}
#'     \item{ TRACPTFL }{No description available}
#'     \item{ TRDTC }{No description available}
#'     \item{ TRSEQ }{No description available}
#'   }
#'
#' @source Generated dataset.
#' @author Stefan Bundfuss
"tr_onco_recist"

#' Tumor Identification (RECIST 1.1) for Oncology
#'
#' A SDTM TU dataset using RECIST 1.1. The dataset contains just a few patients.
#' It is intended for vignettes and examples of ADaM dataset creation.
#'
#' @name tu_onco_recist
#' @docType data
#' @format A data frame with 16 columns:
#'   \describe{
#'     \item{ DOMAIN }{No description available}
#'     \item{ STUDYID }{No description available}
#'     \item{ USUBJID }{No description available}
#'     \item{ VISIT }{No description available}
#'     \item{ VISITNUM }{No description available}
#'     \item{ TULOC }{No description available}
#'     \item{ TUTESTCD }{No description available}
#'     \item{ TUTEST }{No description available}
#'     \item{ TUORRES }{No description available}
#'     \item{ TUSTRESC }{No description available}
#'     \item{ TUMETHOD }{No description available}
#'     \item{ TULNKID }{No description available}
#'     \item{ TUEVAL }{No description available}
#'     \item{ TUEVALID }{No description available}
#'     \item{ TUACPTFL }{No description available}
#'     \item{ TUSEQ }{No description available}
#'   }
#'
#' @source Generated dataset.
#' @author Stefan Bundfuss
"tu_onco_recist"

#' Disease Response (RECIST 1.1) for Oncology
#'
#' A SDTM RS dataset using RECIST 1.1. The dataset contains just a few patients.
#' It is intended for vignettes and examples of ADaM dataset creation.
#'
#' @name rs_onco_recist
#' @docType data
#' @format A data frame with 14 columns:
#'   \describe{
#'     \item{ DOMAIN }{No description available}
#'     \item{ STUDYID }{No description available}
#'     \item{ USUBJID }{No description available}
#'     \item{ VISITNUM }{No description available}
#'     \item{ VISIT }{No description available}
#'     \item{ RSTESTCD }{No description available}
#'     \item{ RSTEST }{No description available}
#'     \item{ RSORRES }{No description available}
#'     \item{ RSSTRESC }{No description available}
#'     \item{ RSEVAL }{No description available}
#'     \item{ RSEVALID }{No description available}
#'     \item{ RSACPTFL }{No description available}
#'     \item{ RSDTC }{No description available}
#'     \item{ RSSEQ }{No description available}
#'   }
#'
#' @source The dataset is derived from \code{tr_onco_recist}.
#' @author Stefan Bundfuss
"rs_onco_recist"

#' Disease Response (iRECIST) for Oncology
#'
#' A SDTM RS dataset using iRECIST. The dataset contains just a few patients.
#' It is intended for vignettes and examples of ADaM dataset creation.
#'
#' @name rs_onco_irecist
#' @docType data
#' @format A data frame with 19 columns:
#'   \describe{
#'     \item{ STUDYID }{No description available}
#'     \item{ DOMAIN }{No description available}
#'     \item{ USUBJID }{No description available}
#'     \item{ RSSEQ }{No description available}
#'     \item{ RSLNKGRP }{No description available}
#'     \item{ RSTESTCD }{No description available}
#'     \item{ RSTEST }{No description available}
#'     \item{ RSCAT }{No description available}
#'     \item{ RSORRES }{No description available}
#'     \item{ RSSTRESC }{No description available}
#'     \item{ RSSTAT }{No description available}
#'     \item{ RSREASND }{No description available}
#'     \item{ RSEVAL }{No description available}
#'     \item{ RSEVALID }{No description available}
#'     \item{ RSACPTFL }{No description available}
#'     \item{ VISITNUM }{No description available}
#'     \item{ VISIT }{No description available}
#'     \item{ RSDTC }{No description available}
#'     \item{ RSDY }{No description available}
#'   }
#'
#' @source Generated dataset.
#' @author Rohan Thampi
"rs_onco_irecist"

#' Disease Response (IMWG)
#'
#' A SDTM RS dataset using IMWG criteria. The dataset contains just a few patients.
#' It is intended for vignettes and examples of ADaM dataset creation.
#'
#' @source Generated dataset.
#' @author Vinh Nguyen
"rs_onco_imwg"

#' Supplemental Qualifiers for RS_ONCO_IMWG
#'
#' A SDTM supplemental RS dataset using IMWG criteria. It is intended to be used
#' together with `rs_onco_imwg`.
#'
#' @source Generated dataset.
#' @author Vinh Nguyen
"supprs_onco_imwg"

#' Supplemental Adverse Events
#'
#' A SDTM SUPPAE dataset from the CDISC pilot project
#'
#' @name suppae
#' @docType data
#' @format A data frame with 10 columns:
#'   \describe{
#'     \item{ STUDYID }{Study Identifier}
#'     \item{ RDOMAIN }{Related Domain Abbreviation}
#'     \item{ USUBJID }{Unique Subject Identifier}
#'     \item{ IDVAR }{Identifying Variable}
#'     \item{ IDVARVAL }{Identifying Variable Value}
#'     \item{ QNAM }{Qualifier Variable Name}
#'     \item{ QLABEL }{Qualifier Variable Label}
#'     \item{ QVAL }{Data Value}
#'     \item{ QORIG }{Origin}
#'     \item{ QEVAL }{Evaluator}
#'   }
#'
#' @source \url{https://github.com/cdisc-org/sdtm-adam-pilot-project/blob/master/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm/suppae.xpt?raw=true}  # nolint
"suppae"

#' Supplemental Disposition
#'
#' A SDTM SUPPDS dataset from the CDISC pilot project
#'
#' @name suppds
#' @docType data
#' @format A data frame with 9 columns:
#'   \describe{
#'     \item{ STUDYID }{Study Identifier}
#'     \item{ RDOMAIN }{Related Domain Abbreviation}
#'     \item{ USUBJID }{Unique Subject Identifier}
#'     \item{ IDVAR }{Identifying Variable}
#'     \item{ IDVARVAL }{Identifying Variable Value}
#'     \item{ QNAM }{Qualifier Variable Name}
#'     \item{ QLABEL }{Qualifier Variable Label}
#'     \item{ QVAL }{Data Value}
#'     \item{ QORIG }{Origin}
#'   }
#'
#' @source \url{https://github.com/cdisc-org/sdtm-adam-pilot-project/blob/master/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm/suppds.xpt?raw=true}  # nolint
"suppds"

#' Supplemental Demography
#'
#' A SDTM SUPPDM dataset from the CDISC pilot project
#'
#' @name suppdm
#' @docType data
#' @format A data frame with 10 columns:
#'   \describe{
#'     \item{ STUDYID }{Study Identifier}
#'     \item{ RDOMAIN }{Related Domain Abbreviation}
#'     \item{ USUBJID }{Unique Subject Identifier}
#'     \item{ IDVAR }{Identifying Variable}
#'     \item{ IDVARVAL }{Identifying Variable Value}
#'     \item{ QNAM }{Qualifier Variable Name}
#'     \item{ QLABEL }{Qualifier Variable Label}
#'     \item{ QVAL }{Data Value}
#'     \item{ QORIG }{Origin}
#'     \item{ QEVAL }{Evaluator}
#'   }
#'
#' @source \url{https://github.com/cdisc-org/sdtm-adam-pilot-project/blob/master/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm/suppdm.xpt?raw=true}  # nolint
"suppdm"

#' Supplemental Tumor Results for Oncology
#'
#' A SDTM SUPPTR dataset simulated by Gopi Vegesna
#'
#' @name supptr_onco
#' @docType data
#' @format A data frame with 9 columns:
#'   \describe{
#'     \item{ STUDYID }{Study Identifier}
#'     \item{ RDOMAIN }{Related Domain Abbreviation}
#'     \item{ USUBJID }{Unique Subject Identifier}
#'     \item{ IDVAR }{Identifying Variable}
#'     \item{ IDVARVAL }{Identifying Variable Value}
#'     \item{ QNAM }{Qualifier Variable Name}
#'     \item{ QLABEL }{Qualifier Variable Label}
#'     \item{ QVAL }{Data Value}
#'     \item{ QORIG }{Origin}
#'   }
#'
#' @source Generated dataset.
#' @author Gopi Vegesna
"supptr_onco"

#' Trial Design
#'
#' A SDTM TS dataset from the CDISC pilot project
#'
#' @name ts
#' @docType data
#' @format A data frame with 6 columns:
#'   \describe{
#'     \item{ STUDYID }{Study Identifier}
#'     \item{ DOMAIN }{Domain Abbreviation}
#'     \item{ TSSEQ }{Sequence Number}
#'     \item{ TSPARMCD }{Trial Summary Parameter Short Name}
#'     \item{ TSPARM }{Trial Summary Parameter}
#'     \item{ TSVAL }{Parameter Value}
#'   }
#'
#' @source \url{https://github.com/cdisc-org/sdtm-adam-pilot-project/blob/master/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm/ts.xpt?raw=true}  # nolint
"ts"

#' Vital Signs
#'
#' A SDTM VS dataset from the CDISC pilot project
#'
#' @name vs
#' @docType data
#' @format A data frame with 24 columns:
#'   \describe{
#'     \item{ STUDYID }{Study Identifier}
#'     \item{ DOMAIN }{Domain Abbreviation}
#'     \item{ USUBJID }{Unique Subject Identifier}
#'     \item{ VSSEQ }{Sequence Number}
#'     \item{ VSTESTCD }{Vital Signs Test Short Name}
#'     \item{ VSTEST }{Vital Signs Test Name}
#'     \item{ VSPOS }{Vital Signs Position of Subject}
#'     \item{ VSORRES }{Result or Finding in Original Units}
#'     \item{ VSORRESU }{Original Units}
#'     \item{ VSSTRESC }{Character Result/Finding in Std Format}
#'     \item{ VSSTRESN }{Numeric Result/Finding in Standard Units}
#'     \item{ VSSTRESU }{Standard Units}
#'     \item{ VSSTAT }{Completion Status}
#'     \item{ VSLOC }{Location of Vital Signs Measurement}
#'     \item{ VSBLFL }{Baseline Flag}
#'     \item{ VISITNUM }{Visit Number}
#'     \item{ VISIT }{Visit Name}
#'     \item{ VISITDY }{Planned Study Day of Visit}
#'     \item{ VSDTC }{Date/Time of Measurements}
#'     \item{ VSDY }{Study Day of Vital Signs}
#'     \item{ VSTPT }{Planned Time Point Name}
#'     \item{ VSTPTNUM }{Planned Time Point Number}
#'     \item{ VSELTM }{Planned Elapsed Time from Time Point Ref}
#'     \item{ VSTPTREF }{Time Point Reference}
#'   }
#'
#' @source \url{https://github.com/cdisc-org/sdtm-adam-pilot-project/blob/master/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm/vs.xpt?raw=true}  # nolint
"vs"

#' Standardized MedDRA Queries
#'
#' An example SMQ dataset
#'
#' @name smq_db
#' @docType data
#' @format A data frame with 6 columns:
#'   \describe{
#'     \item{ termchar }{No description available}
#'     \item{ scope }{No description available}
#'     \item{ smq_name }{No description available}
#'     \item{ smq_id }{No description available}
#'     \item{ version }{No description available}
#'     \item{ termvar }{No description available}
#'   }
#'
#' @source Generated dataset.
"smq_db"

#' SDG
#'
#' An example SDG dataset
#'
#' @name sdg_db
#' @docType data
#' @format A data frame with 5 columns:
#'   \describe{
#'     \item{ termchar }{No description available}
#'     \item{ sdg_name }{No description available}
#'     \item{ sdg_id }{No description available}
#'     \item{ termvar }{No description available}
#'     \item{ version }{No description available}
#'   }
#'
#' @source Generated dataset.
"sdg_db"

#' Subject Visits
#'
#' A SDTM SV dataset from the CDISC pilot project. Duplicate observation for group
#' variable `USUBJID` and `VISIT` is corrected.
#'
#' @name sv
#' @docType data
#' @format A data frame with 8 columns:
#'   \describe{
#'     \item{ STUDYID }{Study Identifier}
#'     \item{ DOMAIN }{Domain Abbreviation}
#'     \item{ USUBJID }{Unique Subject Identifier}
#'     \item{ VISITNUM }{Visit Number}
#'     \item{ VISIT }{Visit Name}
#'     \item{ VISITDY }{Planned Study Day of Visit}
#'     \item{ SVSTDTC }{Start Date/Time of Visit}
#'     \item{ SVENDTC }{End Date/Time of Visit}
#'   }
#'
#' @source \url{https://github.com/cdisc-org/sdtm-adam-pilot-project/blob/master/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm/sv.xpt?raw=true}  # nolint
"sv"

#' Demographics for Vaccine
#'
#' An example SDTM DM dataset for vaccine studies
#'
#' @name dm_vaccine
#' @docType data
#' @format A data frame with 28 columns:
#'   \describe{
#'     \item{ STUDYID }{Study Identifier}
#'     \item{ DOMAIN }{Domain Abbreviation}
#'     \item{ USUBJID }{Unique Subject Identifier}
#'     \item{ SUBJID }{Subject Identifier for the Study}
#'     \item{ RFSTDTC }{Subject Reference Start Date/Time}
#'     \item{ RFENDTC }{Subject Reference End Date/Time}
#'     \item{ RFXSTDTC }{Date/Time of First Study Treatment}
#'     \item{ RFXENDTC }{Date/Time of Last Study Treatment}
#'     \item{ RFICDTC }{Date/Time of Informed Consent}
#'     \item{ RFPENDTC }{Date/Time of End of Participation}
#'     \item{ DTHDTC }{Date/Time of Death}
#'     \item{ DTHFL }{Subject Death Flag}
#'     \item{ SITEID }{Study Site Identifier}
#'     \item{ INVID }{Investigator Identifier}
#'     \item{ INVNAM }{Investigator Name}
#'     \item{ BRTHDTC }{Date/Time of Birth}
#'     \item{ AGE }{Age}
#'     \item{ AGEU }{Age Units}
#'     \item{ SEX }{Sex}
#'     \item{ RACE }{Race}
#'     \item{ ETHNIC }{Ethnicity}
#'     \item{ ARMCD }{Planned Arm Code}
#'     \item{ ARM }{Description of Planned Arm}
#'     \item{ ACTARMCD }{Actual Arm Code}
#'     \item{ ACTARM }{Description of Actual Arm}
#'     \item{ COUNTRY }{Country}
#'     \item{ DMDTC }{Date/Time of Collection}
#'     \item{ DMDY }{Study Day of Collection}
#'   }
#'
#' @source Constructed by `{admiralvaccine}` developers
"dm_vaccine"

#' Vital Signs for Vaccine
#'
#' An example SDTM VS dataset for vaccine studies
#'
#' @name vs_vaccine
#' @docType data
#' @format A data frame with 23 columns:
#'   \describe{
#'     \item{ STUDYID }{Study Identifier}
#'     \item{ DOMAIN }{Domain Abbreviation}
#'     \item{ USUBJID }{Unique Subject Identifier}
#'     \item{ VSSEQ }{Sequence Number}
#'     \item{ VSLNKID }{Link ID}
#'     \item{ VSLNKGRP }{Link Group ID}
#'     \item{ VSTESTCD }{Vital Signs Test Short Name}
#'     \item{ VSTEST }{Vital Signs Test Name}
#'     \item{ VSCAT }{Category for Vital Signs}
#'     \item{ VSSCAT }{Subcategory for Vital Signs}
#'     \item{ VSORRES }{Result or Finding in Original Units}
#'     \item{ VSORRESU }{Original Units}
#'     \item{ VSSTRESC }{Character Result/Finding in Std Format}
#'     \item{ VSSTRESN }{Numeric Result/Finding in Standard Units}
#'     \item{ VSSTRESU }{Standard Units}
#'     \item{ VSEVAL }{Evaluator}
#'     \item{ VSLOC }{Location of Vital Signs Measurement}
#'     \item{ EPOCH }{Epoch}
#'     \item{ VSDTC }{Date/Time of Measurements}
#'     \item{ VSDY }{Study Day of Vital Signs}
#'     \item{ VSTPT }{Planned Time Point Name}
#'     \item{ VSTPTNUM }{Planned Time Point Number}
#'     \item{ VSTPTREF }{Time Point Reference}
#'   }
#'
#' @source Constructed by `{admiralvaccine}` developers
"vs_vaccine"

#' Clinical Events for Vaccine
#'
#' An example SDTM CE dataset for vaccine studies
#'
#' @name ce_vaccine
#' @docType data
#' @format A data frame with 29 columns:
#'   \describe{
#'     \item{ STUDYID }{Study Identifier}
#'     \item{ DOMAIN }{Domain Abbreviation}
#'     \item{ USUBJID }{Unique Subject Identifier}
#'     \item{ CESEQ }{Sequence Number}
#'     \item{ CELNKID }{Link ID}
#'     \item{ CELNKGRP }{Link Group ID}
#'     \item{ CETERM }{Reported Term for the Clinical Event}
#'     \item{ CEDECOD }{Dictionary-Derived Term}
#'     \item{ CELAT }{Laterality of Location of Clinical Event}
#'     \item{ CELOC }{Location of Clinical Event}
#'     \item{ CECAT }{Category for Clinical Event}
#'     \item{ CESCAT }{Subcategory for Clinical Event}
#'     \item{ CEPRESP }{Clinical Event Pre-Specified}
#'     \item{ CEOCCUR }{Clinical Event Occurrence}
#'     \item{ CESEV }{Severity/Intensity}
#'     \item{ CEREL }{Causality}
#'     \item{ CEOUT }{Outcome of Clinical Event}
#'     \item{ EPOCH }{Epoch}
#'     \item{ CEDTC }{Date/Time of Event Collection}
#'     \item{ CESTDTC }{Start Date/Time of Clinical Event}
#'     \item{ CEENDTC }{End Date/Time of Clinical Event}
#'     \item{ CEDUR }{Duration of Clinical Event}
#'     \item{ CETPT }{Planned Time Point Name}
#'     \item{ CETPTNUM }{Planned Time Point Number}
#'     \item{ CETPTREF }{Time Point Reference}
#'     \item{ CERFTDTC }{Date/Time of Reference Time Point}
#'     \item{ CEEVINTX }{Evaluation Interval Text}
#'     \item{ CESTAT }{Completion Status}
#'     \item{ CEREASND }{Reason Clinical Event Not Collected}
#'   }
#'
#' @source Constructed by `{admiralvaccine}` developers
"ce_vaccine"

#' Exposures for Vaccine
#'
#' An example SDTM EX dataset for vaccine studies
#'
#' @name ex_vaccine
#' @docType data
#' @format A data frame with 21 columns:
#'   \describe{
#'     \item{ STUDYID }{Study Identifier}
#'     \item{ DOMAIN }{Domain Abbreviation}
#'     \item{ USUBJID }{Unique Subject Identifier}
#'     \item{ EXSEQ }{Sequence Number}
#'     \item{ EXLNKGRP }{Link Group ID}
#'     \item{ EXLNKID }{Link ID}
#'     \item{ EXTRT }{Name of Actual Treatment}
#'     \item{ EXCAT }{Category of Treatment}
#'     \item{ EXDOSE }{Dose per Administration}
#'     \item{ EXDOSU }{Dose Units}
#'     \item{ EXDOSFRM }{Dose Form}
#'     \item{ EXROUTE }{Route of Administration}
#'     \item{ EXLOC }{Location of Dose Administration}
#'     \item{ EXLAT }{Laterality}
#'     \item{ VISITNUM }{Visit Number}
#'     \item{ VISIT }{Visit Name}
#'     \item{ EPOCH }{Epoch}
#'     \item{ EXDTC }{No description available}
#'     \item{ EXSTDTC }{Start Date/Time of Treatment}
#'     \item{ EXENDTC }{End Date/Time of Treatment}
#'     \item{ EXDY }{No description available}
#'   }
#'
#' @source Constructed by `{admiralvaccine}` developers
"ex_vaccine"

#' Immunogenicity Specimen Assessments for Vaccine
#'
#' An example SDTM IS for vaccine studies
#'
#' @name is_vaccine
#' @docType data
#' @format A data frame with 24 columns:
#'   \describe{
#'     \item{ STUDYID }{Study Identifier}
#'     \item{ DOMAIN }{Domain Abbreviation}
#'     \item{ USUBJID }{Unique Subject Identifier}
#'     \item{ ISSEQ }{Sequence Number}
#'     \item{ ISTESTCD }{Immunogenicity Test/Exam Short Name}
#'     \item{ ISTEST }{Immunogenicity Test or Exam Name}
#'     \item{ ISCAT }{Category for Immunogenicity Test}
#'     \item{ ISORRES }{Result or Finding in Original Units}
#'     \item{ ISORRESU }{Original Units}
#'     \item{ ISSTRESC }{Character Result/Finding in Std Format}
#'     \item{ ISSTRESN }{Numeric Result/Finding in Standard Units}
#'     \item{ ISSTRESU }{Standard Units}
#'     \item{ ISSTAT }{Completion Status}
#'     \item{ ISREASND }{Reason Not Done}
#'     \item{ ISNAM }{Vendor Name}
#'     \item{ ISSPEC }{Specimen Type}
#'     \item{ ISMETHOD }{Method of Test or Examination}
#'     \item{ ISBLFL }{Baseline Flag}
#'     \item{ ISLLOQ }{Lower Limit of Quantitation}
#'     \item{ VISITNUM }{Visit Number}
#'     \item{ EPOCH }{Epoch}
#'     \item{ ISDTC }{Date/Time of Collection}
#'     \item{ ISDY }{Study Day of Collection}
#'     \item{ ISULOQ }{Upper Limit of Quantitation}
#'   }
#'
#' @source Constructed by `{admiralvaccine}` developers
"is_vaccine"

#' Findings About Clinical Events for Vaccine
#'
#' An example SDTM FACE for vaccine studies
#'
#' @name face_vaccine
#' @docType data
#' @format A data frame with 30 columns:
#'   \describe{
#'     \item{ STUDYID }{Study Identifier}
#'     \item{ DOMAIN }{Domain Abbreviation}
#'     \item{ USUBJID }{Unique Subject Identifier}
#'     \item{ FASEQ }{Sequence Number}
#'     \item{ FALNKGRP }{Link Group ID}
#'     \item{ FALAT }{Laterality}
#'     \item{ FALNKID }{Link ID}
#'     \item{ FALOC }{Location of the Finding About}
#'     \item{ FATESTCD }{Findings About Test Short Name}
#'     \item{ FATEST }{Findings About Test Name}
#'     \item{ FAOBJ }{Object of the Observation}
#'     \item{ FACAT }{Category for Findings About}
#'     \item{ FASCAT }{Subcategory for Findings About}
#'     \item{ FAEVAL }{Evaluator}
#'     \item{ FAORRES }{Result or Finding in Original Units}
#'     \item{ FAORRESU }{Original Units}
#'     \item{ EPOCH }{Epoch}
#'     \item{ FADTC }{Date/Time of Collection}
#'     \item{ FADY }{Study Day of Collection}
#'     \item{ FATPT }{Planned Time Point Name}
#'     \item{ FATPTNUM }{Planned Time Point Number}
#'     \item{ FATPTREF }{Time Point Reference}
#'     \item{ FARFTDTC }{Date/Time of Reference Time Point}
#'     \item{ FAEVLINT }{Evaluation Interval}
#'     \item{ FAEVINTX }{Evaluation Interval Text}
#'     \item{ FASTAT }{Completion Status}
#'     \item{ FAREASND }{Reason Not Performed}
#'     \item{ FASTRESC }{Character Result/Finding in Std Format}
#'     \item{ FASTRESN }{Numeric Result/Finding in Standard Units}
#'     \item{ FASTRESU }{Standard Units}
#'   }
#'
#' @source Constructed by `{admiralvaccine}` developers
"face_vaccine"

#' Supplemental Qualifiers for Clinical Events for Vaccine
#'
#' An example SDTM SUPPCE for vaccine studies
#'
#' @name suppce_vaccine
#' @docType data
#' @format A data frame with 9 columns:
#'   \describe{
#'     \item{ STUDYID }{Study Identifier}
#'     \item{ USUBJID }{Unique Subject Identifier}
#'     \item{ RDOMAIN }{Related Domain Abbreviation}
#'     \item{ IDVAR }{Identifying Variable}
#'     \item{ IDVARVAL }{Identifying Variable Value}
#'     \item{ QNAM }{Qualifier Variable Name}
#'     \item{ QVAL }{Data Value}
#'     \item{ QLABEL }{Qualifier Variable Label}
#'     \item{ QORIG }{Origin}
#'   }
#'
#' @source Constructed by `{admiralvaccine}` developers
"suppce_vaccine"

#' Supplemental Qualifiers for Demographics for Vaccine
#'
#' An example SDTM SUPPDM dataset for vaccine studies
#'
#' @name suppdm_vaccine
#' @docType data
#' @format A data frame with 9 columns:
#'   \describe{
#'     \item{ STUDYID }{Study Identifier}
#'     \item{ USUBJID }{Unique Subject Identifier}
#'     \item{ RDOMAIN }{Related Domain Abbreviation}
#'     \item{ IDVAR }{Identifying Variable}
#'     \item{ IDVARVAL }{Identifying Variable Value}
#'     \item{ QNAM }{Qualifier Variable Name}
#'     \item{ QVAL }{Data Value}
#'     \item{ QLABEL }{Qualifier Variable Label}
#'     \item{ QORIG }{Origin}
#'   }
#'
#' @source Constructed by `{admiralvaccine}` developers
"suppdm_vaccine"

#' Supplemental Qualifiers for Exposures for Vaccine
#'
#' An example SDTM SUPPEX dataset for vaccine studies
#'
#' @name suppex_vaccine
#' @docType data
#' @format A data frame with 9 columns:
#'   \describe{
#'     \item{ STUDYID }{Study Identifier}
#'     \item{ USUBJID }{Unique Subject Identifier}
#'     \item{ RDOMAIN }{Related Domain Abbreviation}
#'     \item{ IDVAR }{Identifying Variable}
#'     \item{ IDVARVAL }{Identifying Variable Value}
#'     \item{ QNAM }{Qualifier Variable Name}
#'     \item{ QVAL }{Data Value}
#'     \item{ QLABEL }{Qualifier Variable Label}
#'     \item{ QORIG }{Origin}
#'   }
#'
#' @source Constructed by `{admiralvaccine}` developers
"suppex_vaccine"

#' Supplemental Qualifiers for Findings About for Clinical Events for Vaccine
#'
#' An example SDTM SUPPFACE dataset for vaccine studies
#'
#' @name suppface_vaccine
#' @docType data
#' @format A data frame with 9 columns:
#'   \describe{
#'     \item{ STUDYID }{Study Identifier}
#'     \item{ USUBJID }{Unique Subject Identifier}
#'     \item{ RDOMAIN }{Related Domain Abbreviation}
#'     \item{ IDVAR }{Identifying Variable}
#'     \item{ IDVARVAL }{Identifying Variable Value}
#'     \item{ QNAM }{Qualifier Variable Name}
#'     \item{ QVAL }{Data Value}
#'     \item{ QLABEL }{Qualifier Variable Label}
#'     \item{ QORIG }{Origin}
#'   }
#'
#' @source Constructed by `{admiralvaccine}` developers
"suppface_vaccine"

#' Supplemental Qualifiers for Immunogenicity Specimen Assessments for Vaccine
#'
#' An example SDTM SUPPIS dataset for vaccine studies
#'
#' @name suppis_vaccine
#' @docType data
#' @format A data frame with 10 columns:
#'   \describe{
#'     \item{ STUDYID }{Study Identifier}
#'     \item{ RDOMAIN }{Related Domain Abbreviation}
#'     \item{ USUBJID }{Unique Subject Identifier}
#'     \item{ IDVAR }{Identifying Variable}
#'     \item{ IDVARVAL }{Identifying Variable Value}
#'     \item{ QNAM }{Qualifier Variable Name}
#'     \item{ QLABEL }{Qualifier Variable Label}
#'     \item{ QVAL }{Data Value}
#'     \item{ QORIG }{Origin}
#'     \item{ QEVAL }{Evaluator}
#'   }
#'
#' @source Constructed by `{admiralvaccine}` developers
"suppis_vaccine"

#' Demographic Dataset-pediatrics
#'
#' An updated SDTM DM dataset with pediatric patients
#'
#' @source Constructed by `{admiralpeds}` developers
"dm_peds"

#' Vital signs Dataset-pediatrics
#'
#' An updated SDTM VS dataset with anthropometric measurements for pediatric patients
#'
#' @source Constructed by `{admiralpeds}` developers
"vs_peds"
