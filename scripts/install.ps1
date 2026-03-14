$ErrorActionPreference = 'Stop'

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = (Resolve-Path (Join-Path $ScriptDir '..')).Path

if (Get-Command npx -ErrorAction SilentlyContinue) {
    Write-Host 'Installing APEX globally with Skills CLI from local checkout...'
    Push-Location $RepoRoot
    try {
        npx -y skills add . -g -y
    }
    finally {
        Pop-Location
    }

    Write-Host 'APEX installed. Restart your agent or start a new session.'
    exit 0
}

$Target = Join-Path $HOME '.agents/skills'
Write-Host "npx not found; falling back to copying APEX skills into $Target"
New-Item -ItemType Directory -Force -Path $Target | Out-Null
Copy-Item -Recurse -Force (Join-Path $RepoRoot '.agents/skills/*') $Target

Write-Host "APEX copied into $Target"
Write-Host "If your agent does not show the skills, install with 'npx skills add . -g -y' when Node.js is available and restart your agent."
