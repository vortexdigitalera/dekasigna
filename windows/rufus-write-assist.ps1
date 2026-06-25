[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$ImagePath,
    [string]$TargetDrive = $null,
    [switch]$OpenRufus
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path $ImagePath)) {
    throw "Image not found: $ImagePath"
}

Write-Host "Rufus-style USB image preparation helper"
Write-Host "Image: $ImagePath"

if ($OpenRufus) {
    Start-Process 'https://rufus.ie/'
}

$drives = Get-CimInstance -ClassName Win32_DiskDrive | Where-Object { $_.Size -gt 0 }
$report = [System.Collections.Generic.List[string]]::new()
$report.Add('USB image write assistance')
$report.Add("Image: $ImagePath")
$report.Add("Detected disks:")
foreach ($drive in $drives) {
    $report.Add("- $($drive.Index): $($drive.Model) [$($drive.Size / 1GB) GB]")
}
$report.Add('')
$report.Add('Recommended procedure:')
$report.Add('- Use Rufus to write the image to a USB drive in ISO mode.')
$report.Add('- Select the generated .iso file and a target USB device.')
$report.Add('- Boot the target device in UEFI mode and launch the DEKASIGNA firmware helper.')
$report.Add('- Preserve the firmware variable backups before any firmware-state change.')

$reportPath = Join-Path $env:TEMP 'dekasigna-rufus-write-assist.txt'
$report | Set-Content -Path $reportPath -Encoding UTF8
Write-Host "Write assistance report saved to $reportPath"

if ($TargetDrive) {
    Write-Host "Target drive provided: $TargetDrive"
}
