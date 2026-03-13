#!/usr/bin/env bash
# APEX Learn — Append Learning to AGENTS.md (Linux/Mac)
# Safely appends a new rule to the correct section of AGENTS.md.
# Usage: bash append-learning.sh "<category>" "<rule-text>" [agents-file]

set -euo pipefail

CATEGORY="${1:-}"
RULE="${2:-}"
AGENTS_FILE="${3:-AGENTS.md}"

if [ -z "$CATEGORY" ] || [ -z "$RULE" ]; then
  echo "Usage: bash append-learning.sh \"<category>\" \"<rule-text>\" [agents-file]"
  echo ""
  echo "Categories: code-style, architecture, workflow, boundaries, preferences, tools"
  exit 1
fi

# Map category to section header
declare -A SECTIONS=(
  ["code-style"]="## Code Style"
  ["architecture"]="## Architecture Rules"
  ["workflow"]="## Workflow"
  ["boundaries"]="## Boundaries"
  ["preferences"]="## Preferences"
  ["tools"]="## Tools"
)

SECTION="${SECTIONS[$CATEGORY]:-}"
if [ -z "$SECTION" ]; then
  echo "ERROR: Unknown category '$CATEGORY'."
  echo "Valid categories: code-style, architecture, workflow, boundaries, preferences, tools"
  exit 1
fi

# Create AGENTS.md from template if it doesn't exist
if [ ! -f "$AGENTS_FILE" ]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  TEMPLATE="$SCRIPT_DIR/../references/agents-template.md"
  if [ -f "$TEMPLATE" ]; then
    cp "$TEMPLATE" "$AGENTS_FILE"
    echo "Created $AGENTS_FILE from template."
  else
    echo "ERROR: $AGENTS_FILE does not exist and template not found."
    exit 1
  fi
fi

# Check for duplicate
if grep -qF "$RULE" "$AGENTS_FILE" 2>/dev/null; then
  echo "SKIP: This rule already exists in $AGENTS_FILE."
  exit 0
fi

# Find the section and append the rule after it
if grep -q "^$SECTION" "$AGENTS_FILE"; then
  # Find line number of the section, then find the next blank line or section to insert before
  SECTION_LINE=$(grep -n "^$SECTION" "$AGENTS_FILE" | head -1 | cut -d: -f1)
  
  # Insert the rule after the section header
  sed -i "${SECTION_LINE}a\\- ${RULE}" "$AGENTS_FILE"
  echo "ADDED: Rule appended to '$SECTION' in $AGENTS_FILE"
else
  # Section doesn't exist, append it at the end
  echo "" >> "$AGENTS_FILE"
  echo "$SECTION" >> "$AGENTS_FILE"
  echo "- $RULE" >> "$AGENTS_FILE"
  echo "ADDED: Created '$SECTION' section with rule in $AGENTS_FILE"
fi

echo ""
echo "Rule: $RULE"
echo "Category: $CATEGORY"
echo "File: $AGENTS_FILE"
