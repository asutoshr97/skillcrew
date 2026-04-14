# Logpose — Update Plan

Modify an existing plan document in the `knowledge/` directory.

**Arguments:** $ARGUMENTS
- Required: slug name of the plan (e.g., `payments-v2`)
- Optional action: `check <task number>`, `status <new-status>`, `priority <new-priority>`, `risk <new-risk>`, `note <text>`

## Process

### Step 1: Load the Plan

Read `knowledge/<slug>.md`. If the file doesn't exist, list available plans from `knowledge/` and ask the user to pick one.

### Step 2: Apply Updates

If specific actions were provided in arguments, apply them directly:

- **`check <N>`** — Check off task number N in the Tasks section (change `- [ ]` to `- [x]`)
- **`status <value>`** — Update the `status` field in frontmatter. Valid: `planned`, `in-progress`, `done`, `abandoned`
- **`priority <value>`** — Update the `priority` field. Valid: `high`, `medium`, `low`
- **`risk <value>`** — Update the `risk` field. Valid: `low`, `medium`, `high`, `critical`
- **`note <text>`** — Append the text to the Notes section with a timestamp: `- [YYYY-MM-DD] <text>`

If no actions were provided, show the current plan contents and ask the user what they'd like to change. Support interactive updates:
- Check/uncheck tasks
- Change status, priority, risk
- Add/edit notes
- Modify implementation details
- Add new tasks

### Step 3: Update Metadata

- Always update the `updated` field in frontmatter to today's date
- If all tasks are checked, suggest changing status to `done`

### Step 4: Update the Index

Read `knowledge/README.md`. Update the plan's entry to reflect current status:
- If status changed, move the entry to the correct section
- Update the one-line summary if the title or priority changed
- If a section becomes empty after moving, restore the `_None yet._` placeholder

### Step 5: Commit

Stage and commit both files:
```bash
git add knowledge/<slug>.md knowledge/README.md
git commit -m "logpose: update <slug> — <brief description of change>"
```
