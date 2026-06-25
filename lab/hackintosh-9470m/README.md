# HP EliteBook Folio 9470m hackintosh lab notes

This folder collects lab-safe notes and templates for older macOS-style experiments on the HP EliteBook Folio 9470m.

## Hardware profile

The 9470m is commonly associated with:

- Intel 4th generation Core processor (Haswell-era platform)
- Intel HD 4400 integrated graphics
- SATA or SSD-based storage depending on the exact unit
- Broadcom wireless hardware that may require extra support for modern macOS versions
- USB 3 and Intel-based networking that may need careful kext and ACPI support

## Lab focus areas

For compatibility discussions in a lab, the highest-value areas are:

- bootloader and UEFI compatibility
- graphics framebuffer workarounds
- USB mapping and power management
- audio layout patches
- WLAN/BT support strategy
- storage and SSDT handling

## Safety note

These notes are for education and controlled experimentation only. They do not replace vendor-supported firmware or OS installation guidance.
