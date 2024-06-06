#' Adverse Events
#'
#' An updated SDTM AE dataset that uses the CDISC pilot project
#'
#' @source \url{https://github.com/pharmaverse/pharmaversesdtm/blob/main/data/ae.rda}
"ae"

#' Adverse Events for Ophthalmology
#'
#' An example Adverse Events SDTM dataset with ophthalmology-specific variable `AELAT`
#'
#' @source Constructed using `ae` from the `{pharmaversesdtm}` package
"ae_ophtha"

#' Concomitant Medication
#'
#' A SDTM CM dataset from the CDISC pilot project
#'
#' @source \url{https://github.com/cdisc-org/sdtm-adam-pilot-project/blob/master/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm/cm.xpt?raw=true}  # nolint
"cm"

#' Demography
#'
#' A SDTM DM dataset from the CDISC pilot project
#'
#' @source \url{https://github.com/cdisc-org/sdtm-adam-pilot-project/blob/master/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm/dm.xpt?raw=true}  # nolint
"dm"

#' Disposition
#'
#' An updated SDTM DS dataset that uses the CDISC pilot project
#'
#' @source \url{https://github.com/pharmaverse/pharmaversesdtm/blob/main/data/ds.rda}
#' @author Gopi Vegesna
"ds"

#' Electrocardiogram
#'
#' An example of standard SDTM EG dataset to be used in deriving ADEG dataset
#'
"eg"

#' Exposure
#'
#' A SDTM EX dataset from the CDISC pilot project
#'
#' @source \url{https://github.com/cdisc-org/sdtm-adam-pilot-project/blob/master/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm/ex.xpt?raw=true}  # nolint
"ex"

#' Exposure for Ophthalmology
#'
#' An example Exposure SDTM dataset with ophthalmology-specific variables such as `EXLOC` and `EXLAT`
#'
#' @source Constructed using `ex` from the `{pharmaversesdtm}` package
"ex_ophtha"

#' Laboratory Measurements
#'
#' An updated SDTM LB dataset that uses data from the CDISC pilot project
#'
#' @source \url{https://github.com/pharmaverse/pharmaversesdtm/blob/main/data/lb.rda}
#' @author Annie Yang
"lb"

#' Medical History
#'
#' An updated SDTM MH dataset that uses data from the CDISC pilot project
#'
#' @source \url{https://github.com/cdisc-org/sdtm-adam-pilot-project/blob/master/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm/mh.xpt?raw=true}  # nolint
#' @author Annie Yang
"mh"

#' Ophthalmic Examinations for Ophthalmology
#'
#' A SDTM OE dataset simulated by Ophthalmology team
#'
#' @author Gordon Miller
"oe_ophtha"

#' Pharmacokinetic Concentrations
#'
#' A SDTM PC dataset simulated by Antonio Rodriguez Contesti
#'
#' @source \url{https://github.com/pharmaverse/pharmaversesdtm/blob/main/data/pc.rda}
#' @author Antonio Rodriguez Contesti
"pc"

#' Pharmacokinetic Parameters
#'
#' A SDTM PP dataset simulated by Antonio Rodriguez Contesti
#'
#' @source \url{https://github.com/pharmaverse/pharmaversesdtm/blob/main/data/pp.rda}
#' @author Antonio Rodriguez Contesti
"pp"

#' Questionnaire for Ophthalmology
#'
#' An example Questionnaires SDTM dataset with ophthalmology-specific questionnaire of NEI VFQ-25
#'
#' @source Constructed using `qs` from the `{pharmaversesdtm}` package
"qs_ophtha"

#' Subject Characteristic for Ophthalmology
#'
#' A SDTM SC dataset simulated by Ophthalmology team
#'
#' @author Gordon Miller
"sc_ophtha"

#' Tumor Identification for Oncology
#'
#' A SDTM TU dataset simulated by Gopi Vegesna
#'
#' @author Gopi Vegesna
"tu_onco"

#' Tumor Results for Oncology
#'
#' A SDTM TR dataset simulated by Gopi Vegesna
#'
#' @author Gopi Vegesna
"tr_onco"

#' Disease Response for Oncology
#'
#' A SDTM RS dataset simulated by Gopi Vegesna
#'
#' @author Gopi Vegesna
"rs_onco"

#' Tumor Results (RECIST 1.1) for Oncology
#'
#' A SDTM TR dataset using RECIST 1.1. The dataset contains just a few patients.
#' It is intended for vignettes and examples of ADaM dataset creation.
#'
#' @author Stefan Bundfuss
"tr_onco_recist"

#' Tumor Identification (RECIST 1.1) for Oncology
#'
#' A SDTM TU dataset using RECIST 1.1. The dataset contains just a few patients.
#' It is intended for vignettes and examples of ADaM dataset creation.
#'
#' @author Stefan Bundfuss
"tu_onco_recist"

#' Disease Response (RECIST 1.1) for Oncology
#'
#' A SDTM RS dataset using RECIST 1.1. The dataset contains just a few patients.
#' It is intended for vignettes and examples of ADaM dataset creation.
#'
#' @source The dataset is derived from \code{tr_onco_recist}.
#'
#' @author Stefan Bundfuss
"rs_onco_recist"

#' Disease Response (iRECIST) for Oncology
#'
#' A SDTM RS dataset using iRECIST. The dataset contains just a few patients.
#' It is intended for vignettes and examples of ADaM dataset creation.
#'
#' @author Rohan Thampi
"rs_onco_irecist"

#' Disease Response (IMWG)
#'
#' A SDTM RS dataset using IMWG criteria. The dataset contains just a few patients.
#' It is intended for vignettes and examples of ADaM dataset creation.
#'
#' @author Vinh Nguyen
"rs_onco_imwg"

#' Supplemental Qualifiers for RS_ONCO_IMWG
#'
#' A SDTM supplemental RS dataset using IMWG criteria. It is intended to be used
#' together with `rs_onco_imwg`.
#'
#' @author Vinh Nguyen
"supprs_onco_imwg"

#' Supplemental Adverse Events
#'
#' A SDTM SUPPAE dataset from the CDISC pilot project
#'
#' @source \url{https://github.com/cdisc-org/sdtm-adam-pilot-project/blob/master/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm/suppae.xpt?raw=true}  # nolint
"suppae"

#' Supplemental Disposition
#'
#' A SDTM SUPPDS dataset from the CDISC pilot project
#'
#' @source \url{https://github.com/cdisc-org/sdtm-adam-pilot-project/blob/master/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm/suppds.xpt?raw=true}  # nolint
"suppds"

#' Supplemental Demography
#'
#' A SDTM SUPPDM dataset from the CDISC pilot project
#'
#' @source \url{https://github.com/cdisc-org/sdtm-adam-pilot-project/blob/master/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm/suppdm.xpt?raw=true}  # nolint
"suppdm"

#' Supplemental Tumor Results for Oncology
#'
#' A SDTM SUPPTR dataset simulated by Gopi Vegesna
#'
#' @author Gopi Vegesna
"supptr_onco"

#' Trial Design
#'
#' A SDTM TS dataset from the CDISC pilot project
#'
#' @source \url{https://github.com/cdisc-org/sdtm-adam-pilot-project/blob/master/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm/ts.xpt?raw=true}  # nolint
"ts"

#' Vital Signs
#'
#' A SDTM VS dataset from the CDISC pilot project
#'
#' @source \url{https://github.com/cdisc-org/sdtm-adam-pilot-project/blob/master/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm/vs.xpt?raw=true}  # nolint
"vs"

#' Standardized MedDRA Queries
#'
#' An example SMQ dataset
#'
"smq_db"

#' SDG
#'
#' An example SDG dataset
#'
"sdg_db"

#' Subject Visits
#'
#' A SDTM SV dataset from the CDISC pilot project. Duplicate observation for group
#' variable `USUBJID` and `VISIT` is corrected.
#'
#' @source \url{https://github.com/cdisc-org/sdtm-adam-pilot-project/blob/master/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm/sv.xpt?raw=true}  # nolint
"sv"

#' Demographics for Vaccine
#'
#' An example SDTM DM dataset for vaccine studies
#'
#' @source Constructed by `{admiralvaccine}` developers
"dm_vaccine"

#' Vital Signs for Vaccine
#'
#' An example SDTM VS dataset for vaccine studies
#'
#' @source Constructed by `{admiralvaccine}` developers
"vs_vaccine"

#' Clinical Events for Vaccine
#'
#' An example SDTM CE dataset for vaccine studies
#'
#' @source Constructed by `{admiralvaccine}` developers
"ce_vaccine"

#' Exposures for Vaccine
#'
#' An example SDTM EX dataset for vaccine studies
#'
#' @source Constructed by `{admiralvaccine}` developers
"ex_vaccine"

#' Immunogenicity Specimen Assessments for Vaccine
#'
#' An example SDTM IS for vaccine studies
#'
#' @source Constructed by `{admiralvaccine}` developers
"is_vaccine"

#' Findings About Clinical Events for Vaccine
#'
#' An example SDTM FACE for vaccine studies
#'
#' @source Constructed by `{admiralvaccine}` developers
"face_vaccine"

#' Supplemental Qualifiers for Clinical Events for Vaccine
#'
#' An example SDTM SUPPCE for vaccine studies
#'
#' @source Constructed by `{admiralvaccine}` developers
"suppce_vaccine"

#' Supplemental Qualifiers for Demographics for Vaccine
#'
#' An example SDTM SUPPDM dataset for vaccine studies
#'
#' @source Constructed by `{admiralvaccine}` developers
"suppdm_vaccine"

#' Supplemental Qualifiers for Exposures for Vaccine
#'
#' An example SDTM SUPPEX dataset for vaccine studies
#'
#' @source Constructed by `{admiralvaccine}` developers
"suppex_vaccine"

#' Supplemental Qualifiers for Findings About for Clinical Events for Vaccine
#'
#' An example SDTM SUPPFACE dataset for vaccine studies
#'
#' @source Constructed by `{admiralvaccine}` developers
"suppface_vaccine"

#' Supplemental Qualifiers for Immunogenicity Specimen Assessments for Vaccine
#'
#' An example SDTM SUPPIS dataset for vaccine studies
#'
#' @source Constructed by `{admiralvaccine}` developers
"suppis_vaccine"
