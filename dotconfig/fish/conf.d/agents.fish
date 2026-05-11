## Functions ##
function cld-wrapper --description "Claude CLI wrapper with commit shortcut"
  if contains -- "$argv[1]" c commit
    claude-commit
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


## Aliases ##
alias cld="cld-wrapper"
