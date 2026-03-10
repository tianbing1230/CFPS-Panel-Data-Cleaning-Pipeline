version 15

* Copy this file to config.do and edit the paths below.
* This file is intentionally ignored by git once copied to config.do.

* Folder containing raw CFPS source files by wave, e.g. 2010_CFPS/, 2012_CFPS/
global data_raw "/path/to/cfps_raw_data_root"

* Folder for intermediate/final outputs (cfps10_ind.dta ... cfps_ind.dta)
* Recommended: use project-local generated_data/ folder.
global data_gen "/path/to/project/generated_data"

* Data file-level globals are centralized in scripts/02_paths_globals.do.
