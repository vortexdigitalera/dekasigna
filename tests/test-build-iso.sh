#!/usr/bin/env bash
set -euo pipefail
repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"
rm -rf artifacts
bash scripts/build-usb.sh
iso_path="$repo_root/artifacts/dekasigna-uefi.iso"
if [ ! -f "$iso_path" ]; then
  echo "Expected ISO artifact not found: $iso_path" >&2
  exit 1
fi
if ! file "$iso_path" | grep -qi 'ISO 9660'; then
  echo "Generated artifact is not an ISO image" >&2
  exit 1
fi
if ! xorriso -indev "$iso_path" -toc 2>/dev/null | grep -q 'BOOTX64.EFI'; then
  echo "Generated ISO does not contain the expected EFI bootloader entry" >&2
  exit 1
fi
