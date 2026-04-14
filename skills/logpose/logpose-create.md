# Logpose — Create Plan

Create a new plan document in the `knowledge/` directory.

**Arguments:** $ARGUMENTS
- Optional: title as free text (e.g., `/logpose-create payments v2 overhaul`)

## Process

### Step 1: Gather Details

If no title was provided in arguments, ask the user for one. Then ask for each of the following, one at a time:

1. **Summary** — What is this and why does it matter? (1-2 sentences)
2. **Area** — Which part of the codebase? (free text, e.g., `backend`, `frontend`, `infra`, `docs`)
3. **Priority** — `high`, `medium`, or `low`
4. **Risk** — How dangerous are these changes? `low` (cosmetic/copy), `medium` (new feature, isolated), `high` (touches auth/payments/data), `critical` (schema migration, breaking changes)

### Step 2: Generate Tasks & Implementation Details

Based on the summary and your understanding of the codebase:

1. Read relevant code files to understand the current state
2. Generate a concrete task checklist (checkbox items)
3. Write free-flow implementation details — architecture decisions, code paths to modify, approach notes. Match the style of Claude Code plan mode output.

Present the tasks and implementation details to the user for approval before writing.

### Step 3: Write the Plan Document

Generate a kebab-case slug from the title (e.g., "Payments V2 Overhaul" → `payments-v2-overhaul`).

Write the file to `knowledge/<slug>.md` using this format:

```markdown
---
title: <Title>
status: planned
priority: <high|medium|low>
risk: <low|medium|high|critical>
area: <area>
created: <YYYY-MM-DD>
updated: <YYYY-MM-DD>
---

## Summary
<summary text>

## Tasks
- [ ] Task 1
- [ ] Task 2
...

## Implementation Details
<free-flow implementation notes>

## Notes
<empty, for future use>
```

### Step 4: Update the Index

Read `knowledge/README.md`. Add the new plan under the `## Planned` section as:
```
- [<Title>](<slug>.md) — <one-line summary> [`<priority>`] [`<risk> risk`]
```

If the section currently says `_None yet._`, remove that line first.

### Step 5: Commit

Stage and commit both files:
```bash
git add knowledge/<slug>.md knowledge/README.md
git commit -m "logpose: add plan for <title>"
```
