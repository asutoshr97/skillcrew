# Logpose — Suggest Plans

Analyze the codebase and suggest new plan candidates for the `knowledge/` directory.

**Arguments:** $ARGUMENTS
- Optional: area to focus on (e.g., `backend`, `frontend`, `infra`)

## Process

### Step 1: Read Existing Plans

Read all `.md` files in `knowledge/` to understand what's already tracked. Avoid suggesting duplicates.

### Step 2: Analyze the Codebase

Run the following analyses (in parallel where possible):

1. **TODOs and FIXMEs** — Search the codebase for `TODO`, `FIXME`, `HACK`, `XXX` comments. Group by file/area.
   ```bash
   grep -rn 'TODO\|FIXME\|HACK\|XXX' --include='*.py' --include='*.ts' --include='*.tsx' --include='*.js' --include='*.jsx' --include='*.go' --include='*.rs' .
   ```

2. **Recent git activity** — Look at the last 30 commits for patterns: what areas are getting the most churn? What's been started but not finished?
   ```bash
   git log --oneline -30
   git log --oneline -30 --name-only
   ```

3. **Open issues** — If a GitHub remote exists, check for open issues:
   ```bash
   gh issue list --limit 20 2>/dev/null
   ```

4. **Code quality signals** — Look for large files, complex functions, or areas lacking tests:
   - Files over 500 lines
   - Directories with no test files

5. **CLAUDE.md mentions** — Check area-specific CLAUDE.md files for any noted limitations, known issues, or planned work.

### Step 3: Present Suggestions

Present findings as a numbered list of potential plans. For each suggestion:

- **Title** — Short, actionable name
- **Area** — Which part of the codebase
- **Why** — What signal triggered this suggestion (TODO comment, code smell, git churn, etc.)
- **Estimated risk** — How dangerous would these changes be
- **Priority recommendation** — Based on impact and effort

Example:
```
1. "OTP Retry Logic" [backend] [high priority]
   Why: 3 TODO comments in consumer_auth.py about retry handling
   Risk: high (touches auth flow)

2. "RAG Index Rebuild Performance" [scripts] [medium priority]
   Why: build_rag_index.py is 600+ lines, heavy git churn in last 10 commits
   Risk: low (offline tooling only)
```

### Step 4: Create Selected Plans

Ask the user which suggestions (if any) they want to turn into plan documents. For each approved suggestion, invoke the `/logpose-create` workflow to create the full plan document with tasks and implementation details.
