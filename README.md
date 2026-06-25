# dekasigna

This repository builds a bootable USB image for firmware, boot, and compatibility experiments on a wide range of x86 systems. The content is organized as a general lab toolkit for UEFI/firmware diagnostics, Secure Boot observation, and compatibility research rather than a single-OS installer.

## Build feature categories

### 1. Firmware and Secure Boot lab tools
- UEFI Shell launchers and a guided auto-executor for PK/KEK/db/dbx inspection
- A factory-style firmware patch assistant for lab and recovery scenarios
- Safe helper scripts for key-management experiments and backup planning
- PowerShell utilities that mirror Microsoft-style Secure Boot verification and validation steps

### 2. Boot and recovery helpers
- A Rufus-assisted write workflow for preparing the USB image on Windows systems
- UEFI Shell helpers for backup, inspection, and controlled firmware-state experiments

### 3. Compatibility and emulation experiments
- A lab-only mock UEFI/ACPI device tree for safe experiments
- A Windows lab script that records Secure Boot and Memory Integrity observations without changing real protections
- A compatibility lab package for older hardware-style experiments and hardware notes

### 4. Packaging and automation
- A GitHub Actions workflow that produces a FAT32 image plus a ZIP archive

## Recommended use

This project is best used in one of these modes:

1. Firmware diagnostics and backup workflows
2. Secure Boot and key-database observation in a lab environment
3. Compatibility exploration for older hardware and boot scenarios
4. Mock device-tree and firmware-reporting experiments

## Safety notes

- This project is for diagnostics and controlled experiments only.
- Do not write unsigned firmware capsules or OEM signing material without proper vendor and platform processes.
- Always back up UEFI variables before any firmware write.
- Never assume a custom key set is safe for production without validation and rollback.

## Build locally

```bash
bash scripts/build-usb.sh
```

Artifacts are placed in the `artifacts/` directory.

## Validation and verification

On a Windows test system, use the included PowerShell helpers after booting normally:

```powershell
powershell -ExecutionPolicy Bypass -File windows/verify-secureboot.ps1
powershell -ExecutionPolicy Bypass -File windows/query-version-and-status.ps1
powershell -ExecutionPolicy Bypass -File windows/fix-secureboot-update.ps1
powershell -ExecutionPolicy Bypass -File windows/hp-9470m-secureboot-checklist.ps1
powershell -ExecutionPolicy Bypass -File windows/rufus-write-assist.ps1 -ImagePath .\dekasigna-usb.img
powershell -ExecutionPolicy Bypass -File windows/log-secureboot-memory-integrity.ps1
powershell -ExecutionPolicy Bypass -File windows/hackintosh-9470m-lab-report.ps1
powershell -ExecutionPolicy Bypass -File windows/local-lab-report.ps1
powershell -ExecutionPolicy Bypass -File validation/run-validation.ps1
```

These scripts are intended to support validation and reporting workflows, not to replace vendor-supported firmware update tools or production deployment methods.
