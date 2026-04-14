# Logpose — List Plans

Display all plan documents from the `knowledge/` directory as a dashboard view.

**Arguments:** $ARGUMENTS
- Optional filter: a status (`planned`, `in-progress`, `done`, `abandoned`), priority (`high`, `medium`, `low`), or any area name

## Process

1. Read `knowledge/README.md` to get the full index.

2. If no filter argument was provided, display the full index as-is — it's already grouped by status.

3. If a filter was provided, read all `.md` files in `knowledge/` (excluding README.md), parse their frontmatter, and display only matching plans. Match against `status`, `priority`, or `area` fields.

4. For each plan shown, display:
   - Title (linked to file)
   - Status, Priority, Risk, Area
   - Task progress: count of checked vs total checkboxes (e.g., `3/7 tasks done`)

5. Output format — render as a clean text table or grouped list in the terminal. Example:

```
## Planned (3)
  payments-v2           [high] [critical risk] [backend]    0/5 tasks
  rag-improvements      [medium] [low risk] [scripts]       0/3 tasks
  figure-queue-v2       [low] [medium risk] [builder]       0/4 tasks

## In Progress (1)
  otp-reliability       [high] [high risk] [backend]        2/4 tasks
```

This is a read-only skill. Do not modify any files.
