# CFPS Panel Cleaning Pipeline (2010-2020)

Stata workflow for cleaning and harmonizing CFPS multi-wave individual data into an individual-level panel dataset.

## What This Repository Contains

- Stata cleaning scripts (`.do`)
- Stata helper programs (`.ado`)
  - local: `ado/local/`
  - third-party local-only: `ado/third_party/` (gitignored by default for internal testing)
- Run entrypoint: `00_run.do`
- Path template: `01_config.example.do`
- File map globals: `02_paths_globals.do`

## What This Repository Does NOT Contain

- CFPS raw data files
- CFPS redistributed data extracts
- Personal local path settings

## Quick Start

1. Prepare CFPS raw data locally (according to your data-use permission).
2. Copy `01_config.example.do` to `config.do`.
3. Edit `config.do`:
   - `global data_raw`: CFPS raw data root folder
   - `global data_gen`: output folder for cleaned files (recommended: `generated_data/`)
4. Check `02_paths_globals.do` and adjust file names if your local raw-file versions differ.
5. Run `00_run.do` in Stata.

## Expected Main Outputs

- `cfps10_ind.dta`
- `cfps12_ind.dta`
- `cfps14_ind.dta`
- `cfps16_ind.dta`
- `cfps18_ind.dta`
- `cfps20_ind.dta`
- `cfps_ind.dta`
- `cog.dta`

By default recommendation, these generated files are stored under `generated_data/`.

## Data Coverage

- This release is an individual-level panel dataset with 2010/2012/2014/2016/2018/2020 waves (`wave`) and person-level identifiers (`pid`, `fid`, `cid`, `countyid`, `provcd`).
- Coverage follows the codebook in `data_dictionary/01_individual.csv` and includes major domains: identifiers, basic demographics, education, labor-market outcomes, income, family socioeconomic status, cognitive/non-cognitive/language abilities, marriage/family, health, religion, and political experience/attitudes.
- Family linkage information is retained at the individual record level via parent/spouse linkage variables, including `pid_f`, `pid_m`, `pid_s`, and linked attributes such as `fedu`, `medu`, `focctype_isco`, `mocctype_isco`, `foccisei`, `moccisei`, `sedu`, `socctype_isco`, `soccisei`.
- Child-related family context is included through `nchild` (number of children), alongside broader family-status and background variables.

## Notes

- `00_run.do` runs the full individual-level pipeline in sequence: `11_CFPS_Panel_Ind10.do` -> `13_CFPS_Panel_Ind12.do` -> `14_CFPS_Panel_Ind14.do` -> `15_CFPS_Panel_Ind16.do` -> `16_CFPS_Panel_Ind18.do` -> `17_CFPS_Panel_Ind20.do` -> `20_CFPS_Panel_Individual_Crosswave.do` -> `30_CFPS_Panel_Individual_Labels.do`.
- Recommended entrypoint for current workflow: `00_run.do`.
- Third-party local notice file is stored at `ado/third_party/THIRD_PARTY_NOTICES.local.md` (not uploaded by default).
- `00_run.do` checks for required third-party dependency (`iskoisei`) and will stop with guidance if missing.

## Core Cleaning Logic

The core workflow aligns with the variable coverage and harmonization scheme documented in `data_dictionary/01_individual.csv`.

- This release is focused on the `individual` panel pipeline only.
- Cleaning starts from the 2010 wave (2011 is not treated as a core standalone wave in this release).
- For later waves (2012/2014/2016/2018/2020), variables are cross-wave harmonized; missing values are filled from adjacent or later waves when appropriate, including selected back-corrections based on later-wave consistency checks.
- Individual-level records are constructed by combining child and adult questionnaire sources to retain all eligible respondents.
- The final deliverable is a long-format panel keyed by individual ID and wave/year, then consolidated into panel output files.

Codebook and labeling:

- Two label sets are provided: Chinese and English.
- Value-label naming is kept consistent with variable naming conventions.

Missing-value handling:

- Missingness is reduced through cross-wave imputation where methodologically appropriate.
- Original negative missing codes from source files are converted to Stata-standard missing values (`.`).

## Codebook in Open Formats

- Codebook files are stored in `data_dictionary/` only.
- Format:
  - one CSV per worksheet
  - `codebook_manifest.json` for sheet/file mapping and basic metadata

## Citation

If this repository is useful for your research, we recommend citing this GitHub project as the data-processing pipeline, and citing the official CFPS data source according to CFPS citation requirements.

## Scope and Disclaimer

Cleaning CFPS panel data is non-trivial. This repository is open-sourced to share a practical workflow built for prior research use.

This pipeline was written before the recent "vibe coding" wave and is largely hand-crafted Stata code, with substantial manual checks and iterative validation of variable-level details.
The GitHub release preparation and repository packaging were completed with support from vibe coding practices and Codex.

Please note:

- This release does not use the latest CFPS public release.
- Recent survey years are not yet integrated in this pipeline.
- If you need newer waves, you can extend this workflow based on the current structure, or use it as a reference and implement your own updates.
- The code uses extensive cross-wave integration and missing-data completion in multiple places. Please inspect the do-files carefully and evaluate whether each rule fits your research design.

This project is provided as is, without warranty. Users are responsible for reviewing the code, validating outputs, and ensuring consistency with official CFPS documentation and their own research needs.

If you find issues or have questions, feel free to contact me.
