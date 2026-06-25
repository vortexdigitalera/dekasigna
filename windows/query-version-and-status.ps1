[CmdletBinding()]
param(
    [string]$LogPath = "$env:TEMP\dekasigna-query-version-and-status.txt"
)

$ErrorActionPreference = 'Stop'

$report = [System.Collections.Generic.List[string]]::new()
$report.Add('Secure Boot query report')
$report.Add("Timestamp: $(Get-Date -Format o)")

try {
    $secureBoot = Confirm-SecureBootUEFI
    $report.Add("Confirm-SecureBootUEFI: $secureBoot")
} catch {
    $report.Add("Confirm-SecureBootUEFI unavailable: $($_.Exception.Message)")
}

try {
    $bios = Get-CimInstance -ClassName Win32_BIOS
    $report.Add("BIOS Manufacturer: $($bios.Manufacturer)")
    $report.Add("BIOS Version: $($bios.SMBIOSBIOSVersion)")
} catch {
    $report.Add("BIOS query failed: $($_.Exception.Message)")
}

$report | Set-Content -Path $LogPath -Encoding UTF8
Write-Host "Query report saved to $LogPath"
