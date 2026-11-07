# AGENTS.md

This repo is a local skill library, not a published plugin.

- Do not add plugin manifests, marketplace metadata, release tooling, or published marketing docs. `docs/agents/` is runtime configuration and stays.
- Keep any `agents/openai.yaml` a skill has: it is local Codex runtime metadata for display names and implicit-invocation policy, not a publishing manifest.
- Do not add an upstream remote or sync from the original repository.
- Skills live at `skills/<bucket>/<skill-name>/SKILL.md`.
- Buckets are `engineering`, `productivity`, `misc`, `in-progress`, and `deprecated`.
- When adding, renaming, or removing a skill, update its bucket README and the top-level README.
- When a user-reachable skill is added, renamed, or removed, update its entry in `skills/engineering/ask-matt/SKILL.md`.
- Keep prose free of em-dashes.
- Do not write code comments.

Run `scripts/link-skills.sh` after changing the skill set.

## Agent skills

### Issue tracker

GitHub Issues on `mutuguangda/skills`. See `docs/agents/issue-tracker.md`.

### Triage labels

Canonical names, unchanged. See `docs/agents/triage-labels.md`.

### Domain docs

Single-context: `GLOSSARY.md` at the root and decisions in `docs/adr/`. See `docs/agents/domain.md`.
