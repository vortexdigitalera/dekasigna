# Compatibility template for 9470m lab experiments

## Platform summary
- Device: HP EliteBook Folio 9470m
- CPU: Intel 4th-gen Core / Haswell-era
- Graphics: Intel HD 4400
- Storage: SATA/SSD depending on configuration
- Wireless: model-dependent

## Boot and firmware notes
- UEFI boot support is important.
- Preserve firmware variable backups before any test.
- Keep a fallback boot method available.

## Compatibility checklist
- [ ] Bootloader/EFI support
- [ ] Graphics framebuffer behavior
- [ ] USB mapping and power management
- [ ] Audio support
- [ ] Wi-Fi/Bluetooth support
- [ ] SSDT/ACPI sanity
- [ ] Boot order and driver validation

## Lab observations
- Record what works and what fails.
- Keep screenshots and logs.
- Avoid changing production firmware settings without a rollback plan.
