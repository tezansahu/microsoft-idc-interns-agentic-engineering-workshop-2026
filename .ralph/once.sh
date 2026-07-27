#!/bin/bash
set -eo pipefail

if [ -z "$1" ]; then
  echo "Usage: $0 <prompt-file> [model]"
  exit 1
fi

prompt_file="$1"
model="${2:-claude-opus-4.8}"

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Resolve prompt file path relative to repo root if not absolute
case "$prompt_file" in
  /*) ;;
  *) prompt_file="$repo_root/$prompt_file" ;;
esac

commits=$(git -C "$repo_root" log -n 5 --format="%H%n%ad%n%B---" --date=short 2>/dev/null || echo "No commits found")
[ -n "$commits" ] || commits="No commits found"

prompt=$(cat "$prompt_file")

model_args=()
[ -n "$model" ] && model_args=(--model "$model")

cd "$repo_root"
copilot --prompt "Previous commits: $commits $prompt" --allow-all-tools "${model_args[@]}"