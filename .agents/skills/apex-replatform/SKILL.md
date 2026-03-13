---
name: apex-replatform
description: Implement features in a new architecture using specifications from apex-decompose. Use when replatforming, migrating codebases, rebuilding features in a new framework, or translating specs into working code. Triggers on keywords like replatform, migrate, rebuild, implement spec, new architecture.
---

# APEX Replatform

Take a feature specification (from `apex-decompose` or manually written) and implement it in a target architecture. This is the "mapping problem" — translating what exists into what should exist.

## When to Use

Use this skill after you have a specification document describing the feature's behavior. You should NOT need access to the original source code. The spec is your single source of truth.

## Workflow

Replatforming a feature involves these steps:

1. Load and understand the specification
2. Map the spec to the target architecture
3. Implement the feature
4. Wire up self-correcting feedback loops
5. Validate against the spec's acceptance criteria

### Step 1: Load the Specification

Read the spec file:

```
Read specs/{feature-name}.md
```

Identify all `[VERIFY]` tags. Ask the user to resolve any ambiguities before proceeding. Do not guess on verified items.

### Step 2: Map to Target Architecture

Create a mapping document that translates spec concepts to target patterns:

| Spec Concept | Target Implementation |
|-------------|----------------------|
| Database write to `users` table | Prisma `user.create()` call |
| REST endpoint `/api/v1/items` | Next.js API route `app/api/items/route.ts` |
| Event emission `item.created` | EventEmitter / message queue publish |

Ask the user to confirm the mapping before writing code. This is the architectural decision point.

### Step 3: Implement the Feature

Write code following these rules:

1. **One file at a time.** Complete each file before moving to the next.
2. **Match the spec exactly.** Every input, output, and side effect in the spec must be implemented.
3. **Preserve edge cases.** If the spec says "returns 400 when empty," implement that exact behavior.
4. **Add inline comments** referencing the spec: `// Spec: Edge Case #3 — concurrent request handling`

### Step 4: Self-Correcting Feedback Loop

After writing code, run the validation chain. Detect OS and use the appropriate script:

**Linux/Mac:**
```bash
bash "${CLAUDE_SKILL_DIR}/scripts/validate.sh" <target-dir>
```

**Windows:**
```powershell
powershell -File "${CLAUDE_SKILL_DIR}/scripts/validate.ps1" <target-dir>
```

The validation script runs in order: linter, type checker, tests, build. If any step fails, read the error output, fix the issue, and re-run. Repeat until all four pass. Do NOT ask the user for help until you have attempted at least 3 fix cycles.

### Step 5: Validate Against Spec

Walk through every section of the spec and confirm implementation coverage:

| Spec Section | Status | Notes |
|-------------|--------|-------|
| Inputs | PASS/FAIL | All parameters handled |
| Outputs | PASS/FAIL | Response shape matches |
| Side Effects | PASS/FAIL | All mutations implemented |
| Edge Cases | PASS/FAIL | Each case has a code path |
| Dependencies | PASS/FAIL | All packages installed |

Create a draft PR with this checklist in the description.

## Output

A working implementation in the target architecture that matches the specification, with a passing validation chain and a draft PR ready for human review.
