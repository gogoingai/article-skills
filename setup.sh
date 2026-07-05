#!/usr/bin/env bash
# Registers every skill in this repo (top-level dir with a SKILL.md) into
# the Claude Code skills directories via symlinks.
# Idempotent: symlinks already pointing at this repo are left alone;
# anything else in the way is reported, not clobbered.
#
# Usage:
#   ./setup.sh          register every skill in this repo
#   ./setup.sh <name>   register only the named skill

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENTS_SKILLS="$HOME/.agents/skills"
CLAUDE_SKILLS="$HOME/.claude/skills"

mkdir -p "$AGENTS_SKILLS" "$CLAUDE_SKILLS"

link_skill() {
  local name="$1"
  local src="$REPO_ROOT/$name"
  local agents_link="$AGENTS_SKILLS/$name"
  local claude_link="$CLAUDE_SKILLS/$name"

  if [ ! -f "$src/SKILL.md" ]; then
    echo "skip $name: no SKILL.md"
    return
  fi

  # ~/.agents/skills/<name> -> actual dir in this repo
  if [ -L "$agents_link" ] && [ "$(readlink "$agents_link")" = "$src" ]; then
    echo "ok   $name (.agents already linked)"
  elif [ -e "$agents_link" ]; then
    echo "warn $agents_link exists and is not a symlink to this repo, skipping (handle manually)"
    return
  else
    ln -s "$src" "$agents_link"
    echo "new  $agents_link -> $src"
  fi

  # ~/.claude/skills/<name> -> ../../.agents/skills/<name> (matches existing convention)
  if [ -L "$claude_link" ] && [ "$(readlink "$claude_link")" = "../../.agents/skills/$name" ]; then
    echo "ok   $name (.claude already linked)"
  elif [ -e "$claude_link" ]; then
    echo "warn $claude_link exists and is not a symlink to .agents/skills, skipping (handle manually)"
  else
    ln -s "../../.agents/skills/$name" "$claude_link"
    echo "new  $claude_link -> ../../.agents/skills/$name"
  fi
}

if [ $# -ge 1 ]; then
  link_skill "$1"
else
  for dir in "$REPO_ROOT"/*/; do
    name="$(basename "$dir")"
    [ -f "$dir/SKILL.md" ] && link_skill "$name"
  done
fi

echo
echo "Done. Skills in this repo:"
for dir in "$REPO_ROOT"/*/; do
  name="$(basename "$dir")"
  [ -f "$dir/SKILL.md" ] && echo "  - $name"
done
