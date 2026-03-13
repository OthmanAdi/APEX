---
name: apex-learn
description: Trigger the self-improvement loop after completing a task. Analyzes friction, extracts learnings, and updates AGENTS.md with new rules and preferences. Use after any task that involved struggle, correction, or discovery of a new pattern. Triggers on keywords like learn, self-improve, update rules, what did I learn, retrospective, post-mortem.
---

# APEX Learn

Analyze what happened during a task, extract reusable knowledge, and persist it to AGENTS.md so the entire agent team improves over time.

## When to Use

Run this skill in any of these situations:
- After completing a Tier 1, 2, or 3 task
- When the human corrected you on the same issue twice (two-strike rule)
- When you discovered a non-obvious pattern or convention
- When a task took significantly longer than expected
- When the human explicitly asks to update the rules

## The Two-Strike Rule

This is the core mechanism. If you are corrected on the same type of issue twice:

1. **First correction** — Fix the issue, note it mentally
2. **Second correction** — Fix the issue AND run `apex-learn` to add a permanent rule

This prevents the same mistake from recurring across sessions.

## Workflow

1. Identify friction points
2. Classify the learning
3. Draft the rule
4. Append to AGENTS.md
5. Verify the update

### Step 1: Identify Friction Points

Ask yourself these questions about the completed task:

```markdown
## Friction Analysis

1. Where did I get stuck or make mistakes?
2. What did the human correct me on?
3. What took longer than expected and why?
4. What assumptions did I make that were wrong?
5. What patterns did I discover that aren't documented?
```

### Step 2: Classify the Learning

Each learning falls into one of these categories:

| Category | Example | Where it Goes in AGENTS.md |
|----------|---------|---------------------------|
| **Code style** | "Always use named exports" | `## Code Style` section |
| **Architecture** | "Services never call controllers" | `## Architecture Rules` section |
| **Workflow** | "Always run tests before committing" | `## Workflow` section |
| **Boundaries** | "Never modify the auth module" | `## Boundaries` section |
| **Preferences** | "Prefer descriptive over short names" | `## Preferences` section |
| **Tool usage** | "Use pnpm, not npm" | `## Tools` section |

### Step 3: Draft the Rule

Write the rule in imperative form. Be specific and actionable:

**Good rules:**
```markdown
- Always use `pnpm` instead of `npm` for package management
- Never modify files in `src/auth/` without explicit approval
- When creating API endpoints, always include rate limiting middleware
```

**Bad rules:**
```markdown
- Be careful with packages (too vague)
- Try to write good code (not actionable)
- Remember the auth thing (not specific)
```

### Step 4: Append to AGENTS.md

Run the learning script to safely append the new rule:

**Linux/Mac:**
```bash
bash "${CLAUDE_SKILL_DIR}/scripts/append-learning.sh" "<category>" "<rule-text>"
```

**Windows:**
```powershell
powershell -File "${CLAUDE_SKILL_DIR}/scripts/append-learning.ps1" "<category>" "<rule-text>"
```

If AGENTS.md does not exist, create it using the template in [references/agents-template.md](references/agents-template.md).

### Step 5: Verify the Update

Read AGENTS.md after the update. Confirm:
- The new rule is in the correct section
- It does not duplicate an existing rule
- It does not contradict an existing rule
- The file is still well-formatted

If a contradiction is found, present both rules to the human and ask which takes priority.

## Output

An updated AGENTS.md file with the new rule appended to the correct section, committed with message `docs: apex-learn — add rule for {category}`.
