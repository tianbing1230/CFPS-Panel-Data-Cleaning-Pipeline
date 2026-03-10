version 15

* Entry point for CFPS panel cleaning pipeline.
* 1) Copy scripts/01_config.example.do to scripts/config.do and edit paths.
* 2) From project root, run do "scripts/00_run.do" in Stata.

capture noisily do "scripts/config.do"
if _rc {
    di as error "Cannot load scripts/config.do. Please copy scripts/01_config.example.do to scripts/config.do and update paths."
    exit 601
}

capture noisily do "scripts/02_paths_globals.do"
if _rc {
    di as error "Cannot load scripts/02_paths_globals.do."
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

capture noisily do "scripts/11_CFPS_Panel_Ind10.do"
if _rc {
    di as error "Failed in 11_CFPS_Panel_Ind10.do"
    exit 610
}

capture noisily do "scripts/13_CFPS_Panel_Ind12.do"
if _rc {
    di as error "Failed in 13_CFPS_Panel_Ind12.do"
    exit 611
}

capture noisily do "scripts/14_CFPS_Panel_Ind14.do"
if _rc {
    di as error "Failed in 14_CFPS_Panel_Ind14.do"
    exit 612
}

capture noisily do "scripts/15_CFPS_Panel_Ind16.do"
if _rc {
    di as error "Failed in 15_CFPS_Panel_Ind16.do"
    exit 613
}

capture noisily do "scripts/16_CFPS_Panel_Ind18.do"
if _rc {
    di as error "Failed in 16_CFPS_Panel_Ind18.do"
    exit 614
}

capture noisily do "scripts/17_CFPS_Panel_Ind20.do"
if _rc {
    di as error "Failed in 17_CFPS_Panel_Ind20.do"
    exit 615
}

capture noisily do "scripts/20_CFPS_Panel_Individual_Crosswave.do"
if _rc {
    di as error "Failed in 20_CFPS_Panel_Individual_Crosswave.do"
    exit 616
}

capture noisily do "scripts/30_CFPS_Panel_Individual_Labels.do"
if _rc {
    di as error "Failed in 30_CFPS_Panel_Individual_Labels.do"
    exit 617
}
