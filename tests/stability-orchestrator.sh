#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

if command -v sudo >/dev/null 2>&1; then
  SUDO=sudo
else
  SUDO=''
fi

printf '[1/6] Checking shell syntax...\n'
bash -n scripts/build-usb.sh
echo 'bash -n tests/test-build-iso.sh'
bash -n tests/test-build-iso.sh
bash -n tests/stability-orchestrator.sh

printf '[2/6] Installing runtime toolchain...\n'
$SUDO apt-get update >/dev/null
$SUDO DEBIAN_FRONTEND=noninteractive apt-get install -y grub-pc-bin grub-efi-amd64-bin xorriso mtools dosfstools zip shellcheck >/dev/null

printf '[3/6] Linting shell scripts...\n'
shellcheck scripts/build-usb.sh tests/test-build-iso.sh tests/stability-orchestrator.sh

printf '[4/6] Building release artifacts...\n'
rm -rf artifacts
bash scripts/build-usb.sh

printf '[5/6] Running artifact smoke tests...\n'
[ -s artifacts/dekasigna-uefi.iso ]
[ -s artifacts/dekasigna-uefi.zip ]
xorriso -indev artifacts/dekasigna-uefi.iso -toc 2>/dev/null | grep -q 'BOOTX64.EFI'

printf '[6/6] Stability orchestrator passed.\n'
