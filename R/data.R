#' Adverse Events Dataset-updated
#'
#' An updated SDTM AE dataset that uses the CDISC pilot project
#'
#' @source \url{https://github.com/pharmaverse/pharmaversesdtm/blob/main/data/ae.rda}
"ae"

#' Ophthalmology Adverse Events Dataset
#'
#' An example Adverse Events SDTM dataset with ophthalmology-specific variable `AELAT`
#'
#' @source Constructed using `ae` from the `{pharmaversesdtm}` package # nolint
"ae_ophtha"

#' Concomitant Medication Dataset
#'
#' A SDTM CM dataset from the CDISC pilot project
#'
#' @source \url{https://github.com/cdisc-org/sdtm-adam-pilot-project/blob/master/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm/cm.xpt?raw=true} # nolint
"cm"

#' Demography Dataset
#'
#' A SDTM DM dataset from the CDISC pilot project
#'
#' @source \url{https://github.com/cdisc-org/sdtm-adam-pilot-project/blob/master/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm/dm.xpt?raw=true} # nolint
"dm"

#' Disposition Dataset-updated
#'
#' An updated SDTM DS dataset that uses the CDISC pilot project
#'
#' @source \url{https://github.com/pharmaverse/pharmaversesdtm/blob/main/data/ds.rda}
#' @author Gopi Vegesna
"ds"

#' Electrocardiogram Dataset
#'
#' An example of standard SDTM EG dataset to be used in deriving ADEG dataset
#'
"eg"

#' Exposure Dataset
#'
#' A SDTM EX dataset from the CDISC pilot project
#'
#' @source \url{https://github.com/cdisc-org/sdtm-adam-pilot-project/blob/master/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm/ex.xpt?raw=true} # nolint
"ex"

#' Ophthalmology Exposure Dataset
#'
#' An example Exposure SDTM dataset with ophthalmology-specific variables such as `EXLOC` and `EXLAT`
#'
#' @source Constructed using `ex` from the `{pharmaversesdtm}` package # nolint
"ex_ophtha"

#' Laboratory Measurements Dataset
#'
#' An updated SDTM LB dataset that uses data from the CDISC pilot project
#'
#' @source \url{https://github.com/pharmaverse/pharmaversesdtm/blob/main/data/lb.rda}
#' @author Annie Yang
"lb"

#' Medical History Dataset-updated
#'
#' An updated SDTM MH dataset that uses data from the CDISC pilot project
#'
#' @source \url{https://github.com/cdisc-org/sdtm-adam-pilot-project/blob/master/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm/mh.xpt?raw=true} # nolint
#' @author Annie Yang
"mh"

#' Ophthalmic Examinations Dataset
#'
#' A SDTM OE dataset simulated by Ophthalmology team
#'
#' @author Gordon Miller
"oe_ophtha"

#' Pharmacokinetics Concentrations Dataset
#'
#' A SDTM PC dataset simulated by Antonio Rodríguez Contestí
#'
#' @source \url{https://github.com/pharmaverse/pharmaversesdtm/blob/main/data/pc.rda}
#' @author Antonio Rodríguez Contestí
"pc"

#' Pharmacokinetic Parameters Dataset
#'
#' A SDTM PP dataset simulated by Antonio Rodríguez Contestí
#'
#' @source \url{https://github.com/pharmaverse/pharmaversesdtm/blob/main/data/pp.rda}
#' @author Antonio Rodríguez Contestí
"pp"

#' Ophthalmology Questionnaire Dataset
#'
#' An example Questionnaires SDTM dataset with ophthalmology-specific questionnaire of NEI VFQ-25
#'
#' @source Constructed using `qs` from the `{pharmaversesdtm}` package # nolint
"qs_ophtha"

#' Subject Characteristic Dataset
#'
#' A SDTM SC dataset simulated by Ophthalmology team
#'
#' @author Gordon Miller
"sc_ophtha"

#' Tumor Identification Dataset
#'
#' A SDTM TU dataset simulated by Gopi Vegesna
#'
#' @author Gopi Vegesna
"tu_onco"

#' Tumor Results Dataset
#'
#' A SDTM TR dataset simulated by Gopi Vegesna
#'
#' @author Gopi Vegesna
"tr_onco"

#' Disease Response Dataset
#'
#' A SDTM RS dataset simulated by Gopi Vegesna
#'
#' @author Gopi Vegesna
"rs_onco"

#' Tumor Results Dataset (RECIST 1.1)
#'
#' A SDTM TR dataset using RECIST 1.1. The dataset contains just a few patients.
#' It is intended for vignettes and examples of ADaM dataset creation.
#'
#' @author Stefan Bundfuss
"tr_onco_recist"

#' Tumor Identification Dataset (RECIST 1.1)
#'
#' A SDTM TU dataset using RECIST 1.1. The dataset contains just a few patients.
#' It is intended for vignettes and examples of ADaM dataset creation.
#'
#' @author Stefan Bundfuss
"tu_onco_recist"

#' Disease Response Dataset (RECIST 1.1)
#'
#' A SDTM RS dataset using RECIST 1.1. The dataset contains just a few patients.
#' It is intended for vignettes and examples of ADaM dataset creation.
#'
#' @source The dataset is derived from \code{tr_onco_recist}.
#'
#' @author Stefan Bundfuss
"rs_onco_recist"

#' Disease Response Dataset (iRECIST)
#'
#' A SDTM RS dataset using iRECIST. The dataset contains just a few patients.
#' It is intended for vignettes and examples of ADaM dataset creation.
#'
#' @author Rohan Thampi
"rs_onco_irecist"

#' Supplemental Adverse Events Dataset
#'
#' A SDTM SUPPAE dataset from the CDISC pilot project
#'
#' @source \url{https://github.com/cdisc-org/sdtm-adam-pilot-project/blob/master/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm/suppae.xpt?raw=true} # nolint
"suppae"

#' Supplemental Disposition Dataset-updated
#'
#' A SDTM SUPPDS dataset from the CDISC pilot project
#'
#' @source \url{https://github.com/cdisc-org/sdtm-adam-pilot-project/blob/master/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm/suppds.xpt?raw=true} # nolint
"suppds"

#' Supplemental Demography Dataset
#'
#' A SDTM SUPPDM dataset from the CDISC pilot project
#'
#' @source \url{https://github.com/cdisc-org/sdtm-adam-pilot-project/blob/master/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm/suppdm.xpt?raw=true} # nolint
"suppdm"

#' Supplemental Tumor Results Dataset
#'
#' A SDTM SUPPTR dataset simulated by Gopi Vegesna
#'
#' @author Gopi Vegesna
"supptr_onco"

#' Trial Design Dataset
#'
#' A SDTM TS dataset from the CDISC pilot project
#'
#' @source \url{https://github.com/cdisc-org/sdtm-adam-pilot-project/blob/master/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm/ts.xpt?raw=true} # nolint
"ts"

#' Vital Signs Dataset
#'
#' A SDTM VS dataset from the CDISC pilot project
#'
#' @source \url{https://github.com/cdisc-org/sdtm-adam-pilot-project/blob/master/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm/vs.xpt?raw=true} # nolint
"vs"

#' SMQ Dataset
#'
#' An example SMQ dataset
#'
"smq_db"

#' SDG Dataset
#'
#' An example SDG dataset
#'
"sdg_db"

#' Subject Visits Dataset
#'
#' A SDTM SV dataset from the CDISC pilot project
#'
#' @source \url{https://github.com/cdisc-org/sdtm-adam-pilot-project/blob/master/updated-pilot-submission-package/900172/m5/datasets/cdiscpilot01/tabulations/sdtm/sv.xpt?raw=true} # nolint
"sv"

#' Demographics Dataset for Vaccine Studies
#'
#' An example SDTM DM dataset for vaccine studies
#'
#' @source \url{https://github.com/pharmaverse/admiralvaccine/blob/main/data/vx_dm.rda} # nolint
"dm_vaccine"

#' Vital Signs Dataset for Vaccine Studies
#'
#' An example SDTM VS dataset for vaccine studies
#'
#' @source \url{https://github.com/pharmaverse/admiralvaccine/blob/main/data/vx_vs.rda} # nolint
"vs_vaccine"

#' Clinical Events Dataset for Vaccine Studies
#'
#' An example SDTM CE dataset for vaccine studies
#'
#' @source \url{https://github.com/pharmaverse/admiralvaccine/blob/main/data/vx_ce.rda} # nolint
"ce_vaccine"

#' Exposures Dataset for Vaccine Studies
#'
#' An example SDTM EX dataset for vaccine studies
#'
#' @source \url{https://github.com/pharmaverse/admiralvaccine/blob/main/data/vx_ex.rda} # nolint
"ex_vaccine"

#' Immunogenicity Specimen Assessments Dataset for Vaccine Studies
#'
#' An example SDTM IS dataset for vaccine studies
#'
#' @source \url{https://github.com/pharmaverse/admiralvaccine/blob/main/data/vx_is.rda} # nolint
"is_vaccine"

#' Findings About Clinical Events Dataset for Vaccine Studies
#'
#' An example SDTM FACE dataset for vaccine studies
#'
#' @source \url{https://github.com/pharmaverse/admiralvaccine/blob/main/data/vx_face.rda} # nolint
"face_vaccine"

#' Supplemental Qualifiers for Clinical Events Dataset for Vaccine Studies
#'
#' An example SDTM SUPPCE dataset for vaccine studies
#'
#' @source \url{https://github.com/pharmaverse/admiralvaccine/blob/main/data/vx_suppce.rda} # nolint
"suppce_vaccine"

#' Supplemental Qualifiers for Demographics Dataset for Vaccine Studies
#'
#' An example SDTM SUPPDM dataset for vaccine studies
#'
#' @source \url{https://github.com/pharmaverse/admiralvaccine/blob/main/data/vx_suppdm.rda} # nolint
"suppdm_vaccine"

#' Supplemental Qualifiers for Exposures Dataset for Vaccine Studies
#'
#' An example SDTM SUPPEX dataset for vaccine studies
#'
#' @source \url{https://github.com/pharmaverse/admiralvaccine/blob/main/data/vx_suppex.rda} # nolint
"suppex_vaccine"

#' Supplemental Qualifiers for Findings About for Clinical Events Dataset for Vaccine Studies # nolint
#'
#' An example SDTM SUPPFACE dataset for vaccine studies
#'
#' @source \url{https://github.com/pharmaverse/admiralvaccine/blob/main/data/vx_suppface.rda} # nolint
"suppface_vaccine"

#' Supplemental Qualifiers for Immunogenicity Specimen Assessments Dataset for Vaccine Studies # nolint
#'
#' An example SDTM SUPPIS dataset for vaccine studies
#'
#' @source \url{https://github.com/pharmaverse/admiralvaccine/blob/main/data/vx_suppis.rda} # nolint
"suppis_vaccine"
