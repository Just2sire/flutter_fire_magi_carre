# Build MagiCarré for a given environment.
#
# Usage:
#   .\scripts\build.ps1 dev                 # debug APK, config/dev.json, no obfuscation
#   .\scripts\build.ps1 prod                # release APK, config/prod.json, obfuscated, split per ABI
#   .\scripts\build.ps1 prod -Bundle        # release AAB (Play Store) instead of split APKs
#
# Obfuscation maps symbols to build/app/outputs/symbols/ — keep that folder
# for every release you ship, it's required to de-obfuscate crash reports
# (flutter symbolize).

param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("dev", "prod")]
    [string]$Environment,

    [switch]$Bundle
)

$ErrorActionPreference = "Stop"

$configFile = "config/$Environment.json"
if (-not (Test-Path $configFile)) {
    Write-Error "Missing $configFile. Copy config/$Environment.json.example and fill in your values."
    exit 1
}

if ($Environment -eq "dev") {
    Write-Host "Building debug APK (config/dev.json)..." -ForegroundColor Cyan
    flutter build apk --debug --dart-define-from-file=$configFile
    exit $LASTEXITCODE
}

$symbolsDir = "build/app/outputs/symbols"
New-Item -ItemType Directory -Force -Path $symbolsDir | Out-Null

if ($Bundle) {
    Write-Host "Building release App Bundle (obfuscated, config/prod.json)..." -ForegroundColor Cyan
    flutter build appbundle `
        --release `
        --obfuscate `
        --split-debug-info=$symbolsDir `
        --dart-define-from-file=$configFile
} else {
    Write-Host "Building release APKs, split per ABI (obfuscated, config/prod.json)..." -ForegroundColor Cyan
    flutter build apk `
        --release `
        --obfuscate `
        --split-debug-info=$symbolsDir `
        --split-per-abi `
        --dart-define-from-file=$configFile
}
exit $LASTEXITCODE
