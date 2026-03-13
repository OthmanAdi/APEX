#!/usr/bin/env bash
# APEX Decompose — Dependency Scanner (Linux/Mac)
# Scans a source directory and outputs a dependency report.
# Usage: bash scan-deps.sh <source-dir>

set -euo pipefail

SOURCE_DIR="${1:-.}"

if [ ! -d "$SOURCE_DIR" ]; then
  echo "ERROR: Directory '$SOURCE_DIR' does not exist."
  exit 1
fi

echo "=== APEX Dependency Scan ==="
echo "Source: $SOURCE_DIR"
echo "Date: $(date -u +"%Y-%m-%dT%H:%M:%SZ")"
echo ""

# Detect project type
echo "--- Project Detection ---"
if [ -f "$SOURCE_DIR/package.json" ]; then
  echo "Type: Node.js / JavaScript / TypeScript"
  echo "Package Manager: $([ -f "$SOURCE_DIR/pnpm-lock.yaml" ] && echo "pnpm" || ([ -f "$SOURCE_DIR/yarn.lock" ] && echo "yarn" || echo "npm"))"
  echo ""
  echo "--- Dependencies (package.json) ---"
  if command -v jq &>/dev/null; then
    jq -r '.dependencies // {} | to_entries[] | "  \(.key): \(.value)"' "$SOURCE_DIR/package.json" 2>/dev/null || echo "  (could not parse)"
    echo ""
    echo "--- Dev Dependencies ---"
    jq -r '.devDependencies // {} | to_entries[] | "  \(.key): \(.value)"' "$SOURCE_DIR/package.json" 2>/dev/null || echo "  (could not parse)"
  else
    cat "$SOURCE_DIR/package.json"
  fi
elif [ -f "$SOURCE_DIR/requirements.txt" ] || [ -f "$SOURCE_DIR/pyproject.toml" ]; then
  echo "Type: Python"
  echo ""
  echo "--- Dependencies ---"
  [ -f "$SOURCE_DIR/requirements.txt" ] && cat "$SOURCE_DIR/requirements.txt"
  [ -f "$SOURCE_DIR/pyproject.toml" ] && grep -A 50 '\[project.dependencies\]' "$SOURCE_DIR/pyproject.toml" 2>/dev/null || true
elif [ -f "$SOURCE_DIR/go.mod" ]; then
  echo "Type: Go"
  echo ""
  echo "--- Dependencies (go.mod) ---"
  cat "$SOURCE_DIR/go.mod"
elif [ -f "$SOURCE_DIR/Cargo.toml" ]; then
  echo "Type: Rust"
  echo ""
  echo "--- Dependencies (Cargo.toml) ---"
  grep -A 100 '\[dependencies\]' "$SOURCE_DIR/Cargo.toml" 2>/dev/null || cat "$SOURCE_DIR/Cargo.toml"
else
  echo "Type: Unknown (no recognized package manifest found)"
fi

echo ""
echo "--- File Structure ---"
find "$SOURCE_DIR" -type f \
  -not -path "*/node_modules/*" \
  -not -path "*/.git/*" \
  -not -path "*/dist/*" \
  -not -path "*/build/*" \
  -not -path "*/__pycache__/*" \
  -not -path "*/target/*" \
  -not -name "*.lock" \
  -not -name "package-lock.json" \
  | head -200 \
  | sort

echo ""
echo "--- Import/Require Analysis ---"
# JavaScript/TypeScript imports
JS_IMPORTS=$(grep -rn "^import\|^const.*require(" "$SOURCE_DIR" \
  --include="*.ts" --include="*.tsx" --include="*.js" --include="*.jsx" \
  2>/dev/null | grep -v node_modules | head -100)

# Python imports
PY_IMPORTS=$(grep -rn "^import\|^from.*import" "$SOURCE_DIR" \
  --include="*.py" \
  2>/dev/null | grep -v __pycache__ | head -100)

# Go imports
GO_IMPORTS=$(grep -rn "\".*\"" "$SOURCE_DIR" \
  --include="*.go" \
  2>/dev/null | grep -v vendor | head -100)

[ -n "$JS_IMPORTS" ] && echo "$JS_IMPORTS"
[ -n "$PY_IMPORTS" ] && echo "$PY_IMPORTS"
[ -n "$GO_IMPORTS" ] && echo "$GO_IMPORTS"

echo ""
echo "=== Scan Complete ==="
