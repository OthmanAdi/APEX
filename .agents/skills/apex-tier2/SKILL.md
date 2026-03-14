---
name: apex-tier2
description: Execute complex tasks with periodic human checkpoints. Background work with steering — the agent works autonomously but pauses at defined decision points for human input. Use for medium-complexity tasks like feature implementation, refactoring, or multi-file changes. Triggers on keywords like guided task, checkpoint, background with review, implement feature, refactor module.
---

# APEX Tier 2 — Guided Execution

Work autonomously on a complex task but pause at predefined checkpoints for human steering. The agent does the heavy lifting; the human makes the judgment calls.

## When to Use

**Use Tier 2 when:**
- The task involves multiple files or modules
- Some decisions require human judgment (naming, architecture choices)
- The work takes more than one focused session
- You want to review progress before the agent goes further

**Escalate to Tier 3 when:**
- Every step requires discussion
- The architecture is being designed from scratch
- The task is exploratory with no clear end state

## Workflow

1. Plan the work and define checkpoints
2. Execute until the next checkpoint
3. Present checkpoint summary for human review
4. Incorporate feedback and continue
5. Final validation and PR

### Step 1: Plan and Define Checkpoints

Break the task into phases. Each phase ends with a checkpoint:

```markdown
## Execution Plan

### Phase 1: Data layer changes
- Modify schema for new fields
- Update migrations
- **CHECKPOINT: Review schema changes before proceeding**

### Phase 2: Business logic
- Implement service methods
- Add validation rules
- **CHECKPOINT: Review logic before wiring to API**

### Phase 3: API layer
- Add/modify endpoints
- Update request/response types
- **CHECKPOINT: Review API contract before tests**

### Phase 4: Tests and cleanup
- Write unit and integration tests
- Update documentation
- Final validation
```

Present this plan to the user. Get approval before starting.

### Step 2: Execute Until Checkpoint

Work through the current phase. Follow the same implementation rules as Tier 1: one file at a time, match specs, preserve edge cases.

Run the self-correcting loop after each phase:

**Linux/Mac:**
```bash
bash "${CLAUDE_SKILL_DIR}/scripts/validate.sh" <target-dir>
```

**Windows:**
```powershell
powershell -File "${CLAUDE_SKILL_DIR}/scripts/validate.ps1" <target-dir>
```

### Step 3: Checkpoint Summary

When reaching a checkpoint, present a structured summary:

```markdown
## Checkpoint: {Phase Name}

### Completed
- [x] Item 1
- [x] Item 2

### Decisions Made
| Decision | Choice | Reasoning |
|----------|--------|-----------|
| Field naming | `created_at` | Matches existing convention |

### Questions for You
1. Should X use pattern A or pattern B?
2. Is the error message "..." appropriate for this context?

### Next Phase Preview
Phase 2 will implement [brief description]. Estimated scope: N files.
```

**Wait for human response before continuing.** Do not proceed past a checkpoint without explicit approval.

### Step 4: Incorporate Feedback

Apply the human's feedback. If feedback contradicts a previous decision, update the relevant code AND update AGENTS.md if the feedback reveals a recurring preference (two-strike rule).

### Step 5: Final Validation and PR

After all phases complete, run full validation and open a PR with the complete execution log:

```bash
gh pr create --draft --title "apex: {task description}" --body-file /tmp/apex-pr-body.md
```

## Output

A draft PR with a complete audit trail of checkpoints, decisions, and human feedback incorporated at each stage.

**Example PR body with checkpoint log:**

```markdown
## apex: Refactor payment module to Stripe v3

### Execution Log

#### Phase 1: Data Layer ✅
- Updated PaymentIntent schema
- Added new webhook event types
- **Human feedback:** "Use camelCase for new fields" → Applied

#### Phase 2: Business Logic ✅
- Migrated to PaymentIntents API
- Added idempotency keys
- **Human feedback:** "Add retry logic for network errors" → Applied

#### Phase 3: API Layer ✅
- Updated `/payments/create` endpoint
- Added `/payments/confirm` endpoint
- **Human feedback:** None needed

#### Phase 4: Tests ✅
- 23 new tests, 0 failing
- Updated 8 existing tests

### Validation: ✅ All checks pass
```
