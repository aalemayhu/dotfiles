#!/usr/bin/env bash
input=$(cat)
dir=$(echo "$input" | jq -r '.cwd // .workspace.current_dir // empty')
if [ -n "$dir" ]; then
  case "$dir" in "$HOME"*) dir="~${dir#"$HOME"}" ;; esac
  echo "$dir"
fi
