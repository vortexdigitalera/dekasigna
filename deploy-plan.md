# Deploy Plan: USB Compatibility and Firmware Lab Image

## Purpose

Build a single GitHub repository and CI pipeline that produces a bootable amd64 Intel UEFI-first ISO image (ZIP + ISO) containing UEFI Shell, firmware diagnostics scripts, Secure Boot observation helpers, mock device-tree assets, and Windows-friendly verification tools for general compatibility experiments.

## Repository layout

```text
dekasigna/
├─ README.md
├─ deploy-plan.md
├─ tools/
│  ├─ uefi/Shell.efi
│  ├─ uefi/AutoSecureBootFix.nsh
│  ├─ uefi/FactoryFirmwarePatch.nsh
│  ├─ uefi/UpdateKeys.nsh
│  └─ uefi/usb-layout.txt
├─ generators/
│  ├─ hp-customer-keys.sh
│  └─ usermode-pk.sh
├─ validation/
│  ├─ ms-uefi-validation/README.md
│  └─ run-validation.ps1
├─ windows/
│  ├─ block-ms-dbx.ps1
│  ├─ fix-secureboot-update.ps1
│  ├─ hp-9470m-secureboot-checklist.ps1
│  ├─ query-version-and-status.ps1
│  ├─ rufus-write-assist.ps1
│  └─ verify-secureboot.ps1
├─ .github/
│  └─ workflows/
│     └─ build.yml
└─ artifacts/
```

## Operational flow

1. Download the CI artifact and extract it.
2. Write the ISO file to a USB drive with UEFI/ISO mode.
3. Boot the target PC from the USB device.
4. Use the appropriate helper set based on the task category:
   - firmware and Secure Boot observation
   - boot and recovery helpers
   - compatibility and mock-device experiments
5. Run the UEFI Shell auto-executor and inspect PK/KEK/db/dbx state when relevant.
6. Preserve backups of firmware state before changing anything.
7. Use the Windows verification scripts to collect reports and document findings.

## Feature categories

- Firmware and Secure Boot lab tools
- Boot and recovery helpers
- Compatibility and emulation experiments
- Packaging and automation

## Safety and platform alignment

- Back up UEFI variables before any writes.
- Keep rollback options ready using BIOS recovery and vendor firmware images when available.
- Use the Secure Boot hierarchy as a reference when relevant: PK, KEK, db, dbx.
- Prefer supported firmware update or OEM recovery channels for real platform changes.
- Treat custom key updates and mock-device experiments as lab-only until validation and rollback are complete.
