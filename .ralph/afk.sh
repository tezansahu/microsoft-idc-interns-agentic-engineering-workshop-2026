#!/bin/bash
set -eo pipefail

if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: $0 <iterations> <prompt-file> [model]"
  exit 1
fi

iterations="$1"
prompt_file="$2"
model="${3:-claude-opus-4.8}"

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

# Resolve prompt file path relative to repo root if not absolute
case "$prompt_file" in
  /*) ;;
  *) prompt_file="$repo_root/$prompt_file" ;;
esac

model_args=()
[ -n "$model" ] && model_args=(--model "$model")

for ((i=1; i<=iterations; i++)); do
  echo ""
  echo "=== Iteration $i / $iterations ==="

  commits=$(git log -n 5 --format="%H%n%ad%n%B---" --date=short 2>/dev/null || echo "No commits found")
  [ -n "$commits" ] || commits="No commits found"

  prompt=$(cat "$prompt_file")

  full_prompt="Previous commits: $commits $prompt"

  output=$(copilot --prompt "$full_prompt" --allow-all-tools "${model_args[@]}" 2>&1 | tee /dev/tty)

  if [[ "$output" == *"<promise>NO MORE TASKS</promise>"* ]]; then
    echo ""
    echo "Ralph complete after $i iteration(s)."
    exit 0
  fi
done

echo ""
echo "Reached iteration limit ($iterations)."