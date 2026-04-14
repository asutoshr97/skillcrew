# Skillcrew

Developer productivity skills for [Claude Code](https://claude.com/claude-code). Agent teams, plan management, and more.

## Skills

### Logpose

Plan management system with agent team execution. Create, track, and automatically execute project plans using isolated git worktrees and a 4-agent team (Developer, QA, Code Reviewer, CVE Scanner).

| Skill | Description |
|-------|-------------|
| `/logpose-create` | Interactively create a new plan document |
| `/logpose-list` | Dashboard view of all plans with filtering |
| `/logpose-suggest` | Analyze codebase for plan candidates (TODOs, code smells, git churn) |
| `/logpose-update` | Modify plan status, check off tasks, add notes |
| `/logpose-start` | Execute a plan via agent team in an isolated worktree, then PR |

**`/logpose-start` agent team flow:**
```
Developer (sequential) → QA + Code Reviewer + CVE Scanner (parallel)
    ↓ all pass → commit, push, open PR, mark done
    ↓ any fail → report issues, keep in-progress
```

## Installation

### Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/asutoshr97/skillcrew/main/install.sh | bash
```

### Manual Install

```bash
# Clone the repo
git clone https://github.com/asutoshr97/skillcrew.git /tmp/skillcrew

# Copy skills to your project
mkdir -p .claude/commands
cp /tmp/skillcrew/skills/logpose/*.md .claude/commands/

# Set up the knowledge directory
mkdir -p knowledge
cp /tmp/skillcrew/templates/knowledge-readme.md knowledge/README.md

# Clean up
rm -rf /tmp/skillcrew
```

### Verify

After installation, start Claude Code in your project and type `/logpose-list`. You should see the empty knowledge dashboard.

## Plan Document Format

Each plan is a markdown file in `knowledge/` with YAML frontmatter:

```markdown
---
title: Feature Name
status: planned | in-progress | done | abandoned
priority: high | medium | low
risk: low | medium | high | critical
area: backend | frontend | infra | docs | ...
created: 2026-04-15
updated: 2026-04-15
---

## Summary
What this is and why it matters.

## Tasks
- [ ] Concrete step 1
- [ ] Concrete step 2

## Implementation Details
Free-flow architecture notes, code paths, approach details.

## Notes
Timestamps, context, decisions.
```

## Contributing

Add new skill sets by creating a directory under `skills/` with your `.md` command files. Follow the existing logpose pattern for structure.

## License

MIT
