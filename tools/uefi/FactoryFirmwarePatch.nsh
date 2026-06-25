echo ===== Factory-style Firmware Patch Assistant =====
echo This helper is intended for lab and recovery use only.
echo It is not a substitute for OEM firmware signing, Microsoft-supported deployment, or official HP BIOS updates.
echo

echo Creating backup folder on the USB device...
if not exist FS0:\FirmwareBackup then
  mkdir FS0:\FirmwareBackup
endif

echo Backing up firmware variables with dmpstore...
dmpstore PK > FS0:\FirmwareBackup\PK.bin
dmpstore KEK > FS0:\FirmwareBackup\KEK.bin
dmpstore db > FS0:\FirmwareBackup\db.bin
dmpstore dbx > FS0:\FirmwareBackup\dbx.bin

echo Backups written to FS0:\FirmwareBackup

echo

echo Inspecting current firmware state...
dmpstore PK > NUL
dmpstore KEK > NUL
dmpstore db > NUL
dmpstore dbx > NUL

echo

echo Suggested OEM-like workflow:
echo 1. Keep Microsoft keys intact if possible.
echo 2. Use supported firmware update or recovery channels.
echo 3. Only alter PK/KEK/db/dbx in a controlled lab environment.
echo 4. Preserve rollback data and boot order information.
echo

echo Optional custom driver boot fix checklist:
echo - Review BootOrder and DriverOrder if booting a custom driver fails.
echo - Verify that the custom driver is signed and compatible with the platform.
echo - Reboot only after the driver has been validated and the backup is preserved.
echo

echo ===== End =====
