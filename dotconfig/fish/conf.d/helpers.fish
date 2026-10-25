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

function convert-currency --description "Convert currency via frankfurter.dev (ECB, CNB, blend)"
  if test (count $argv) -lt 2
    echo "Usage: fx <from> <to> [amount]" >&2
    return 1
  end
  set -l from (string upper -- $argv[1])
  set -l to (string upper -- $argv[2])
  set -l amount 1
  if test (count $argv) -ge 3
    set amount (string replace ',' '.' -- $argv[3])
    if not string match -qr '^-?[0-9]*\.?[0-9]+$' -- $amount
      echo "Invalid amount: $argv[3]" >&2
      return 1
    end
  end

  set_color cyan; echo "$amount $from -> $to"; set_color normal
  for provider in ECB CNB Blend
    set -l query "?providers=$provider"
    test $provider = Blend; and set query ''
    set -l response (curl -s "https://api.frankfurter.dev/v2/rate/$from/$to$query" | string collect)
    set -l rate (echo $response | jq -r '.rate // empty' 2>/dev/null)
    if test -z "$rate"
      set -l message (echo $response | jq -r '.message // empty' 2>/dev/null)
      if string match -q 'invalid currency*' -- $message
        set_color red; echo $message; set_color normal
        return 1
      end
      set_color brblack; printf '  %-6s n/a\n' $provider; set_color normal
      continue
    end
    set -l date (echo $response | jq -r '.date')
    set -l result (math --scale=2 "round($amount * $rate * 100) / 100")
    set_color green; printf "  %-6s %'12.2f %s" $provider $result $to
    set_color brblack; echo "  (1 $from = $rate $to, $date)"; set_color normal
  end
end

## Aliases ##
alias fx="convert-currency"
alias sudo="sudo-wrapper"
alias apt="apt-wrapper"
alias ssh="ssh-wrapper"

alias batrld="bat cache --build"
alias tmuxrld="tmux source $HOME/.config/tmux/tmux.conf"
alias chsync="$HOME/dotfiles/sync.sh sync-to"
alias chapply="$HOME/dotfiles/sync.sh sync-from"
