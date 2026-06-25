[CmdletBinding()]
param(
    [string]$LogPath = "$env:TEMP\dekasigna-secureboot-memory-integrity-log.txt"
)

$ErrorActionPreference = 'Stop'

Write-Host 'Collecting lab-only Secure Boot and Memory Integrity observations...'

$report = [System.Collections.Generic.List[string]]::new()
$report.Add('Lab-only Secure Boot / Memory Integrity observation log')
$report.Add("Timestamp: $(Get-Date -Format o)")
$report.Add("Host: $($env:COMPUTERNAME)")
$report.Add('')

try {
    $secureBoot = Confirm-SecureBootUEFI
    $report.Add("Confirm-SecureBootUEFI: $secureBoot")
} catch {
    $report.Add("Confirm-SecureBootUEFI unavailable: $($_.Exception.Message)")
}

try {
    $deviceGuard = Get-ComputerInfo | Select-Object -ExpandProperty DeviceGuardSecurityServicesConfigured
    $report.Add("DeviceGuardSecurityServicesConfigured: $deviceGuard")
} catch {
    $report.Add("DeviceGuard info unavailable: $($_.Exception.Message)")
}

try {
    $memoryIntegrity = Get-CimInstance -ClassName Win32_DeviceGuard -ErrorAction Stop
    $report.Add("MemoryIntegrityEnabled: $($memoryIntegrity.SecurityServicesRunning)")
} catch {
    $report.Add("MemoryIntegrity status unavailable: $($_.Exception.Message)")
}

$report.Add('')
$report.Add('Simulation note: this script only logs observations and does not change real protections.')
$report.Add('Mock device tree available at: lab/mock-uefi-acpi/mock-device-tree.asl')

$report | Set-Content -Path $LogPath -Encoding UTF8
Write-Host "Log written to $LogPath"
