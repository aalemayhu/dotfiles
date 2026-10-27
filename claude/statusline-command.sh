#!/usr/bin/env bash
input=$(cat)
dir=$(echo "$input" | jq -r '.cwd // .workspace.current_dir // empty')
if [ -n "$dir" ]; then
  echo "${dir/#\/Users\/a/~}"
fi
