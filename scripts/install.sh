#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

if command -v npx >/dev/null 2>&1; then
  echo "Installing APEX globally with Skills CLI from local checkout..."
  (
    cd "$REPO_ROOT"
    npx -y skills add . -g -y
  )
  echo "APEX installed. Restart your agent or start a new session."
  exit 0
fi

echo "npx not found; falling back to copying APEX skills into ~/.agents/skills"
mkdir -p "$HOME/.agents/skills"
cp -a "$REPO_ROOT/.agents/skills/." "$HOME/.agents/skills/"

echo "APEX copied into ~/.agents/skills"
echo "If your agent does not show the skills, install with 'npx skills add . -g -y' when Node.js is available and restart your agent."
