# Libreboot lab risk matrix

Use this matrix to classify firmware or flash experiments by risk before attempting any procedure.

## Risk scoring

- 1 = Low risk: documentation-only, no firmware write, no security state change
- 2 = Moderate risk: backup and validation steps only, no flash performed
- 3 = Elevated risk: firmware image inspection, recovery planning, or controlled tool evaluation
- 4 = High risk: flashing firmware, changing boot paths, or altering platform security state
- 5 = Critical risk: production device, irreversible change, or unknown vendor support

## Suggested categories

- Backup and documentation: 1-2
- Lab validation and report collection: 2-3
- Controlled firmware image review: 3-4
- Actual flashing or boot-path changes: 4-5

## Minimum safeguards by score

- Score 1-2: basic backup and notes
- Score 3: full backup, validated rollback plan, lab-only environment
- Score 4-5: vendor support confirmation, recovery media, and explicit approval

## Example entries

- Read-only firmware metadata review: 2
- Backup and variable export: 2
- Flash tool evaluation with known-good image: 3
- Flashing a test image on supported hardware: 4
- Flashing on unsupported or production hardware: 5
