# Contributing

## Workflow

1. Create a branch for your change.
2. Keep changes minimal and script-focused.
3. Do not commit any raw or processed CFPS `.dta` files.
4. Update `README.md` if behavior/output changes.

## Code Style

- Prefer explicit variable naming and wave suffix handling.
- Keep comments concise for non-obvious transformations.
- Avoid hardcoded machine-specific absolute paths.

## Reproducibility

- New scripts should run through `run.do` or be clearly documented.
- Any new required input files must be documented in `README.md`.
