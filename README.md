# APEX

**Agentic Production Engineering eXecution**

A cross-platform skill framework for AI-driven replatforming, migration, and high-velocity engineering workflows. Inspired by the [Kilo Speed methodology](https://blog.kilo.ai/p/inside-kilo-speed-how-one-engineer-52c) — where one engineer completed a 6-12 month replatforming project in ~4 weeks.

[![GitHub stars](https://img.shields.io/github/stars/OthmanAdi/APEX?style=social)](https://github.com/OthmanAdi/APEX)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Cross Platform](https://img.shields.io/badge/platform-Windows%20%7C%20macOS%20%7C%20Linux-lightgrey)](https://github.com/OthmanAdi/APEX)
[![Agent Skills Standard](https://img.shields.io/badge/standard-agentskills.io-green)](https://agentskills.io)

---

## The Problem

Traditional replatforming and migration projects take **6-12 months** with a dedicated team. Engineers spend countless hours on:
- Manually analyzing legacy codebases feature by feature
- Writing detailed specifications by hand
- Implementing the same logic in new architectures
- Running repetitive validation cycles
- Context-switching between tasks

## The Solution

APEX transforms how you work with AI agents by providing:

| Skill | Purpose | Tier |
|-------|---------|------|
| `apex-decompose` | Extract feature specs from legacy code | Foundation |
| `apex-replatform` | Implement specs in new architecture | Foundation |
| `apex-tier1` | Fire-and-forget tasks (review on GitHub) | Autonomy |
| `apex-tier2` | Guided tasks (check every 30 min) | Supervision |
| `apex-tier3` | Pair programming (conversational) | Collaboration |
| `apex-learn` | Self-improvement loop (AGENTS.md) | Memory |

### Core Methodology

```
┌─────────────────┐     ┌──────────────────┐     ┌─────────────────┐
│  apex-decompose │ ──► │  apex-replatform │ ──► │  validate.sh    │
│  Extract specs  │     │  Implement new   │     │  Self-correct   │
│  from legacy    │     │  architecture    │     │  lint→test→build│
└─────────────────┘     └──────────────────┘     └─────────────────┘
         │                                               │
         └───────────────► apex-learn ◄──────────────────┘
                           (Two-strike rule → AGENTS.md)
```

## Installation

### Quick Install

```bash
# Clone the repository
git clone https://github.com/OthmanAdi/APEX.git
cd APEX

# Install all skills to your agent skills directory
cp -r .agents/skills/* ~/.agents/skills/
```

### Manual Install (Individual Skills)

```bash
# Install specific skills
cp -r .agents/skills/apex-decompose ~/.agents/skills/
cp -r .agents/skills/apex-replatform ~/.agents/skills/
cp -r .agents/skills/apex-tier1 ~/.agents/skills/
cp -r .agents/skills/apex-tier2 ~/.agents/skills/
cp -r .agents/skills/apex-tier3 ~/.agents/skills/
cp -r .agents/skills/apex-learn ~/.agents/skills/
```

### Prerequisites

- Any AI assistant with file Read/Write/Edit capabilities (Claude Code, Cursor, Windsurf, Codex CLI, etc.)
- Works on Windows, macOS, and Linux
- Optional: Node.js, Python, Go, or Rust for validation scripts

## Usage

### Step 1: Initialize AGENTS.md

```bash
# Copy the template to your project root
cp templates/AGENTS.md.template /path/to/your/project/AGENTS.md
```

### Step 2: Decompose Legacy Features

```markdown
/apex-decompose

Target: src/auth/ directory from legacy codebase
Output: Detailed specification for authentication feature
```

The agent will:
1. Read all relevant files from the legacy codebase
2. Generate an extensive, agent-ready specification
3. Ask clarifying questions before finalizing

### Step 3: Replatform to New Architecture

```markdown
/apex-replatform

Spec: The generated specification from Step 2
Target: New codebase architecture
Context: TypeScript + Bun + Hono framework
```

### Step 4: Validate & Self-Correct

```bash
# Run the validation chain
./scripts/validate.sh  # Linux/macOS
./scripts/validate.ps1 # Windows
```

The validation script detects your project type and runs:
- **Lint** → **Type Check** → **Tests** → **Build**

### Step 5: Capture Learnings

```markdown
/apex-learn

Task completed with issues: Agent tried using npm instead of bun
```

This appends learnings to your `AGENTS.md` file.

## Three Tiers of Agent Interaction

APEX implements the tiered approach from the Kilo Speed methodology:

### Tier 1: Fire and Forget
```markdown
/apex-tier1

Task: Remove the dist/ directory from git tracking, add to .gitignore
```
- One prompt, no attention required
- Review the final PR on GitHub
- Like delegating to an intern

### Tier 2: Check In Occasionally
```markdown
/apex-tier2

Task: Implement user dashboard with charts and filters
Check-in: Every 30 minutes
```
- Steer the agent periodically
- Focus elsewhere between check-ins
- Like assigning to a junior engineer

### Tier 3: Pair Programming
```markdown
/apex-tier3

Task: Design the authentication flow architecture
Mode: Conversational, iterative
```
- Work together in real-time
- High-level architectural decisions
- Like pairing with a senior engineer

## The Two-Strike Rule

APEX implements a self-improvement pattern:

1. **First correction**: Guide the agent through the issue
2. **Second correction**: Write a permanent rule to `AGENTS.md`

Example `AGENTS.md` entry:
```markdown
## Learnings Log

### 2026-03-14: Build System
- Always use `bun run build` instead of `npm run build`
- Agent tried npm twice before this rule was added
```

## Project Structure

```
APEX/
├── .agents/
│   └── skills/
│       ├── apex-decompose/     # Feature extraction skill
│       ├── apex-replatform/    # Implementation skill
│       ├── apex-tier1/         # Fire-and-forget tier
│       ├── apex-tier2/         # Guided tier
│       ├── apex-tier3/         # Pair programming tier
│       └── apex-learn/         # Self-improvement skill
├── scripts/
│   ├── validate.sh             # Linux/macOS validation
│   └── validate.ps1            # Windows validation
├── templates/
│   └── AGENTS.md.template      # Project memory template
└── README.md
```

## Compatibility

| Agent | Status | Notes |
|-------|--------|-------|
| Claude Code | ✅ Full | Primary target |
| Cursor | ✅ Full | SKILL.md format supported |
| Windsurf | ✅ Full | SKILL.md format supported |
| Codex CLI | ✅ Full | SKILL.md format supported |
| OpenAI Agents | ✅ Full | Via agentskills.io standard |
| Continue | ⚠️ Partial | May need adaptation |

## What Makes APEX Different

| Traditional Approach | APEX Approach |
|---------------------|---------------|
| 6-12 months with a team | Weeks with one engineer + agents |
| Manual specification writing | Agent-generated specs |
| Sequential validation | Parallel agent validation |
| Knowledge lost between tasks | Persistent AGENTS.md memory |
| Single-tier agent usage | Three calibrated tiers |
| Ad-hoc corrections | Two-strike rule automation |

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Roadmap

- [ ] Benchmark suite for measuring velocity improvements
- [ ] Integration tests for all skills
- [ ] Community showcase section
- [ ] Video tutorials
- [ ] Multi-language support (German, Spanish)

## Acknowledgments

- Inspired by [Mark IJbema's workflow](https://blog.kilo.ai/p/inside-kilo-speed-how-one-engineer-52c) at Kilo Code
- Built on the [Agent Skills Open Standard](https://agentskills.io)
- Cross-platform patterns from the community

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

> "I like to think of software engineering as gardening instead of building. You can just say: take care of that, remove that weed. That's much closer to how it feels to interact with an agent."
> — Mark IJbema, Kilo Code
