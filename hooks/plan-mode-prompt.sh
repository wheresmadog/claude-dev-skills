#!/usr/bin/env bash
# UserPromptExpansion hook for gh-issue-implement and update-claude-md.
# Both skills plan-and-execute in one pass; this forces real Plan Mode first.
set -uo pipefail

if ! command -v jq >/dev/null 2>&1; then
  echo "plan-mode-prompt hook: jq not found, skipping" >&2
  exit 1
fi

input=$(cat)
mode=$(echo "$input" | jq -r '.permission_mode // empty')

if [ "$mode" = "plan" ]; then
  exit 0
fi

context="Before running any part of this skill, call the EnterPlanMode tool. Do not use exploration, GitHub, or file-editing tools until plan mode is active and the plan is approved."

jq -n --arg ctx "$context" '{hookSpecificOutput: {hookEventName: "UserPromptExpansion", additionalContext: $ctx}}'
