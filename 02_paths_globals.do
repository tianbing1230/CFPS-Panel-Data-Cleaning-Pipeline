version 15

* Centralized file path globals.
* Requires: $data_raw, $data_gen (from config.do)

* Raw inputs used by the main 2010-2020 pipeline
global f_raw_2010_famconf "$data_raw/2010_CFPS/cfps2010famconf_202008.dta"
global f_raw_2010_child "$data_raw/2010_CFPS/cfps2010child_201906.dta"
global f_raw_2010_adult "$data_raw/2010_CFPS/cfps2010adult_202008.dta"
global f_raw_2011_child "$data_raw/2011_CFPS/cfps2011child_102014.dta"
global f_raw_2011_adult "$data_raw/2011_CFPS/cfps2011adult_102014.dta"
global f_raw_2012_famconf "$data_raw/2012_CFPS/cfps2012famconf_092015.dta"
global f_raw_2012_child "$data_raw/2012_CFPS/cfps2012child_201906.dta"
global f_raw_2012_adult "$data_raw/2012_CFPS/cfps2012adult_201906.dta"
global f_raw_2014_famconf "$data_raw/2014_CFPS/cfps2014famconf_170630.dta"
global f_raw_2014_child "$data_raw/2014_CFPS/cfps2014child_201906.dta"
global f_raw_2014_adult "$data_raw/2014_CFPS/cfps2014adult_201906.dta"
global f_raw_2016_famconf "$data_raw/2016_CFPS/cfps2016famconf_201804.dta"
global f_raw_2016_child "$data_raw/2016_CFPS/cfps2016child_201906.dta"
global f_raw_2016_adult "$data_raw/2016_CFPS/cfps2016adult_201906.dta"
global f_raw_2018_famconf "$data_raw/2018_CFPS/cfps2018famconf_202008.dta"
global f_raw_2018_childproxy "$data_raw/2018_CFPS/cfps2018childproxy_202012.dta"
global f_raw_2018_person "$data_raw/2018_CFPS/cfps2018person_202012.dta"
global f_raw_2018_crossyearid "$data_raw/2018_CFPS/cfps2018crossyearid_202104.dta"
global f_raw_2020_childproxy "$data_raw/2020_CFPS/cfps2020childproxy_202112.dta"
global f_raw_2020_person "$data_raw/2020_CFPS/cfps2020person_202112.dta"

* Intermediate and final outputs
global f_out_fammember10 "$data_gen/fammember10.dta"
global f_out_fammember12 "$data_gen/fammember12.dta"
global f_out_fammember14 "$data_gen/fammember14.dta"
global f_out_fammember16 "$data_gen/fammember16.dta"
global f_out_fammember18 "$data_gen/fammember18.dta"

global f_out_pid_f "$data_gen/pid_f.dta"
global f_out_pid_m "$data_gen/pid_m.dta"
global f_out_info_f "$data_gen/info_f.dta"
global f_out_info_m "$data_gen/info_m.dta"

global f_out_cfps10_ind "$data_gen/cfps10_ind.dta"
global f_out_cfps11_ind "$data_gen/cfps11_ind.dta"
global f_out_cfps12_ind "$data_gen/cfps12_ind.dta"
global f_out_cfps14_ind "$data_gen/cfps14_ind.dta"
global f_out_cfps16_ind "$data_gen/cfps16_ind.dta"
global f_out_cfps18_ind "$data_gen/cfps18_ind.dta"
global f_out_cfps20_ind "$data_gen/cfps20_ind.dta"
global f_out_cfps_ind "$data_gen/cfps_ind.dta"
global f_out_cog "$data_gen/cog.dta"

global f_out_occedu_cfps_ind "$data_gen/cfps_ind.dta"
global f_glob_tmp_cfps_wave "$data_gen/cfps1*_ind.dta"
