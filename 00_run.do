version 15

* Entry point for CFPS panel cleaning pipeline.
* 1) Copy 01_config.example.do to config.do and edit paths.
* 2) Run this file in Stata.

capture noisily do "config.do"
if _rc {
    di as error "Cannot load config.do. Please copy 01_config.example.do to config.do and update paths."
    exit 601
}

capture noisily do "02_paths_globals.do"
if _rc {
    di as error "Cannot load 02_paths_globals.do."
    exit 602
}

* Add project ado directories.
adopath ++ "ado/local"
adopath ++ "ado/third_party"

* Third-party dependency check.
capture which iskoisei
if _rc {
    di as error "Missing third-party ado: iskoisei."
    di as error "This repository does not redistribute it."
    di as error "Please provide your own iskoisei.ado under ado/third_party or implement an alternative conversion method."
    exit 604
}

capture noisily do "11_CFPS_Panel_Ind10.do"
if _rc {
    di as error "Failed in 11_CFPS_Panel_Ind10.do"
    exit 610
}

capture noisily do "13_CFPS_Panel_Ind12.do"
if _rc {
    di as error "Failed in 13_CFPS_Panel_Ind12.do"
    exit 611
}

capture noisily do "14_CFPS_Panel_Ind14.do"
if _rc {
    di as error "Failed in 14_CFPS_Panel_Ind14.do"
    exit 612
}

capture noisily do "15_CFPS_Panel_Ind16.do"
if _rc {
    di as error "Failed in 15_CFPS_Panel_Ind16.do"
    exit 613
}

capture noisily do "16_CFPS_Panel_Ind18.do"
if _rc {
    di as error "Failed in 16_CFPS_Panel_Ind18.do"
    exit 614
}

capture noisily do "17_CFPS_Panel_Ind20.do"
if _rc {
    di as error "Failed in 17_CFPS_Panel_Ind20.do"
    exit 615
}

capture noisily do "20_CFPS_Panel_Individual_Crosswave.do"
if _rc {
    di as error "Failed in 20_CFPS_Panel_Individual_Crosswave.do"
    exit 616
}

capture noisily do "30_CFPS_Panel_Individual_Labels.do"
if _rc {
    di as error "Failed in 30_CFPS_Panel_Individual_Labels.do"
    exit 617
}
