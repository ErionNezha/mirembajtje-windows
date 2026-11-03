# Krijuar nga MR ERIONXX
# (c) 2026 MR ERIONXX - Te gjitha te drejtat e rezervuara
# Perdorim i lire vetem me ruajtjen e ketij krediti.
# Shih LICENSE.md ne projekt per kushtet e plota.
# ÇmimRadar — ben ZIP vetem me kod (pa data, pa node_modules, pa video)
# Vendose kete file ne dosjen rrënje te projektit dhe nise me file-in .bat
$ErrorActionPreference = "Stop"
$root = $PSScriptRoot
if (-not $root) { $root = (Get-Location).Path }
$desktop = [Environment]::GetFolderPath("Desktop")
$out = Join-Path $desktop "cmimradar-ndryshimet-kod.zip"
$staging = Join-Path $env:TEMP "cmimradar-kod-staging"

Write-Host "Dosja e projektit: $root"
if (Test-Path $staging) { Remove-Item $staging -Recurse -Force }
New-Item -ItemType Directory -Path $staging | Out-Null

$excludeDirs = @("node_modules","__pycache__","dist","test-shots","work","data",".git")
$excludeFiles = @("*.mp4","*.pyc","*.zip")

$count = 0
Get-ChildItem -Path $root -Recurse -File | ForEach-Object {
    $rel = $_.FullName.Substring($root.Length).TrimStart("\")
    $parts = $rel -split "\\"
    $skip = $false
    foreach ($p in $parts) { if ($excludeDirs -contains $p) { $skip = $true } }
    foreach ($pat in $excludeFiles) { if ($_.Name -like $pat) { $skip = $true } }
    if ($_.Name -eq "bej-zip-kod.ps1" -or $_.Name -eq "BEJ-ZIP-KOD.bat") { $skip = $true }
    if (-not $skip) {
        $dest = Join-Path $staging $rel
        New-Item -ItemType Directory -Path (Split-Path $dest) -Force | Out-Null
        Copy-Item $_.FullName $dest -Force
        $count++
    }
}
if (Test-Path $out) { Remove-Item $out -Force }
Compress-Archive -Path (Join-Path $staging "*") -DestinationPath $out -CompressionLevel Optimal
Remove-Item $staging -Recurse -Force
$mb = [math]::Round((Get-Item $out).Length / 1MB, 2)
Write-Host ""
Write-Host "GATI: $out"
Write-Host "File te perfshire: $count"
Write-Host "Madhesia: $mb MB"
if ($mb -gt 24) { Write-Host "KUJDES: ende mbi 24 MB - dergo kete numer si mesazh, mos e ngarko." -ForegroundColor Yellow }
else { Write-Host "Ngarkoje kete ZIP ne chat." -ForegroundColor Green }
