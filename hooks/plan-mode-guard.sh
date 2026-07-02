#!/usr/bin/env bash
# PreToolUse hook on the Skill tool. Denies an autonomous (non-slash-command)
# invocation of gh-issue-implement/update-claude-md until plan mode is active.
set -uo pipefail

if ! command -v jq >/dev/null 2>&1; then
  exit 0
fi

input=$(cat)
skill=$(echo "$input" | jq -r '.tool_input.skill // empty')
mode=$(echo "$input" | jq -r '.permission_mode // empty')

case "$skill" in
  gh-issue-implement|update-claude-md) ;;
  *) exit 0 ;;
esac

if [ "$mode" = "plan" ]; then
  exit 0
fi

jq -n --arg skill "$skill" '{hookSpecificOutput: {hookEventName: "PreToolUse", permissionDecision: "deny", permissionDecisionReason: ("Call EnterPlanMode before invoking " + $skill + ", then re-invoke this skill.")}}'
