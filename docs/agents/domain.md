# Domain Docs

How the engineering skills should consume this repo's domain documentation.

## Before exploring, read these

- `GLOSSARY.md` at the repo root for the project's language.
- `docs/adr/` for decisions that touch the area you are about to work in.

If a file does not exist, proceed silently. The `domain-modeling` skill creates glossary entries and ADRs lazily when a term or decision is actually resolved.

## Use the glossary's vocabulary

When output names a domain concept, use the term as defined in `GLOSSARY.md`. Do not drift to synonyms the glossary explicitly avoids.

If the concept you need is not in the glossary yet, either you are inventing language the project does not use, or there is a real gap worth noting.

## Flag ADR conflicts

If your output contradicts an existing ADR, surface it explicitly rather than silently overriding it.
