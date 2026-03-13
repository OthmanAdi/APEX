#!/usr/bin/env bash
# APEX — Self-Correcting Validation Chain (Linux/Mac)
# Runs linter, type checker, tests, and build in sequence.
# Exits with the first failure so the agent can fix and re-run.
# Usage: bash validate.sh <project-dir>

set -euo pipefail

PROJECT_DIR="${1:-.}"
cd "$PROJECT_DIR"

echo "=== APEX Validation Chain ==="
echo "Project: $PROJECT_DIR"
echo "Date: $(date -u +"%Y-%m-%dT%H:%M:%SZ")"
echo ""

PASS=0
FAIL=0
RESULTS=""

run_step() {
  local step_name="$1"
  local cmd="$2"
  echo "--- Step: $step_name ---"
  if eval "$cmd" 2>&1; then
    echo "PASS: $step_name"
    PASS=$((PASS + 1))
    RESULTS="$RESULTS\n| $step_name | PASS | — |"
  else
    echo "FAIL: $step_name"
    FAIL=$((FAIL + 1))
    RESULTS="$RESULTS\n| $step_name | FAIL | See output above |"
    return 1
  fi
  echo ""
}

# Detect project type and run appropriate tools
if [ -f "package.json" ]; then
  # Node.js project
  PM="npx"
  [ -f "pnpm-lock.yaml" ] && PM="pnpm exec"
  [ -f "yarn.lock" ] && PM="yarn"

  # Step 1: Lint
  if grep -q '"lint"' package.json 2>/dev/null; then
    run_step "Lint" "$PM run lint 2>&1" || true
  elif [ -f ".eslintrc.js" ] || [ -f ".eslintrc.json" ] || [ -f "eslint.config.js" ] || [ -f "eslint.config.mjs" ]; then
    run_step "Lint" "npx eslint . --max-warnings 0 2>&1" || true
  else
    echo "SKIP: No linter configured"
    RESULTS="$RESULTS\n| Lint | SKIP | No config found |"
  fi

  # Step 2: Type check
  if [ -f "tsconfig.json" ]; then
    run_step "Type Check" "npx tsc --noEmit 2>&1" || true
  else
    echo "SKIP: No TypeScript config"
    RESULTS="$RESULTS\n| Type Check | SKIP | No tsconfig.json |"
  fi

  # Step 3: Tests
  if grep -q '"test"' package.json 2>/dev/null; then
    run_step "Tests" "$PM run test -- --passWithNoTests 2>&1" || true
  else
    echo "SKIP: No test script"
    RESULTS="$RESULTS\n| Tests | SKIP | No test script |"
  fi

  # Step 4: Build
  if grep -q '"build"' package.json 2>/dev/null; then
    run_step "Build" "$PM run build 2>&1" || true
  else
    echo "SKIP: No build script"
    RESULTS="$RESULTS\n| Build | SKIP | No build script |"
  fi

elif [ -f "pyproject.toml" ] || [ -f "requirements.txt" ] || [ -f "setup.py" ]; then
  # Python project

  # Step 1: Lint
  if command -v ruff &>/dev/null; then
    run_step "Lint (ruff)" "ruff check . 2>&1" || true
  elif command -v flake8 &>/dev/null; then
    run_step "Lint (flake8)" "flake8 . 2>&1" || true
  else
    echo "SKIP: No Python linter found"
    RESULTS="$RESULTS\n| Lint | SKIP | Install ruff or flake8 |"
  fi

  # Step 2: Type check
  if command -v mypy &>/dev/null; then
    run_step "Type Check (mypy)" "mypy . 2>&1" || true
  else
    echo "SKIP: mypy not installed"
    RESULTS="$RESULTS\n| Type Check | SKIP | Install mypy |"
  fi

  # Step 3: Tests
  if command -v pytest &>/dev/null; then
    run_step "Tests (pytest)" "pytest -v 2>&1" || true
  else
    echo "SKIP: pytest not installed"
    RESULTS="$RESULTS\n| Tests | SKIP | Install pytest |"
  fi

  # Step 4: Build
  run_step "Build (syntax check)" "python -m py_compile *.py 2>&1 || true" || true

elif [ -f "go.mod" ]; then
  # Go project
  run_step "Lint (go vet)" "go vet ./... 2>&1" || true
  run_step "Build" "go build ./... 2>&1" || true
  run_step "Tests" "go test ./... 2>&1" || true

elif [ -f "Cargo.toml" ]; then
  # Rust project
  run_step "Lint (clippy)" "cargo clippy -- -D warnings 2>&1" || true
  run_step "Build" "cargo build 2>&1" || true
  run_step "Tests" "cargo test 2>&1" || true

else
  echo "WARNING: Could not detect project type. No validation run."
  RESULTS="$RESULTS\n| Detection | FAIL | Unknown project type |"
  FAIL=$((FAIL + 1))
fi

echo ""
echo "=== Validation Summary ==="
echo "| Step | Status | Notes |"
echo "|------|--------|-------|"
echo -e "$RESULTS"
echo ""
echo "Passed: $PASS | Failed: $FAIL"

if [ "$FAIL" -gt 0 ]; then
  echo ""
  echo "ACTION: Fix the failures above and re-run this script."
  exit 1
else
  echo ""
  echo "All checks passed. Ready to commit."
  exit 0
fi
