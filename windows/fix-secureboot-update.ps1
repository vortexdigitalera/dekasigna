[CmdletBinding()]
param(
    [switch]$OpenSupportPages,
    [string]$LogPath = "$env:TEMP\dekasigna-hp-secureboot-remediation.txt"
)

$ErrorActionPreference = 'Stop'

Write-Host 'Preparing HP Secure Boot remediation guidance for Windows 11...'

$report = [System.Collections.Generic.List[string]]::new()
$report.Add('HP Secure Boot remediation guidance')
$report.Add("Timestamp: $(Get-Date -Format o)")
$report.Add("OS: $([System.Environment]::OSVersion.VersionString)")

try {
    $secureBoot = Confirm-SecureBootUEFI
    $report.Add("Confirm-SecureBootUEFI: $secureBoot")
    Write-Host "Secure Boot enabled: $secureBoot"
} catch {
    $report.Add("Confirm-SecureBootUEFI unavailable: $($_.Exception.Message)")
    Write-Warning 'Confirm-SecureBootUEFI is unavailable in this session.'
}

try {
    $bios = Get-CimInstance -ClassName Win32_BIOS
    $report.Add("BIOS Manufacturer: $($bios.Manufacturer)")
    $report.Add("BIOS Version: $($bios.SMBIOSBIOSVersion)")

    $system = Get-CimInstance -ClassName Win32_ComputerSystem
    $report.Add("Model: $($system.Model)")
} catch {
    $report.Add("Hardware query failed: $($_.Exception.Message)")
}

$report.Add('')
$report.Add('Recommended remediation for the HP 9470m / Windows 11 issue:')
$report.Add('- Install the latest official HP BIOS/firmware update from the HP support site for this specific model.')
$report.Add('- Do not use third-party BIOS files or beta firmware for production recovery.')
$report.Add('- After updating BIOS, restart and run Windows Update again so the KEK 2023 and 3P UEFI CA 2023 updates can be evaluated.')
$report.Add('- If the firmware update is already current and the updates are still blocked, contact HP support because the firmware issue is likely preventing the Secure Boot database update from being applied.')
$report.Add('- Keep a backup of the current firmware state and do not change PK/KEK/db/dbx unless you have a validated rollback plan.')

$report | Set-Content -Path $LogPath -Encoding UTF8
Write-Host "Remediation guidance saved to $LogPath"

if ($OpenSupportPages) {
    Start-Process 'https://support.hp.com/'
    Start-Process 'https://learn.microsoft.com/windows-hardware/manufacture/desktop/secure-boot-landing'
}
