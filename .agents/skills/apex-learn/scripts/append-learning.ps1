# APEX Learn — Append Learning to AGENTS.md (Windows)
# Safely appends a new rule to the correct section of AGENTS.md.
# Usage: powershell -File append-learning.ps1 "<category>" "<rule-text>" [agents-file]

param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$Category,

    [Parameter(Mandatory=$true, Position=1)]
    [string]$Rule,

    [Parameter(Position=2)]
    [string]$AgentsFile = "AGENTS.md"
)

$ErrorActionPreference = "Stop"

# Map category to section header
$Sections = @{
    "code-style"    = "## Code Style"
    "architecture"  = "## Architecture Rules"
    "workflow"      = "## Workflow"
    "boundaries"    = "## Boundaries"
    "preferences"   = "## Preferences"
    "tools"         = "## Tools"
}

$Section = $Sections[$Category]
if (-not $Section) {
    Write-Error "Unknown category '$Category'. Valid: code-style, architecture, workflow, boundaries, preferences, tools"
    exit 1
}

# Create AGENTS.md from template if it doesn't exist
if (-not (Test-Path $AgentsFile)) {
    $ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
    $Template = Join-Path (Split-Path -Parent $ScriptDir) "references" "agents-template.md"
    if (Test-Path $Template) {
        Copy-Item $Template $AgentsFile
        Write-Host "Created $AgentsFile from template."
    } else {
        Write-Error "$AgentsFile does not exist and template not found."
        exit 1
    }
}

# Check for duplicate
$content = Get-Content $AgentsFile -Raw
if ($content -match [regex]::Escape($Rule)) {
    Write-Host "SKIP: This rule already exists in $AgentsFile."
    exit 0
}

# Find the section and append the rule
$lines = Get-Content $AgentsFile
$sectionIndex = -1
for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -eq $Section) {
        $sectionIndex = $i
        break
    }
}

if ($sectionIndex -ge 0) {
    # Insert after the section header
    $newLines = @()
    $newLines += $lines[0..$sectionIndex]
    $newLines += "- $Rule"
    if ($sectionIndex -lt ($lines.Count - 1)) {
        $newLines += $lines[($sectionIndex + 1)..($lines.Count - 1)]
    }
    $newLines | Set-Content $AgentsFile -Encoding UTF8
    Write-Host "ADDED: Rule appended to '$Section' in $AgentsFile"
} else {
    # Section doesn't exist, append at end
    Add-Content $AgentsFile "`n$Section`n- $Rule" -Encoding UTF8
    Write-Host "ADDED: Created '$Section' section with rule in $AgentsFile"
}

Write-Host ""
Write-Host "Rule: $Rule"
Write-Host "Category: $Category"
Write-Host "File: $AgentsFile"
