# Worktrees

The issue tracker is the source of truth for the spec, tickets, and blocking edges. Worktree existence only describes a checkout. To resume, reread the tracker, then inspect `git worktree list`, `git branch -vv`, and `git log --oneline --graph --decorate`.

## Layout

- Integration: `.agents/worktree/spec-<n>` on `feat/spec-<n>`.
- Ticket: `.agents/worktree/issue-<n>` on `feat/issue-<n>`.
- Review fix: `.agents/worktree/spec-<n>-review` on `fix/spec-<n>-review`.

Use the spec and issue numbers. Keep names globally unique. For a local tracker, prefix ticket ids with the spec slug, for example `issue-auth-01` on `feat/issue-auth-01`. For a bug or docs spec, replace `feat` with `fix` or `docs` in the integration and ticket branches; the review branch stays `fix`.

## Base

Create the integration worktree from the base SHA recorded at preflight. The default is the main checkout's HEAD; use another base only when the user names one. Use the same base SHA for the code review fixed point and the final diff.

Ticket and review worktrees start from the current integration tip.

## Rules

- Run every `git worktree` command from the main checkout.
- The main checkout keeps its original branch and working tree. It may add, remove, and prune worktrees, and delete merged branches. It must not checkout, switch, merge, reset, clean, or stash.
- Do not create a worktree from inside an integration, ticket, or review worktree.
- Add `.agents/worktree/` to `.gitignore`, leave `.agents/notes/` unignored, and exclude `.agents/worktree/**` from tests and lint.

## Checks

Run the ticket checks in the ticket worktree and the integration checks in the integration worktree. Use the commands recorded here:

- Ticket: `none`.
- Integration: `none`.

If the repo has no ticket or integration check, write `none` and require the user to confirm before merging.

## Merge

Merge one ticket or review fix at a time in the integration worktree with `git merge --no-ff`. Run the integration checks after each merge. Do not start the next merge until the current one passes.

On conflict, run `git merge --abort` and return the branch to a fresh implementer. The implementer merges the integration tip into its branch and resolves the conflict there.

If the integration checks fail, reset the integration worktree to the pre-merge commit with `git reset --hard <pre-merge-sha>` when the branch is not pushed. If it is pushed, revert the merge commit. Return the branch to its implementer and do not continue merging.

## Cleanup

Remove a ticket worktree after its merge and checks pass. Remove the review worktree after its fix is merged. Remove a worktree only when it is clean.

Keep the integration worktree until the PR merges. For a local effort without a PR, remove it after the user confirms the effort is done.
