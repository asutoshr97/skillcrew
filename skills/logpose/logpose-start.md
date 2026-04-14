# Logpose — Start Plan Execution

Execute a plan from the `knowledge/` directory using an agent team in an isolated git worktree.

**Arguments:** $ARGUMENTS
- Required: slug name of the plan (e.g., `payments-v2`)

## Process

### Step 1: Load and Validate the Plan

1. Read `knowledge/<slug>.md`. If the file doesn't exist, list available plans and ask the user to pick one.
2. Verify the plan has status `planned` or `in-progress`. If status is `done` or `abandoned`, warn the user and confirm before proceeding.
3. Parse the Tasks and Implementation Details sections — these drive the Developer agent.
4. Update the plan status to `in-progress` and commit:
   ```bash
   git add knowledge/<slug>.md knowledge/README.md
   git commit -m "logpose: start execution of <slug>"
   ```

### Step 2: Create Worktree

Create an isolated git worktree for this plan:
```bash
git worktree add ../logpose-<slug> -b logpose/<slug>
```

All agent work happens in the worktree directory `../logpose-<slug>`, not in the main working tree.

### Step 3: Run Developer Agent

Launch a single **Developer** agent (using the Agent tool) in the worktree. The agent's prompt must include:

- The full contents of the plan's **Tasks** and **Implementation Details** sections
- The path to the worktree: `../logpose-<slug>`
- Instruction to read relevant CLAUDE.md files for project conventions
- Instruction to execute each task in order, checking them off as completed
- Instruction to run build/compile checks after implementation

**Wait for the Developer agent to complete before proceeding.**

### Step 4: Run Review Agents in Parallel

After the Developer agent completes, launch three agents **simultaneously** (all in the same Agent tool call, using the worktree path):

#### QA Agent
Prompt must include:
- The plan's **Tasks** section (as acceptance criteria)
- Worktree path: `../logpose-<slug>`
- Instructions: Run any existing test suites affected by the changes. Verify each task's acceptance criteria. Check for regressions. Report pass/fail with specific details on any failures.

#### Code Reviewer Agent
Prompt must include:
- The plan's **Summary** and **Tasks** sections (as intent reference)
- Worktree path: `../logpose-<slug>`
- Instructions: Run `git diff main` in the worktree to see all changes. Review against the plan's intent. Check adherence to project conventions (read CLAUDE.md files). Flag unnecessary changes, missing edge cases, or scope drift. Report approve/request-changes with specific feedback.
- Use subagent_type: `superpowers:code-reviewer`

#### CVE Scanner Agent
Prompt must include:
- Worktree path: `../logpose-<slug>`
- Instructions: Run `git diff main` in the worktree to identify changed files. Scan all changed code for OWASP Top 10 vulnerabilities: SQL injection, XSS, command injection, path traversal, hardcoded secrets, insecure deserialization. Check any new dependencies for known CVEs. Report pass/fail with severity ratings for each finding.

### Step 5: Evaluate Results

Collect results from all three review agents.

**If all pass (QA pass + Reviewer approves + CVE Scanner pass):**

1. Stage and commit all changes in the worktree:
   ```bash
   cd ../logpose-<slug>
   git add -A
   git commit -m "logpose: implement <slug>

   Plan: knowledge/<slug>.md
   Agent team: Developer, QA, Code Reviewer, CVE Scanner — all passed

   Co-Authored-By: Claude Opus 4.6 (1M context) <noreply@anthropic.com>"
   ```

2. Push the branch:
   ```bash
   git push -u origin logpose/<slug>
   ```

3. Create a PR:
   ```bash
   gh pr create --title "<plan title>" --body "$(cat <<'EOF'
   ## Summary
   <plan summary from the document>

   ## Plan
   Executed from `knowledge/<slug>.md`

   ## Agent Team Results
   - Developer: completed all tasks
   - QA: passed
   - Code Reviewer: approved
   - CVE Scanner: passed

   ## Tasks Completed
   <checked task list from the plan>

   🤖 Generated with [Claude Code](https://claude.com/claude-code) via `/logpose start`
   EOF
   )"
   ```

4. Update the plan document:
   - Set `status: done`
   - Set `updated: <today>`
   - Add a note: `- [YYYY-MM-DD] Executed via /logpose start. PR: <PR URL>`

5. Update `knowledge/README.md` — move the plan entry from its current section to `## Done`.

6. Commit the plan updates:
   ```bash
   git add knowledge/<slug>.md knowledge/README.md
   git commit -m "logpose: mark <slug> as done — PR #<number>"
   ```

7. Clean up the worktree:
   ```bash
   git worktree remove ../logpose-<slug>
   ```

**If any agent fails:**

1. Report which agent(s) failed and their specific feedback
2. Keep the worktree intact for manual inspection: `../logpose-<slug>`
3. Keep plan status as `in-progress`
4. Add a note to the plan: `- [YYYY-MM-DD] /logpose start: <agent> reported issues — <brief summary>`
5. Commit the plan update
6. Tell the user they can inspect the worktree, fix issues, and re-run `/logpose start <slug>`
