## Functions ##
function sudo-wrapper --description "sudo with nala and editor HOME fix"
  if contains -- "$argv[1]" apt
    command sudo nala $argv[2..-1]
  else if test -f /home/linuxbrew/.linuxbrew/bin/$argv[1]; or string match -q '/home/linuxbrew/*' (readlink -f (command -v $argv[1]) 2>/dev/null)
    command sudo HOME=$HOME env "PATH=/home/linuxbrew/.linuxbrew/bin:$PATH" "$argv[1]" $argv[2..-1]
  else
    command sudo $argv
  end
end

function apt-wrapper --description "apt using nala"
	command nala $argv
end

function ssh-wrapper --description "SSH with host listing support"
  if test (count $argv) -ge 1
    if contains -- "$argv[1]" ls list
      if test -n "$USERPROFILE"
        set winHome (wslpath "$USERPROFILE" 2>/dev/null)
      else
        set winUser (cmd.exe /c "echo %USERNAME%" 2>/dev/null | string trim)
        set winHome "/mnt/c/Users/$winUser"
      end
      set configPath "$winHome/.ssh/config"
      if test -f $configPath
        grep -E '^\s*(Host|HostName|User)\s+' $configPath |
        while read -l line
          echo $line
        end
      else
        echo "No SSH config file found at $configPath"
      end
    else
      command ssh.exe $argv
    end
  end
end

## Aliases ##
alias sudo="sudo-wrapper"
alias apt="apt-wrapper"
alias ssh="ssh-wrapper"

alias batrld="bat cache --build"
alias tmuxrld="tmux source $HOME/.config/tmux/tmux.conf"
alias chsync="$HOME/dotfiles/sync.sh sync-to"
alias chapply="$HOME/dotfiles/sync.sh sync-from"
