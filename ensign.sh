#!/usr/bin/env bash
set -e

DB_KEY="secureboot-custom/DB.key"
DB_CRT="secureboot-custom/DB.crt"

INPUT_EFI="bootx64.efi"
OUTPUT_EFI="bootx64.signed.efi"

sbsign --key "$DB_KEY" --cert "$DB_CRT" --output "$OUTPUT_EFI" "$INPUT_EFI"

echo "[*] Signed EFI written to: $OUTPUT_EFI"
