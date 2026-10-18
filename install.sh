#!/usr/bin/env bash
# Installs the /fleet skill and its three subagents for your user, so they work
# in every repo. Re-run it after editing the files to update your copy.
set -euo pipefail
cd "$(dirname "$0")"

mkdir -p "$HOME/.claude/agents" "$HOME/.claude/skills/fleet"
cp agents/fleet-planner.md agents/fleet-verifier.md agents/fleet-reporter.md "$HOME/.claude/agents/"
cp skills/fleet/SKILL.md "$HOME/.claude/skills/fleet/SKILL.md"

echo "Installed to ~/.claude. Open Claude Code in a git repo and run: /fleet <your task>"
