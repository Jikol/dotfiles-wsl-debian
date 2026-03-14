## Confd ##
for f in $HOME/.config/fish/conf.d/*.fish
  if test -f $f
    source $f
  end
end

## Aliases ##
alias cls="printf "\033c""
alias csl="cls"
alias bat="batcat"
alias g="git"
alias gg="lazygit"
alias d="docker"
alias dd="lazydocker"
alias fetch="fastfetch"
alias ip="ip addr"
alias ws="webstorm"
alias pch="pycharm"
alias code="codium"
alias rst="rstudio.exe"

## Variables ##
set -g PROFILE "$HOME/.config/fish/config.fish"
set -g CONFIG_FISH "$HOME/.config/fish"
set -g CONFIG_NVIM "$HOME/.config/nvim"
set -g CONFIG_GIT "$HOME/.config/git/config"
set -g CONFIG_TMUX "$HOME/.config/tmux/tmux.conf"

## Themes ##
oh-my-posh init fish --config "$HOME/.config/omp/fluent.json" | source

## Initialialization ##
zoxide init fish | source
function reset_cursor --on-event fish_prompt
  echo -ne '\e[5 q'
end

