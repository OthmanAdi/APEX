---
name: apex-tier1
description: Execute well-defined tasks autonomously with zero human intervention. Fire-and-forget mode for straightforward work like adding tests, fixing lint errors, writing docs, or implementing simple features. Use when the task is clear, low-risk, and has objective pass/fail criteria. Triggers on keywords like fire and forget, autonomous task, simple fix, add tests, fix lint.
---

# APEX Tier 1 — Fire and Forget

Execute a well-defined task from start to finish without human intervention. Open a draft PR when done.

## When to Use

**Use Tier 1 when ALL of these are true:**
- The task has clear, unambiguous acceptance criteria
- Failure is cheap (can be reverted easily)
- No architectural decisions are required
- The scope is small (one feature, one fix, one file group)

**Do NOT use Tier 1 when:**
- The task requires design decisions → use `apex-tier2` or `apex-tier3`
- The task touches critical infrastructure → use `apex-tier3`
- The requirements are vague → clarify first, then decide tier

## Workflow

1. Parse the task into acceptance criteria
2. Create a working branch
3. Implement the change
4. Run the self-correcting loop
5. Open a draft PR

### Step 1: Parse Task into Acceptance Criteria

Convert the task description into a checklist:

```markdown
Task: "Add unit tests for the UserService class"

Acceptance Criteria:
- [ ] Tests cover all public methods of UserService
- [ ] Tests cover error/edge cases documented in the class
- [ ] All tests pass
- [ ] Coverage does not decrease
- [ ] Lint passes
```

If you cannot create at least 2 concrete acceptance criteria, the task is too vague for Tier 1. Ask the user to clarify or escalate to Tier 2.

### Step 2: Create Working Branch

```bash
git checkout -b apex/{task-slug} && git push -u origin apex/{task-slug}
```

### Step 3: Implement the Change

Write the code. Follow project conventions from AGENTS.md. Do not refactor unrelated code. Do not change formatting outside your scope.

### Step 4: Self-Correcting Loop

Run validation and iterate until clean:

**Linux/Mac:**
```bash
bash "${CLAUDE_SKILL_DIR}/scripts/validate.sh" <target-dir>
```

**Windows:**
```powershell
powershell -File "${CLAUDE_SKILL_DIR}/scripts/validate.ps1" <target-dir>
```

Maximum 5 fix cycles. If still failing after 5 attempts, commit what you have, note the failures in the PR description, and flag for human review.

### Step 5: Open Draft PR

```bash
gh pr create --draft --title "apex: {task description}" --body-file /tmp/apex-pr-body.md
```

The PR body must include:
- Task description
- Acceptance criteria checklist (checked/unchecked)
- Validation results (lint, types, tests, build)
- Any unresolved issues flagged with `[NEEDS REVIEW]`

## Output

A draft PR on a feature branch with all acceptance criteria met and validation passing.

**Example PR body:**

```markdown
## apex: Add unit tests for UserService

### Task
Add unit tests for the UserService class

### Acceptance Criteria
- [x] Tests cover all public methods of UserService
- [x] Tests cover error/edge cases documented in the class
- [x] All tests pass
- [x] Coverage does not decrease
- [x] Lint passes

### Validation Results
| Step | Status |
|------|--------|
| Lint | ✅ PASS |
| Types | ✅ PASS |
| Tests | ✅ PASS |
| Build | ✅ PASS |

### Files Changed
- `tests/services/user-service.test.ts` (new, 147 lines)
```
