#requires -Version 5.1
<#
.SYNOPSIS
Capture a limited Windows lab snapshot before or after a controlled restart.
.DESCRIPTION
New portfolio example reconstructed after the 2026 hands-on lab. It has not been
rerun in the historical VM in this form. It is NOT a full RAM acquisition and
never captures another user's system without authorization.
.EXAMPLE
.\collect-volatile-snapshot.ps1 -Phase Before -OutputRoot C:\PrivateEvidence
.\collect-volatile-snapshot.ps1 -Phase After -OutputRoot C:\PrivateEvidence
#>
param(
  [Parameter(Mandatory=$true)]
  [ValidateSet('Before','After')]
  [string]$Phase,
  [string]$OutputRoot = (Join-Path $env:USERPROFILE 'LabCaptures'),
  [switch]$IncludeClipboard
)
$ErrorActionPreference = 'Stop'
$folder = Join-Path $OutputRoot $Phase
New-Item -ItemType Directory -Path $folder -Force | Out-Null

@(
  "Local Time: $([DateTimeOffset]::Now.ToString('o'))"
  "UTC Time: $([DateTime]::UtcNow.ToString('o'))"
  "Last Boot: $((Get-CimInstance Win32_OperatingSystem).LastBootUpTime)"
) | Set-Content -LiteralPath (Join-Path $folder 'SystemTime.txt') -Encoding UTF8

# These outputs may contain usernames, local IP addresses, and port information.
& query.exe user 2>&1 | Out-File -LiteralPath (Join-Path $folder 'LoggedOnUsers.txt') -Encoding UTF8
& netstat.exe -ano 2>&1 | Out-File -LiteralPath (Join-Path $folder 'NetworkConnections.txt') -Encoding UTF8
& net.exe use 2>&1 | Out-File -LiteralPath (Join-Path $folder 'MappedDrives.txt') -Encoding UTF8

Get-Process | ForEach-Object {
  $p = $_
  $start = $null
  try { $start = $p.StartTime } catch { }
  [pscustomobject]@{
    ProcessName = $p.ProcessName
    Id = $p.Id
    CPU = $p.CPU
    WorkingSet64 = $p.WorkingSet64
    StartTime = $start
  }
} | Export-Csv -LiteralPath (Join-Path $folder 'RunningProcesses.csv') -NoTypeInformation -Encoding UTF8

# Get-History is specific to this PowerShell session.
Get-History | Select-Object Id, CommandLine |
  Export-Csv -LiteralPath (Join-Path $folder 'SessionHistory.csv') -NoTypeInformation -Encoding UTF8

if ($IncludeClipboard) {
  # Caution: copying acquisition commands into the VM may already have altered it.
  Get-Clipboard | Out-File -LiteralPath (Join-Path $folder 'Clipboard.txt') -Encoding UTF8
}

# Enumerate input files BEFORE generating SHA256_Manifest.csv to avoid self-hashing.
$files = @(Get-ChildItem -LiteralPath $folder -File)
$files | ForEach-Object {
  $sha = Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256
  [pscustomobject]@{ FileName = $_.Name; SHA256 = $sha.Hash }
} | Export-Csv -LiteralPath (Join-Path $folder 'SHA256_Manifest.csv') -NoTypeInformation -Encoding UTF8

Write-Host "Saved limited snapshot in $folder"
Write-Warning 'This changes live state and is not a complete forensic memory capture.'
