#requires -Version 5.1
<#
.SYNOPSIS
Export an installed-software inventory for comparison using uninstall Registry keys.
.DESCRIPTION
Reconstructed post-lab portfolio example. Not the exact code used in 2026.
Exports may contain sensitive workstation software details. Use only on owned or
explicitly authorized Windows systems; keep raw output private.
.EXAMPLE
.\export-installed-software.ps1 -OutputPath C:\PrivateEvidence\Before_InstalledSoftware.csv
#>
param([Parameter(Mandatory=$true)][string]$OutputPath)
$ErrorActionPreference = 'Stop'
$paths = @(
  'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*',
  'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*',
  'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*'
)
$rows = foreach ($path in $paths) {
  Get-ItemProperty -Path $path -ErrorAction SilentlyContinue |
    Where-Object { -not [string]::IsNullOrWhiteSpace($_.DisplayName) } |
    ForEach-Object {
      [pscustomobject]@{
        DisplayName = [string]$_.DisplayName
        DisplayVersion = [string]$_.DisplayVersion
        Publisher = [string]$_.Publisher
        InstallDate = [string]$_.InstallDate
        PSPath = [string]$_.PSPath
      }
    }
}
$parent = Split-Path -Parent $OutputPath
if ($parent) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
$rows | Sort-Object PSPath, DisplayName -Unique |
    Export-Csv -LiteralPath $OutputPath -NoTypeInformation -Encoding UTF8
Write-Host "Created inventory at $OutputPath"
