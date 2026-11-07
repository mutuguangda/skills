---
name: implement-spec
description: "Implement a spec through its ticket graph in integration and ticket worktrees."
disable-model-invocation: true
---

You have a spec with tickets. The issue tracker is the source of truth for the spec, tickets, blocking edges, and completion.

Read `docs/agents/issue-tracker.md` and `docs/agents/worktree.md`. If either is missing, tell the user to run `/setup-workflow`.

The goal is the whole spec on one **integration branch**. Tickets form a **task graph**; the **frontier** is the open tickets with no open blockers.

Start every subagent with a fresh context window. Communicate through pointers to the spec, tickets, and commits. Run implementers in parallel, merge serially.

## Steps

1. Preflight. Record the base SHA (the main checkout's HEAD unless the user names another), plus its branch and status. Require a clean tracked tree, `.agents/worktree/` ignored, `.agents/notes/` not ignored, and test and lint excluding `.agents/worktree/**`. Done when the main checkout is safe to leave untouched.

2. Create the integration worktree from the base SHA using `docs/agents/worktree.md`. Open a draft PR after the first merge when the tracker uses PRs.

3. Start every frontier ticket in its own worktree, created from the integration tip. Give each implementer the spec, ticket, worktree path, and ticket check command. Each implementer calls `tdd`, runs the ticket check, merges the integration tip, commits, and reports its decisions, rejected alternatives, evidence, and whether a final note is warranted. Done when every frontier ticket has a running implementer.

4. Merge one ticket at a time with a single merger in the integration worktree. Run the integration check after each merge, and follow the conflict and rollback rules in `docs/agents/worktree.md`. Stop on conflict or failed checks.

5. Reread the tracker after each merge. Start newly unblocked tickets. Done when no open ticket remains.

6. Call `code-review` in the integration worktree with the base SHA as the fixed point. If it reports findings, fix them in the review worktree described by `docs/agents/worktree.md`, then merge that branch with the same serial rules.

7. Run a fresh historian after review fixes. It reads the spec, tickets, implementer reports, review report, fix diff, and `git diff <base-sha>...HEAD`; it writes one note per real decision, verifies the notes, and commits them to integration. If no note is needed, record the reason for step 8.

8. If a draft PR exists, add `## Agent notes` to the PR body with the note paths, or `None.` with the reason, and mark it ready. Otherwise close every ticket the tracker's way and report the integration branch. Clean up with the rules in `docs/agents/worktree.md`.

9. Compare the main checkout's HEAD, branch, and status with step 1. Done when they match and ticket and review worktrees are gone.
