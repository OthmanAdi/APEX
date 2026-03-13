# APEX — Self-Correcting Validation Chain (Windows)
# Runs linter, type checker, tests, and build in sequence.
# Usage: powershell -File validate.ps1 <project-dir>

param(
    [Parameter(Position=0)]
    [string]$ProjectDir = "."
)

$ErrorActionPreference = "Continue"
Set-Location $ProjectDir

Write-Host "=== APEX Validation Chain ==="
Write-Host "Project: $ProjectDir"
Write-Host "Date: $((Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ'))"
Write-Host ""

$Pass = 0
$Fail = 0
$Results = @()

function Run-Step {
    param([string]$StepName, [string]$Command)
    Write-Host "--- Step: $StepName ---"
    try {
        $output = Invoke-Expression $Command 2>&1
        $output | ForEach-Object { Write-Host $_ }
        if ($LASTEXITCODE -eq 0 -or $null -eq $LASTEXITCODE) {
            Write-Host "PASS: $StepName"
            $script:Pass++
            $script:Results += [PSCustomObject]@{Step=$StepName; Status="PASS"; Notes="—"}
        } else {
            Write-Host "FAIL: $StepName"
            $script:Fail++
            $script:Results += [PSCustomObject]@{Step=$StepName; Status="FAIL"; Notes="See output above"}
        }
    } catch {
        Write-Host "FAIL: $StepName — $($_.Exception.Message)"
        $script:Fail++
        $script:Results += [PSCustomObject]@{Step=$StepName; Status="FAIL"; Notes=$_.Exception.Message}
    }
    Write-Host ""
}

# Detect project type
$packageJson = Join-Path $ProjectDir "package.json"
$pyproject = Join-Path $ProjectDir "pyproject.toml"
$requirements = Join-Path $ProjectDir "requirements.txt"
$goMod = Join-Path $ProjectDir "go.mod"
$cargoToml = Join-Path $ProjectDir "Cargo.toml"

if (Test-Path $packageJson) {
    # Node.js project
    $pkg = Get-Content $packageJson -Raw | ConvertFrom-Json

    # Lint
    if ($pkg.scripts.PSObject.Properties.Name -contains "lint") {
        Run-Step "Lint" "npm run lint"
    } elseif (Test-Path "eslint.config.*" -ErrorAction SilentlyContinue) {
        Run-Step "Lint" "npx eslint . --max-warnings 0"
    } else {
        Write-Host "SKIP: No linter configured"
        $Results += [PSCustomObject]@{Step="Lint"; Status="SKIP"; Notes="No config found"}
    }

    # Type check
    if (Test-Path (Join-Path $ProjectDir "tsconfig.json")) {
        Run-Step "Type Check" "npx tsc --noEmit"
    } else {
        Write-Host "SKIP: No TypeScript config"
        $Results += [PSCustomObject]@{Step="Type Check"; Status="SKIP"; Notes="No tsconfig.json"}
    }

    # Tests
    if ($pkg.scripts.PSObject.Properties.Name -contains "test") {
        Run-Step "Tests" "npm run test -- --passWithNoTests"
    } else {
        Write-Host "SKIP: No test script"
        $Results += [PSCustomObject]@{Step="Tests"; Status="SKIP"; Notes="No test script"}
    }

    # Build
    if ($pkg.scripts.PSObject.Properties.Name -contains "build") {
        Run-Step "Build" "npm run build"
    } else {
        Write-Host "SKIP: No build script"
        $Results += [PSCustomObject]@{Step="Build"; Status="SKIP"; Notes="No build script"}
    }

} elseif ((Test-Path $pyproject) -or (Test-Path $requirements)) {
    # Python project
    if (Get-Command ruff -ErrorAction SilentlyContinue) {
        Run-Step "Lint (ruff)" "ruff check ."
    } elseif (Get-Command flake8 -ErrorAction SilentlyContinue) {
        Run-Step "Lint (flake8)" "flake8 ."
    } else {
        Write-Host "SKIP: No Python linter found"
        $Results += [PSCustomObject]@{Step="Lint"; Status="SKIP"; Notes="Install ruff or flake8"}
    }

    if (Get-Command mypy -ErrorAction SilentlyContinue) {
        Run-Step "Type Check (mypy)" "mypy ."
    }

    if (Get-Command pytest -ErrorAction SilentlyContinue) {
        Run-Step "Tests (pytest)" "pytest -v"
    }

} elseif (Test-Path $goMod) {
    Run-Step "Lint (go vet)" "go vet ./..."
    Run-Step "Build" "go build ./..."
    Run-Step "Tests" "go test ./..."

} elseif (Test-Path $cargoToml) {
    Run-Step "Lint (clippy)" "cargo clippy -- -D warnings"
    Run-Step "Build" "cargo build"
    Run-Step "Tests" "cargo test"

} else {
    Write-Host "WARNING: Could not detect project type."
    $Fail++
    $Results += [PSCustomObject]@{Step="Detection"; Status="FAIL"; Notes="Unknown project type"}
}

Write-Host ""
Write-Host "=== Validation Summary ==="
$Results | Format-Table -AutoSize
Write-Host "Passed: $Pass | Failed: $Fail"

if ($Fail -gt 0) {
    Write-Host ""
    Write-Host "ACTION: Fix the failures above and re-run this script."
    exit 1
} else {
    Write-Host ""
    Write-Host "All checks passed. Ready to commit."
    exit 0
}
