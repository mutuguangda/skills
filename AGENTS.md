# AGENTS.md

This repo is a local skill library, not a published plugin.

- Do not add plugin manifests, marketplace metadata, release tooling, or published marketing docs. `docs/agents/` is runtime configuration and stays.
- Keep any `agents/openai.yaml` a skill has: it is local Codex runtime metadata for display names and implicit-invocation policy, not a publishing manifest.
- Do not add an upstream remote or sync from the original repository.
- Skills live at `skills/<skill-name>/SKILL.md`, flat with no bucket directories.
- Skill names are globally unique.
- When adding, renaming, or removing a skill, update the skill index in the top-level README.
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
