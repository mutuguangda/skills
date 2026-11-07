#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"
DEST="${1:-$HOME/.agents/skills}"

if [ -L "$DEST" ]; then
  resolved="$(readlink -f "$DEST")"
  case "$resolved" in
    "$REPO"|"$REPO"/*)
      echo "error: $DEST points into this repo ($resolved)" >&2
      exit 1
      ;;
  esac
fi

mkdir -p "$DEST"

duplicates="$(find "$REPO/skills" -mindepth 2 -maxdepth 2 -name SKILL.md -exec dirname {} \; | xargs -n1 basename | sort | uniq -d)"
if [ -n "$duplicates" ]; then
  echo "error: duplicate skill names: $duplicates" >&2
  exit 1
fi

for link in "$DEST"/*; do
  [ -L "$link" ] || continue
  target="$(readlink "$link")"
  case "$target" in
    "$REPO"/*)
      [ -e "$link" ] || rm "$link"
      ;;
  esac
done

while IFS= read -r -d '' skill_md; do
  src="$(dirname "$skill_md")"
  name="$(basename "$src")"
  target="$DEST/$name"

  if [ -e "$target" ] && [ ! -L "$target" ]; then
    rm -rf "$target"
  fi

  ln -sfn "$src" "$target"
  echo "linked $name -> $src"
done < <(find "$REPO/skills" -mindepth 2 -maxdepth 2 -name SKILL.md -print0)
