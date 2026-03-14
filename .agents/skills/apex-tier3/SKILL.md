---
name: apex-tier3
description: Real-time pair programming mode for complex architectural work. The agent and human collaborate interactively on design decisions, complex debugging, or exploratory work. Use for high-stakes tasks, new architecture design, critical bug investigation, or when every step needs discussion. Triggers on keywords like pair, collaborate, design together, debug with me, architect, explore.
---

# APEX Tier 3 — Pair Mode

Work side-by-side with the human in real-time. Every significant decision is discussed. The agent proposes, the human approves or redirects.

## When to Use

**Use Tier 3 when:**
- Designing new architecture from scratch
- Debugging a critical production issue
- The problem space is ambiguous or exploratory
- The human wants to learn from the process
- Stakes are high and mistakes are expensive

## Interaction Protocol

### The Propose-Confirm Loop

Every action follows this pattern:

1. **Agent proposes** — "I think we should do X because Y. Here's what that looks like..."
2. **Human confirms, modifies, or rejects** — "Yes" / "Do X but change Z" / "No, try A instead"
3. **Agent executes** — Implements the confirmed approach
4. **Agent reports** — "Done. Here's what changed. Ready for next step."

### Rules of Engagement

- **Never write more than 50 lines** without checking in
- **Always explain WHY** before proposing WHAT
- **Show alternatives** when there's a genuine trade-off: "Option A gives us X but costs Y. Option B gives us Z but costs W."
- **Admit uncertainty** — "I'm not confident about this approach because..." is always better than guessing
- **No yes-man behavior** — If the human's suggestion has a flaw, say so respectfully with evidence

## Workflow

### Opening

Start by understanding the problem space:

```markdown
Before we start, I need to understand:
1. What are we trying to achieve?
2. What constraints exist (time, tech, compatibility)?
3. What have you already tried or considered?
4. What does success look like?
```

### During the Session

Maintain a running decision log:

```markdown
## Decision Log

| # | Decision | Rationale | Alternatives Considered |
|---|----------|-----------|------------------------|
| 1 | Use Prisma over Drizzle | Team familiarity | Drizzle (faster), raw SQL (flexible) |
| 2 | REST over GraphQL | Simpler for this scope | GraphQL (flexible queries) |
```

After every significant block of work, run validation:

**Linux/Mac:**
```bash
bash "${CLAUDE_SKILL_DIR}/scripts/validate.sh" <target-dir>
```

**Windows:**
```powershell
powershell -File "${CLAUDE_SKILL_DIR}/scripts/validate.ps1" <target-dir>
```

### Closing

At the end of the session:

1. Summarize all decisions made
2. List any open questions or TODOs
3. Identify learnings that should be added to AGENTS.md
4. Commit work with a descriptive message referencing the decision log

## Output

Working code with a complete decision log. Any recurring patterns or preferences discovered during the session are candidates for AGENTS.md updates via `apex-learn`.

**Example decision log:**

```markdown
## Decision Log — Event System Architecture

| # | Decision | Rationale | Alternatives Considered |
|---|----------|-----------|------------------------|
| 1 | Use EventEmitter over message queue | Simpler for current scale, can migrate later | RabbitMQ, Redis pub/sub |
| 2 | Typed events with Zod schemas | Runtime validation + TypeScript inference | io-ts, manual types |
| 3 | Async handlers by default | Non-blocking, better throughput | Sync handlers |
| 4 | Dead letter queue for failures | Debugging + replay capability | Log and drop |

## Open Questions
- [ ] Should we add event versioning now or later?
- [ ] Rate limiting for high-frequency events?

## Learnings for AGENTS.md
- Always use typed events (add to Architecture Rules)
- Prefer async handlers unless order matters (add to Preferences)
```
