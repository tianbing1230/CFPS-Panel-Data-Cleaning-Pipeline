version 15

*********************************************
** CFPS: INDIVIDUAL-YEAR PANEL (2010-2020) **
**              BY Bing TIAN               **
*********************************************

**********************************
* Preamble
**********************************
	capture clear all
	set more off

	* Path config should be loaded by 00_run.do via config.do.
	* Fallback defaults only for safer standalone execution.
	if "$data_gen" == "" {
		global data_gen "`c(pwd)'"
	}
	if "$data_raw" == "" {
		di as error "Global macro data_raw is not set. Please copy 01_config.example.do to config.do and edit paths."
		exit 198
	}
	cap mkdir "$data_gen"
	cd "$data_gen"
	
	
	
**=========================================**
**Some Variables Needing Special Correction**
**=========================================**

**********************************
* Parents & Spouse Information
**********************************	
	* dataset for parents' / spouse's id
	local relative f m
	forvalues i=1/2 {
		local j: word `i' of `relative'
		
		use "$data_gen/cfps10_ind.dta", clear
		keep pid pid_`j'_10
		rename pid_`j'_10 pid_`j'
		save $data_gen/pid_`j', replace
		
		use "$data_gen/cfps12_ind.dta", clear
		keep pid pid_`j'_12
		rename pid_`j'_12 pid_`j'
		merge 1:1 pid using $data_gen/pid_`j', nogen
		save $data_gen/pid_`j', replace
				
		use "$data_gen/cfps14_ind.dta", clear
		keep pid pid_`j'_14
		rename pid_`j'_14 pid_`j'
		merge 1:1 pid using $data_gen/pid_`j', nogen
		save $data_gen/pid_`j', replace
				
		use "$data_gen/cfps16_ind", clear
		keep pid pid_`j'_16
		rename pid_`j'_16 pid_`j'
		merge 1:1 pid using $data_gen/pid_`j', nogen
		save $data_gen/pid_`j', replace

		use "$data_gen/cfps18_ind", clear
		keep pid pid_`j'_18
		rename pid_`j'_18 pid_`j'
		merge 1:1 pid using $data_gen/pid_`j', nogen
		save $data_gen/pid_`j', replace
	}		
	* personal information for parents' / spouse's that are surveyed
	local relative f m
	forvalues i=1/2 {
		local j: word `i' of `relative'
		
		use "$data_gen/cfps10_ind.dta", clear
		keep pid edu_10 occtype_isco_10 occisei_10 ccp_10
		rename pid pid_`j'
		rename *_10 `j'*		
		merge 1:m pid_`j' using $data_gen/pid_`j', keep(match) nogen
		save $data_gen/info_`j', replace

		use "$data_gen/cfps12_ind.dta", clear
		keep pid edu_12 occtype_isco_12 occisei_12 ccp_12
		rename pid pid_`j'
		rename *_12 `j'*
		merge 1:m pid_`j' using $data_gen/pid_`j', keep(match) nogen
		merge 1:1 pid using $data_gen/info_`j', nogen update
		save $data_gen/info_`j', replace

		use "$data_gen/cfps14_ind.dta", clear
		keep pid edu_14 occtype_isco_14 occisei_14 ccp_14
		rename pid pid_`j'
		rename *_14 `j'*
		merge 1:m pid_`j' using $data_gen/pid_`j', keep(match) nogen
		merge 1:1 pid using $data_gen/info_`j', nogen update
		save $data_gen/info_`j', replace
		
		use "$data_gen/cfps16_ind.dta", clear
		keep pid edu_16 occtype_isco_16 occisei_16 ccp_16
		rename pid pid_`j'
		rename *_16 `j'*
		merge 1:m pid_`j' using $data_gen/pid_`j', keep(match) nogen
		merge 1:1 pid using $data_gen/info_`j', nogen update
		save $data_gen/info_`j', replace

		use "$data_gen/cfps18_ind.dta", clear
		keep pid edu_18 occtype_isco_18 occisei_18 ccp_18
		rename pid pid_`j'
		rename *_18 `j'*
		merge 1:m pid_`j' using $data_gen/pid_`j', keep(match) nogen
		merge 1:1 pid using $data_gen/info_`j', nogen update
		save $data_gen/info_`j', replace
	}	
	*
	foreach wave in 10 12 14 16 18 {
		use "$data_gen/cfps`wave'_ind.dta", clear
		rename *_`wave' *
		merge 1:1 pid using $data_gen/info_f, keep(1 3 4 5) nogen update
		merge 1:1 pid using $data_gen/info_m, keep(1 3 4 5) nogen update
		rename * *_`wave'
		rename pid_`wave' pid
		save "$data_gen/cfps`wave'_ind.dta", replace
	}
		
**********************************
* Correct Previous Waves Using New Ones for Time-Invariant Variables
**********************************		
	
* Wave 2010
	use "$data_gen/cfps10_ind.dta", clear
	foreach wave in 12 14 16 18 20 {
		merge 1:1 pid using "$data_gen/cfps`wave'_ind.dta", keep(master match) nogen
		foreach var in birthy_ gender_ han_ birthprov_ yresprov_ yhukou_ nsib_ fedu_ medu_ focctype_isco_ mocctype_isco_ foccisei_ moccisei_ fccp_ mccp_ {
			dis "`var'"
			replace `var'10 = `var'`wave' if `var'10 ==.
		}
	}
	keep pid *_10
	save "$data_gen/cfps10_ind.dta", replace
	
* Wave 2012
	use "$data_gen/cfps12_ind.dta", clear
	foreach wave in 14 16 18 20 {
		merge 1:1 pid using "$data_gen/cfps`wave'_ind.dta", keep(master match) nogen
		foreach var in birthy_ gender_ han_ birthprov_ yresprov_ yhukou_ nsib_ fedu_ medu_ focctype_isco_ mocctype_isco_ foccisei_ moccisei_ fccp_ mccp_ {
			dis "`var'"
			replace `var'12 = `var'`wave' if `var'12 ==.
		}
	}
	keep pid *_12
	save "$data_gen/cfps12_ind.dta", replace
	
* Wave 2014
	use "$data_gen/cfps14_ind.dta", clear
	foreach wave in 16 18 20 {
		merge 1:1 pid using "$data_gen/cfps`wave'_ind.dta", keep(master match) nogen
		foreach var in birthy_ gender_ han_ birthprov_ yresprov_ yhukou_ nsib_ fedu_ medu_ focctype_isco_ mocctype_isco_ foccisei_ moccisei_ fccp_ mccp_ {
			dis "`var'"
			replace `var'14 = `var'`wave' if `var'14 ==.
		}
	}
	keep pid *_14
	save "$data_gen/cfps14_ind.dta", replace

* Wave 2016
	use "$data_gen/cfps16_ind.dta", clear
	foreach wave in 18 20 {
		merge 1:1 pid using "$data_gen/cfps`wave'_ind.dta", keep(master match) nogen
		foreach var in birthy_ gender_ han_ birthprov_ yresprov_ yhukou_ nsib_ fedu_ medu_ focctype_isco_ mocctype_isco_ foccisei_ moccisei_ fccp_ mccp_ {
			dis "`var'"
			replace `var'16 = `var'`wave' if `var'16 ==.
		}
	}
	keep pid *_16
	save "$data_gen/cfps16_ind.dta", replace

* Wave 2018
	use "$data_gen/cfps18_ind.dta", clear
	foreach wave in 20 {
		merge 1:1 pid using "$data_gen/cfps`wave'_ind.dta", keep(master match) nogen
		foreach var in birthy_ gender_ han_ birthprov_ yresprov_ yhukou_ nsib_ fedu_ medu_ focctype_isco_ mocctype_isco_ foccisei_ moccisei_ fccp_ mccp_ {
			dis "`var'"
			replace `var'18 = `var'`wave' if `var'18 ==.
		}
	}
	keep pid *_18
	save "$data_gen/cfps18_ind.dta", replace



**========================================**
**         Panel Data Generation          **
**========================================**
*  Rename Variables in Single-Wave Dataset
	foreach wave in 10 12 14 16 18 20 {
		use "$data_gen/cfps`wave'_ind.dta", clear
		rename *_`wave' *
		save "$data_gen/cfps`wave'_ind.dta", replace
	}
*	Append into Panel Data
	clear
	foreach wave in 10 12 14 16 18 20 {
		append using "$data_gen/cfps`wave'_ind.dta"
	}
*	Save Data
	sort pid
	order pid
	compress
	save "$data_gen/cfps_ind.dta", replace


**********************************
* Cognitive ability
**********************************

use "$data_gen/cfps_ind", clear
keep wave pid word math iwr dwr ns_g ns_w
reshape wide word math iwr dwr ns_g ns_w, i(pid) j(wave)

foreach var in word math {
	drop `var'12
	egen `var'12 = rowmean(`var'10 `var'14)
	foreach wave in 10 14 18 {
		replace `var'12 = `var'`wave' if `var'12==.
	}

	drop `var'16
	egen `var'16 = rowmean(`var'14 `var'18)
	foreach wave in 14 18 10 {
		replace `var'16 = `var'`wave' if `var'16==.
	}

	foreach wave in 18 14 10 {
		replace `var'20 = `var'`wave' if `var'20==.
	}
}


foreach var in iwr dwr ns_g ns_w {
    drop `var'14
    egen `var'14 = rowmean(`var'12 `var'16)
    foreach wave in 12 16 20 {
		replace `var'14 = `var'`wave' if `var'14==.
	}

	drop `var'18
	egen `var'18 = rowmean(`var'16 `var'20)
	foreach wave in 16 20 12 {
		replace `var'18 = `var'`wave' if `var'18==.
	}

	foreach wave in 12 16 20 {
		replace `var'10 = `var'`wave' if `var'10==.
	}
}

reshape long word math iwr dwr ns_g ns_w, i(pid) j(wave)
gen double pidwave = pid*100+wave
format pidwave %14.0g
save cog, replace

use "$data_gen/cfps_ind", clear
gen double pidwave = pid*100+wave
format pidwave %14.0g
merge 1:1 pidwave using cog, keep(1 3 4 5) update nogen
drop pidwave
save "$data_gen/cfps_ind", replace

	
