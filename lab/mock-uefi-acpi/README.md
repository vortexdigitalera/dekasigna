# Mock UEFI/ACPI device tree for lab testing

This folder contains a safe, non-invasive mock device tree that can be used to simulate firmware-visible device metadata in a lab environment.

## Purpose

This is not a real firmware patch and does not alter Windows security protections. It is only intended for:

- studying how firmware tables and device descriptors are structured
- testing parser or log collection workflows
- experimenting with lab automation around Secure Boot or Memory Integrity reporting

## Contents

- `mock-device-tree.asl` — a simple ACPI-like device definition for testing
- `mock-uefi-device.json` — a mock UEFI device inventory structure
