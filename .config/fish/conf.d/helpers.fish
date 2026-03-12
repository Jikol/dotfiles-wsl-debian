## Functions ##
function sudo-wrapper
	if contains -- "$argv[1]" apt
		command sudo nala $argv[2..-1]
	else
		command sudo $argv
	end
end

function apt-wrapper
	command nala $argv
end

function ssh-wrapper
  if test (count $argv) -ge 1
    if contains -- "$argv[1]" ls list
      set configPath "/mnt/c/Users/Jikol/.ssh/config"
      if test -f $configPath
        grep -E '^\s*(Host|HostName)\s+' $configPath | 
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

alias batrld="batcat cache --build"
alias tmuxrld="tmux source $HOME/.config/tmux/tmux.conf"
