[CmdletBinding()]
param(
    [string]$LogPath = "$env:TEMP\dekasigna-secureboot-report.txt"
)

$ErrorActionPreference = 'Stop'

Write-Host "Gathering Secure Boot state and firmware details..."

$report = [System.Collections.Generic.List[string]]::new()
$report.Add("Secure Boot report")
$report.Add("Timestamp: $(Get-Date -Format o)")

try {
    $secureBootEnabled = Confirm-SecureBootUEFI
    $report.Add("Secure Boot enabled: $secureBootEnabled")
    Write-Host "Secure Boot enabled: $secureBootEnabled"
} catch {
    $report.Add("Confirm-SecureBootUEFI unavailable: $($_.Exception.Message)")
    Write-Warning "Confirm-SecureBootUEFI unavailable: $($_.Exception.Message)"
}

try {
    $bios = Get-CimInstance -ClassName Win32_BIOS
    $report.Add("BIOS Vendor: $($bios.Manufacturer)")
    $report.Add("BIOS Version: $($bios.SMBIOSBIOSVersion)")
} catch {
    $report.Add("BIOS information unavailable: $($_.Exception.Message)")
}

try {
    $cs = Get-CimInstance -ClassName Win32_ComputerSystem
    $report.Add("Computer Model: $($cs.Model)")
} catch {
    $report.Add("Computer model unavailable: $($_.Exception.Message)")
}

$report.Add("Microsoft guidance reminder: preserve the Microsoft Secure Boot key hierarchy and validate any db/dbx change with supported tools.")
$report | Set-Content -Path $LogPath -Encoding UTF8
Write-Host "Secure Boot report saved to $LogPath"
