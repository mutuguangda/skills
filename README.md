# Skills

A local, independently maintained collection of agent skills. Forked from
[mattpocock/skills](https://github.com/mattpocock/skills) and extended with
[write-notes-like-deepseek](https://github.com/czm15053/write-notes-like-deepseek).

This repo is not published as a plugin. It is a working copy that is linked into
the local agent skill directory.

## Layout

- `skills/engineering/`: daily code work
- `skills/productivity/`: daily non-code workflow tools
- `skills/misc/`: kept around but rarely used
- `skills/in-progress/`: beta skills that may change or disappear
- `skills/deprecated/`: retired skills

## Engineering

- **[ask-matt](./skills/engineering/ask-matt/SKILL.md)**: Ask which skill or flow fits your situation.
- **[code-review](./skills/engineering/code-review/SKILL.md)**: Review a diff since a fixed point on two axes: standards and spec.
- **[codebase-design](./skills/engineering/codebase-design/SKILL.md)**: Shared vocabulary for designing deep modules.
- **[diagnosing-bugs](./skills/engineering/diagnosing-bugs/SKILL.md)**: Diagnosis loop for hard bugs and performance regressions.
- **[domain-modeling](./skills/engineering/domain-modeling/SKILL.md)**: Build and sharpen a project's domain model, glossary, and ADRs.
- **[grill-with-docs](./skills/engineering/grill-with-docs/SKILL.md)**: Relentless interview that also creates ADRs and glossary entries.
- **[implement](./skills/engineering/implement/SKILL.md)**: Implement a piece of work from a spec or set of tickets.
- **[implement-spec](./skills/engineering/implement-spec/SKILL.md)**: Implement a whole spec on one branch with parallel implementers.
- **[improve-codebase-architecture](./skills/engineering/improve-codebase-architecture/SKILL.md)**: Scan for design opportunities and turn them into a visual report.
- **[pr](./skills/engineering/pr/SKILL.md)**: Write a focused PR body with evidence and blast radius.
- **[prototype](./skills/engineering/prototype/SKILL.md)**: Build a throwaway prototype to answer a design question.
- **[research](./skills/engineering/research/SKILL.md)**: Investigate a question against primary sources and capture a cited note.
- **[retro](./skills/engineering/retro/SKILL.md)**: Retrospect on a coding session and improve the agent environment.
- **[setup-matt-pocock-skills](./skills/engineering/setup-matt-pocock-skills/SKILL.md)**: Configure a repo's issue tracker, labels, and domain docs.
- **[tdd](./skills/engineering/tdd/SKILL.md)**: Test-driven development with a red-green-refactor loop.
- **[to-spec](./skills/engineering/to-spec/SKILL.md)**: Turn the current conversation into a spec.
- **[to-tickets](./skills/engineering/to-tickets/SKILL.md)**: Break a plan or spec into tracer-bullet tickets with blocking edges.
- **[triage](./skills/engineering/triage/SKILL.md)**: Move issues and external PRs through triage roles.
- **[wayfinder](./skills/engineering/wayfinder/SKILL.md)**: Plan work larger than one session as a map of decision tickets.
- **[wizard](./skills/engineering/wizard/SKILL.md)**: Generate an interactive bash wizard for human-only steps.
- **[write-notes-like-deepseek](./skills/engineering/write-notes-like-deepseek/SKILL.md)**: Record the why and rejected options for non-trivial changes in `.agents/notes/`.

## Productivity

- **[grill-me](./skills/productivity/grill-me/SKILL.md)**: Relentless interview to sharpen a plan or design.
- **[grilling](./skills/productivity/grilling/SKILL.md)**: Stress-test a plan, decision, or idea.
- **[handoff](./skills/productivity/handoff/SKILL.md)**: Compact the current conversation into a handoff document.
- **[teach](./skills/productivity/teach/SKILL.md)**: Teach a skill or concept over multiple sessions.
- **[to-questionnaire](./skills/productivity/to-questionnaire/SKILL.md)**: Turn a decision into a questionnaire for someone else.
- **[wait-what](./skills/productivity/wait-what/SKILL.md)**: Re-pitch the last message with the missing context.
- **[writing-for-agents](./skills/productivity/writing-for-agents/SKILL.md)**: Write skills and instruction files for agents.

## Misc

- **[git-guardrails-claude-code](./skills/misc/git-guardrails-claude-code/SKILL.md)**: Block dangerous git commands with Claude Code hooks.
- **[migrate-to-shoehorn](./skills/misc/migrate-to-shoehorn/SKILL.md)**: Replace `as` assertions in tests with @total-typescript/shoehorn.
- **[scaffold-exercises](./skills/misc/scaffold-exercises/SKILL.md)**: Create exercise directory structures with sections and solutions.
- **[setup-pre-commit](./skills/misc/setup-pre-commit/SKILL.md)**: Set up Husky, lint-staged, type checking, and tests.

## In Progress

Beta skills. They can change or disappear without notice.

- **[chief-of-staff](./skills/in-progress/chief-of-staff/SKILL.md)**: Pursue a long-running goal by co-ordinating subagents.
- **[claude-handoff](./skills/in-progress/claude-handoff/SKILL.md)**: Hand the conversation to a fresh background agent.
- **[loop-me](./skills/in-progress/loop-me/SKILL.md)**: Grill yourself into implementable workflow specs.
- **[setup-ts-deep-modules](./skills/in-progress/setup-ts-deep-modules/SKILL.md)**: Enforce deep-module boundaries in a TypeScript repo.
- **[software-factory](./skills/in-progress/software-factory/SKILL.md)**: Shared language for designing a software factory.
- **[writing-beats](./skills/in-progress/writing-beats/SKILL.md)**: Shape writing as a journey of beats.
- **[writing-fragments](./skills/in-progress/writing-fragments/SKILL.md)**: Mine raw fragments before imposing structure.
- **[writing-shape](./skills/in-progress/writing-shape/SKILL.md)**: Shape raw material into an article paragraph by paragraph.

## Deprecated

Currently empty.

## Usage

Link every active skill into `~/.agents/skills`:

```sh
./scripts/link-skills.sh
```

Pass a different destination as the first argument if needed. Each entry is a
symlink into this repo, so edits here are picked up immediately.

## Maintenance

- There is no upstream remote and nothing is synced from the original repo.
- Skills live at `skills/<bucket>/<skill-name>/SKILL.md`.
- Per-repo skill configuration lives in `docs/agents/`; domain language is in `GLOSSARY.md`; decisions are in `docs/adr/`.
- When adding, renaming, or removing a skill, update its bucket README and this file.
- When a user-reachable skill changes, update its entry in `skills/engineering/ask-matt/SKILL.md`.

## Credits

- [mattpocock/skills](https://github.com/mattpocock/skills), MIT.
- [czm15053/write-notes-like-deepseek](https://github.com/czm15053/write-notes-like-deepseek), MIT.
