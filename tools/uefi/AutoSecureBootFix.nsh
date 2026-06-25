echo ===== Auto Secure Boot Fix =====
echo Microsoft Secure Boot guidance reminder:
echo - PK, KEK, db, and dbx are the core security databases.
echo - Preferred recovery is to keep Microsoft keys and use supported firmware channels.
echo - Lab experiments should be backed up and rolled back carefully.

echo Checking PK...
dmpstore PK > NUL
if %lasterror% != 0 then
  echo SETUP MODE detected (no PK). Recommend: BIOS -> Security -> Restore Factory Keys.
  goto done
endif

echo USER MODE detected.

echo Checking KEK...
dmpstore KEK > NUL
if %lasterror% != 0 then
  echo KEK missing or corrupted.
endif

echo Checking db...
dmpstore db > NUL
echo Checking dbx...
dmpstore dbx > NUL

echo Backing up variables to FS0:\SecureBootBackup if possible...
if not exist FS0:\SecureBootBackup then
  mkdir FS0:\SecureBootBackup
endif

dmpstore PK > FS0:\SecureBootBackup\PK.bin
ndmpstore KEK > FS0:\SecureBootBackup\KEK.bin
ndmpstore db > FS0:\SecureBootBackup\db.bin
ndmpstore dbx > FS0:\SecureBootBackup\dbx.bin

echo If KEK/db/dbx are missing, either restore factory keys or run UpdateKeys.nsh if you prepared auth files.
echo Do not use custom signing material in production until validation and rollback are complete.
if exist FS0:\UpdateKeys.nsh then
  echo Running UpdateKeys.nsh...
  FS0:\UpdateKeys.nsh
endif

:done
echo ===== Done =====
