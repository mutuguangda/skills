# Issue tracker: GitHub

Issues and specs for this repo live as GitHub issues. Use the `gh` CLI for all operations.

## Conventions

- **Create an issue**: `gh issue create --title "..." --body "..."`. Use a heredoc for multi-line bodies.
- **Read an issue**: `gh issue view <number> --json number,title,body,labels,comments`.
- **List issues**: `gh issue list --state open --json number,title,body,labels,comments`.
- **Make an issue a sub-issue**: `gh issue create --parent <parent> ...`, or `gh issue edit <parent> --add-sub-issue <child>`. Without sub-issues, put `Part of #<parent>` at the top of the child body.
- **Blocking**: `gh issue create --blocked-by <n>,<n> ...`, or `gh issue edit <child> --add-blocked-by <blocker>`. Where dependencies are unavailable, put `Blocked by: #<n>, #<n>` at the top of the child body.
- **Count open blockers**: `gh api repos/<owner>/<repo>/issues/<n> --jq .issue_dependencies_summary.blocked_by`.
- **Comment on an issue**: `gh issue comment <number> --body "..."`.
- **Apply or remove labels**: `gh issue edit <number> --add-label "..."` or `--remove-label "..."`.
- **Close**: comment with the explanation, then `gh issue close <number>`.

Infer the repo from `git remote -v`. This repo is a fork of `mattpocock/skills`, so confirm the target with `gh repo view --json nameWithOwner` before the first issue of a session.

## Pull requests as a triage surface

**PRs as a request surface: no.** Set this to `yes` if external PRs should run through the same labels and states as issues.

## When a skill says "publish to the issue tracker"

Create a GitHub issue.

## When a skill says "fetch the relevant ticket"

Read it with `gh issue view <number>`.

## Wayfinding operations

Used by `wayfinder`. The map is a single issue with child issues as tickets.

- **Map**: an issue labelled `wayfinder:map` holding Notes, Decisions so far, and Fog.
- **Child ticket**: a sub-issue linked to the map, labelled `wayfinder:<type>` where type is `research`, `prototype`, `grilling`, or `task`.
- **Blocking**: use GitHub issue dependencies, or a `Blocked by:` line.
- **Frontier query**: list the map's open children and drop any with an open blocker or an assignee. First in map order wins.
- **Claim**: `gh issue edit <n> --add-assignee @me`.
- **Resolve**: comment the answer, close the issue, then append a context pointer to the map's Decisions so far.
