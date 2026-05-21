## Functions ##
function cld-wrapper --description "Claude CLI wrapper with commit shortcut"
  if contains -- "$argv[1]" c commit
    claude-commit
  else if contains -- "$argv[1]" f format
    claude-format
  else
    command claude $argv
  end
end

function claude-commit --description "Create commit for staged files using Claude"
  command claude -p "Create new commit for staged files with appropriate message." \
    --append-system-prompt (cat $CLAUDE_CONFIG_DIR/skills/git/SKILL.md | string collect) \
    --allowed-tools "Bash" \
    --model claude-haiku-4-5-20251001 \
    --dangerously-skip-permissions
end

function claude-format --description "Format and sort project config files using form skill"
  command claude -p "Apply form skill: format and sort all relevant config files found in the current project root." \
    --append-system-prompt (cat $CLAUDE_CONFIG_DIR/skills/form/SKILL.md | string collect) \
    --allowed-tools "Bash,Read,Edit" \
    --model claude-haiku-4-5-20251001 \
    --dangerously-skip-permissions
end



## Aliases ##
alias cld="cld-wrapper"
