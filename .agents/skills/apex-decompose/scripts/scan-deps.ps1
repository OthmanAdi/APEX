# APEX Decompose — Dependency Scanner (Windows)
# Scans a source directory and outputs a dependency report.
# Usage: powershell -File scan-deps.ps1 <source-dir>

param(
    [Parameter(Position=0)]
    [string]$SourceDir = "."
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $SourceDir -PathType Container)) {
    Write-Error "ERROR: Directory '$SourceDir' does not exist."
    exit 1
}

Write-Host "=== APEX Dependency Scan ==="
Write-Host "Source: $SourceDir"
Write-Host "Date: $((Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ'))"
Write-Host ""

# Detect project type
Write-Host "--- Project Detection ---"
$packageJson = Join-Path $SourceDir "package.json"
$requirementsTxt = Join-Path $SourceDir "requirements.txt"
$pyprojectToml = Join-Path $SourceDir "pyproject.toml"
$goMod = Join-Path $SourceDir "go.mod"
$cargoToml = Join-Path $SourceDir "Cargo.toml"

if (Test-Path $packageJson) {
    Write-Host "Type: Node.js / JavaScript / TypeScript"
    $pm = if (Test-Path (Join-Path $SourceDir "pnpm-lock.yaml")) { "pnpm" }
          elseif (Test-Path (Join-Path $SourceDir "yarn.lock")) { "yarn" }
          else { "npm" }
    Write-Host "Package Manager: $pm"
    Write-Host ""
    Write-Host "--- Dependencies (package.json) ---"
    try {
        $pkg = Get-Content $packageJson -Raw | ConvertFrom-Json
        if ($pkg.dependencies) {
            $pkg.dependencies.PSObject.Properties | ForEach-Object {
                Write-Host "  $($_.Name): $($_.Value)"
            }
        }
        Write-Host ""
        Write-Host "--- Dev Dependencies ---"
        if ($pkg.devDependencies) {
            $pkg.devDependencies.PSObject.Properties | ForEach-Object {
                Write-Host "  $($_.Name): $($_.Value)"
            }
        }
    } catch {
        Write-Host "  (could not parse)"
    }
} elseif ((Test-Path $requirementsTxt) -or (Test-Path $pyprojectToml)) {
    Write-Host "Type: Python"
    Write-Host ""
    Write-Host "--- Dependencies ---"
    if (Test-Path $requirementsTxt) { Get-Content $requirementsTxt }
    if (Test-Path $pyprojectToml) { Get-Content $pyprojectToml }
} elseif (Test-Path $goMod) {
    Write-Host "Type: Go"
    Write-Host ""
    Write-Host "--- Dependencies (go.mod) ---"
    Get-Content $goMod
} elseif (Test-Path $cargoToml) {
    Write-Host "Type: Rust"
    Write-Host ""
    Write-Host "--- Dependencies (Cargo.toml) ---"
    Get-Content $cargoToml
} else {
    Write-Host "Type: Unknown (no recognized package manifest found)"
}

Write-Host ""
Write-Host "--- File Structure ---"
Get-ChildItem -Path $SourceDir -Recurse -File |
    Where-Object {
        $_.FullName -notmatch "node_modules|\.git|dist|build|__pycache__|target" -and
        $_.Name -notmatch "\.lock$|package-lock\.json$"
    } |
    Select-Object -First 200 |
    Sort-Object FullName |
    ForEach-Object { $_.FullName.Replace($SourceDir, ".") }

Write-Host ""
Write-Host "--- Import/Require Analysis ---"

# JavaScript/TypeScript imports
$jsFiles = Get-ChildItem -Path $SourceDir -Recurse -Include "*.ts","*.tsx","*.js","*.jsx" -File |
    Where-Object { $_.FullName -notmatch "node_modules" }
foreach ($file in ($jsFiles | Select-Object -First 50)) {
    $imports = Select-String -Path $file.FullName -Pattern "^import|^const.*require\(" -ErrorAction SilentlyContinue
    if ($imports) { $imports | Select-Object -First 5 | ForEach-Object { Write-Host $_.ToString() } }
}

# Python imports
$pyFiles = Get-ChildItem -Path $SourceDir -Recurse -Include "*.py" -File |
    Where-Object { $_.FullName -notmatch "__pycache__" }
foreach ($file in ($pyFiles | Select-Object -First 50)) {
    $imports = Select-String -Path $file.FullName -Pattern "^import|^from.*import" -ErrorAction SilentlyContinue
    if ($imports) { $imports | Select-Object -First 5 | ForEach-Object { Write-Host $_.ToString() } }
}

Write-Host ""
Write-Host "=== Scan Complete ==="
