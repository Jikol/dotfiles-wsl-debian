## Functions ##
function cld-wrapper
  if contains -- "$argv[1]" c commit
    claude-commit
  else
    command claude $argv
  end
end

function claude-commit
  command claude -p "Create new commit for staged files with appropriate message." \
    --allowed-tools "Bash" \
    --model claude-haiku-4-5-20251001 \
    --dangerously-skip-permissions
end


## Aliases ##
alias cld="cld-wrapper"
alias zadek="echo prdel"
