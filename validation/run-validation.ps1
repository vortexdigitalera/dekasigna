[CmdletBinding()]
param(
    [string]$LogPath = "$env:TEMP\dekasigna-secureboot-validation.log"
)

$ErrorActionPreference = 'Stop'

Write-Host "Microsoft UEFI validation wrapper"
Write-Host "This script is intended to support Microsoft-style validation workflows only on test systems."

$tools = @(
    @{ Name = 'EnableUefiSBTest.exe'; Path = $null },
    @{ Name = 'Confirm-SecureBootUEFI'; Path = 'Confirm-SecureBootUEFI' }
)

$log = [System.Collections.Generic.List[string]]::new()
$log.Add("Timestamp: $(Get-Date -Format o)")
$log.Add("Host: $($env:COMPUTERNAME)")
$log.Add("Secure Boot cmdlet available: $((Get-Command Confirm-SecureBootUEFI -ErrorAction SilentlyContinue) -ne $null)")

$enableTool = Get-Command 'EnableUefiSBTest.exe' -ErrorAction SilentlyContinue
if ($enableTool) {
    $log.Add("Found validation tool: $($enableTool.Source)")
    Write-Host "Found validation tool: $($enableTool.Source)"
} else {
    $log.Add('EnableUefiSBTest.exe not found. Place it on PATH or supply it manually.')
    Write-Warning 'EnableUefiSBTest.exe not found. Place it on PATH or supply it manually.'
}

try {
    $secureBootEnabled = Confirm-SecureBootUEFI
    $log.Add("Confirm-SecureBootUEFI returned: $secureBootEnabled")
    Write-Host "Secure Boot enabled: $secureBootEnabled"
} catch {
    $log.Add("Confirm-SecureBootUEFI failed: $($_.Exception.Message)")
    Write-Warning "Confirm-SecureBootUEFI failed: $($_.Exception.Message)"
}

$log | Set-Content -Path $LogPath -Encoding UTF8
Write-Host "Validation log written to $LogPath"
