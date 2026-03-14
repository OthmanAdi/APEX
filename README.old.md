# APEX

**Agentic Production Engineering eXecution**

A cross-platform skill framework for AI-driven replatforming, migration, and high-velocity engineering workflows. Built on the [Agent Skills open standard](https://agentskills.io), compatible with Claude Code, OpenAI Codex, Cursor, and OpenClaw.

## What Is This?

APEX turns a single engineer into a team lead managing AI agents. Instead of writing code yourself, you decompose features into specs, delegate implementation to autonomous agents at the right trust level, and let self-correcting feedback loops handle the rest.

Inspired by the methodology described in [Inside Kilo Speed](https://blog.kilo.ai/p/inside-kilo-speed-how-one-engineer-52c) and the self-improving agent patterns from [Addy Osmani](https://addyosmani.com/blog/self-improving-agents/).

## Skills

| Skill | Purpose | When to Use |
|-------|---------|-------------|
| `apex-decompose` | Extract feature specs from existing code | Before any migration or replatforming |
| `apex-replatform` | Implement specs in a new architecture | After decomposition, when rebuilding |
| `apex-tier1` | Fire-and-forget autonomous execution | Clear tasks with objective pass/fail |
| `apex-tier2` | Guided execution with checkpoints | Multi-file changes needing steering |
| `apex-tier3` | Real-time pair programming | Architecture design, critical debugging |
| `apex-learn` | Self-improvement and memory updates | After any task with friction or corrections |

## Installation

### Claude Code / Cursor / Windsurf
Copy the `.agents/skills/` directory into your project root.

### OpenAI Codex
Copy the `.agents/skills/` directory into your project root. Codex auto-detects skills.

### User-Level (All Projects)
Copy to `~/.agents/skills/` for skills available across all your repositories.

## Cross-Platform Support

Every skill includes dual scripts:
- `scripts/*.sh` for Linux and macOS (Bash)
- `scripts/*.ps1` for Windows (PowerShell)

The agent auto-detects the host OS and runs the appropriate script.

## Quick Start

1. Copy `.agents/skills/` into your project
2. Copy `AGENTS.md` to your project root (or let `apex-learn` create one)
3. Start with: "Decompose the authentication module from `src/auth/`"
4. Then: "Replatform this spec into the new Next.js architecture"
5. After any friction: "What did we learn? Update the rules."

## The Three Tiers

Choose your level of involvement based on task complexity:

**Tier 1 — Fire and Forget:** "Add unit tests for UserService." The agent works autonomously and opens a draft PR.

**Tier 2 — Guided:** "Refactor the payment module to use Stripe v3." The agent works in phases, pausing at checkpoints for your review.

**Tier 3 — Pair:** "Let's design the new event system architecture together." Real-time collaboration with every decision discussed.

## The Self-Improvement Loop

APEX gets smarter over time. The `apex-learn` skill implements the **two-strike rule**: if you correct the agent on the same issue twice, it automatically adds a permanent rule to `AGENTS.md`. This means:

- Session 1: "Use pnpm, not npm." Agent fixes it.
- Session 2: "I said pnpm, not npm." Agent fixes it AND adds `- Always use pnpm instead of npm` to AGENTS.md.
- Session 3+: The agent never makes this mistake again.

## License

MIT