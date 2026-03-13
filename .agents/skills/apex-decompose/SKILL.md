---
name: apex-decompose
description: Decompose features from an existing codebase into detailed, agent-ready specifications for replatforming or migration. Use when analyzing legacy code, extracting feature behavior, mapping old architecture to new, or preparing migration specs. Triggers on keywords like decompose, analyze features, extract behavior, migration spec, map codebase.
---

# APEX Decompose

Break down features from a source codebase into detailed, implementation-ready specifications that an agent can use to rebuild them in a new architecture.

## When to Use

Use this skill when you need to understand what existing code does before rewriting it. This is the first step in any replatforming or migration workflow. The output is a specification document, not code.

## Workflow

Decomposing a feature involves these steps:

1. Identify the feature scope (files, modules, entry points)
2. Analyze behavior and contracts (inputs, outputs, side effects)
3. Extract implicit knowledge (edge cases, error handling, config dependencies)
4. Generate the specification document
5. Validate the spec against the source

### Step 1: Identify Feature Scope

Collect all relevant source files. Ask the user or scan the directory:

```
What feature or module do you want to decompose?
Provide the path(s) to the relevant source files or directories.
```

Read every file in the scope. Build a dependency graph: which files import which, what external services are called, what state is mutated.

Run the dependency scanner to accelerate this step:

**Linux/Mac:**
```bash
bash "${CLAUDE_SKILL_DIR}/scripts/scan-deps.sh" <source-dir>
```

**Windows:**
```powershell
powershell -File "${CLAUDE_SKILL_DIR}/scripts/scan-deps.ps1" <source-dir>
```

### Step 2: Analyze Behavior and Contracts

For each function, class, or module in scope, document:

| Aspect | What to Capture |
|--------|----------------|
| **Inputs** | Parameters, environment variables, config values, request shapes |
| **Outputs** | Return values, response shapes, files written, events emitted |
| **Side effects** | Database writes, API calls, cache mutations, logging |
| **Error handling** | Try/catch patterns, error codes, fallback behavior |
| **Dependencies** | Internal imports, external packages, services called |

### Step 3: Extract Implicit Knowledge

This is the critical step most migrations miss. Look for:

- **Magic values** — hardcoded strings, numbers, or thresholds with no documentation
- **Ordering dependencies** — operations that must happen in a specific sequence
- **Race conditions** — concurrent access patterns or timing-sensitive logic
- **Feature flags** — conditional behavior based on config or environment
- **Undocumented APIs** — internal endpoints or contracts between services

### Step 4: Generate the Specification

Write the spec to `specs/{feature-name}.md` using the template in [references/spec-template.md](references/spec-template.md).

### Step 5: Validate the Spec

Cross-reference the spec against the source code. For each behavior documented, confirm it matches the actual implementation. Flag any ambiguities with `[VERIFY]` tags for human review.

## Output

The final deliverable is a Markdown specification file in `specs/` that another agent (or `apex-replatform`) can consume to implement the feature in a new architecture without needing access to the original source code.
