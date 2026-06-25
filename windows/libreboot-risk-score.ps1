[CmdletBinding()]
param(
    [ValidateSet('1','2','3','4','5')]
    [string]$RiskScore = '2',
    [string]$Description = 'Lab documentation only',
    [string]$LogPath = "$env:TEMP\dekasigna-libreboot-risk-score.txt"
)

$ErrorActionPreference = 'Stop'

$labels = @{
    '1' = 'Low risk';
    '2' = 'Moderate risk';
    '3' = 'Elevated risk';
    '4' = 'High risk';
    '5' = 'Critical risk'
}

$report = [System.Collections.Generic.List[string]]::new()
$report.Add('Libreboot lab risk score')
$report.Add("Timestamp: $(Get-Date -Format o)")
$report.Add("Risk Score: $RiskScore")
$report.Add("Risk Level: $($labels[$RiskScore])")
$report.Add("Description: $Description")
$report.Add('')
$report.Add('Safeguards:')
$report.Add('- Preserve firmware backup')
$report.Add('- Prepare rollback and recovery plan')
$report.Add('- Use lab-only hardware when possible')
$report.Add('- Confirm vendor support before flashing')

$report | Set-Content -Path $LogPath -Encoding UTF8
Write-Host "Risk score report written to $LogPath"
