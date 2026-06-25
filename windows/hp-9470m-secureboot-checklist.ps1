[CmdletBinding()]
param(
    [string]$LogPath = "$env:TEMP\dekasigna-hp-9470m-secureboot-checklist.txt"
)

$ErrorActionPreference = 'Stop'

Write-Host 'Creating HP EliteBook Folio 9470m Secure Boot checklist...'

$report = [System.Collections.Generic.List[string]]::new()
$report.Add('HP EliteBook Folio 9470m Secure Boot remediation checklist')
$report.Add("Timestamp: $(Get-Date -Format o)")
$report.Add('')
$report.Add('1. Confirm the current firmware version and model:')
$report.Add('   - BIOS/firmware should be checked from the HP support page for 9470m.')
$report.Add('   - The reported firmware version in your message is 68IBD Ver. F.73.')
$report.Add('')
$report.Add('2. Install the latest official HP BIOS/firmware update for the 9470m from HP support.')
$report.Add('   - Prefer the official SoftPaq or BIOS update package from HP.')
$report.Add('   - Do not use third-party or modified firmware images.')
$report.Add('')
$report.Add('3. Reboot and re-check Secure Boot state.')
$report.Add('   - Run Windows Update again after reboot.')
$report.Add('   - Re-check whether KEK 2023 and 3P UEFI CA 2023 can be applied.')
$report.Add('')
$report.Add('4. If the updates remain blocked, collect and share the following:')
$report.Add('   - BIOS version reported by HP firmware tools or System Information.')
$report.Add('   - Screenshot of the Windows Security > Device security > Secure Boot message.')
$report.Add('   - The exact Windows Update error text for KEK 2023 / 3P UEFI CA 2023.')
$report.Add('')
$report.Add('5. If the firmware is already current and the issue persists:')
$report.Add('   - Contact HP support and ask whether the current firmware supports the KEK 2023 / 3P UEFI CA 2023 update path.')
$report.Add('   - Ask whether a newer BIOS revision exists for this specific platform.')
$report.Add('')
$report.Add('Important: This checklist is for diagnostics and safe recovery planning. Do not change PK/KEK/db/dbx without a validated backup and rollback plan.')

$report | Set-Content -Path $LogPath -Encoding UTF8
Write-Host "Checklist saved to $LogPath"
