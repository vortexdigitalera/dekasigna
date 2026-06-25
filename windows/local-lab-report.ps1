[CmdletBinding()]
param(
    [string]$OutputPath = "$env:USERPROFILE\Desktop\dekasigna-lab-report.txt"
)

$ErrorActionPreference = 'Stop'

Write-Host 'Collecting local system and firmware lab report...'

$report = [System.Collections.Generic.List[string]]::new()
$report.Add('dekasigna local lab report')
$report.Add("Timestamp: $(Get-Date -Format o)")
$report.Add("Computer: $($env:COMPUTERNAME)")
$report.Add("User: $($env:USERNAME)")
$report.Add('')

try {
    $os = Get-CimInstance -ClassName Win32_OperatingSystem
    $report.Add('Operating System:')
    $report.Add("- Caption: $($os.Caption)")
    $report.Add("- Version: $($os.Version)")
    $report.Add("- Build: $($os.BuildNumber)")
} catch {
    $report.Add("Operating System query failed: $($_.Exception.Message)")
}

try {
    $bios = Get-CimInstance -ClassName Win32_BIOS
    $report.Add('BIOS / Firmware:')
    $report.Add("- Manufacturer: $($bios.Manufacturer)")
    $report.Add("- Version: $($bios.SMBIOSBIOSVersion)")
    $report.Add("- Release Date: $($bios.ReleaseDate)")
} catch {
    $report.Add("BIOS query failed: $($_.Exception.Message)")
}

try {
    $cs = Get-CimInstance -ClassName Win32_ComputerSystem
    $report.Add('System:')
    $report.Add("- Model: $($cs.Model)")
    $report.Add("- Manufacturer: $($cs.Manufacturer)")
} catch {
    $report.Add("ComputerSystem query failed: $($_.Exception.Message)")
}

try {
    $cpu = Get-CimInstance -ClassName Win32_Processor | Select-Object -First 1
    $report.Add('Processor:')
    $report.Add("- Name: $($cpu.Name)")
    $report.Add("- Architecture: $($cpu.Architecture)")
} catch {
    $report.Add("Processor query failed: $($_.Exception.Message)")
}

try {
    $mem = Get-CimInstance -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum
    $report.Add('Memory:')
    $report.Add("- Total Capacity GB: $([math]::Round($mem.Sum / 1GB, 2))")
} catch {
    $report.Add("Memory query failed: $($_.Exception.Message)")
}

try {
    $secureBoot = Confirm-SecureBootUEFI
    $report.Add("Secure Boot enabled: $secureBoot")
} catch {
    $report.Add("Secure Boot query failed: $($_.Exception.Message)")
}

$report.Add('')
$report.Add('Notes:')
$report.Add('- This report is for lab observation and documentation only.')
$report.Add('- It does not modify firmware, policies, or security settings.')

$report | Set-Content -Path $OutputPath -Encoding UTF8
Write-Host "Lab report saved to $OutputPath"
