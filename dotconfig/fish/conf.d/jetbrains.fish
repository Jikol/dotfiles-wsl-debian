## Functions ##
function _jb_open --description "JetBrains IDE launcher — bash subshell s cd /mnt/c, nezávislé na Toolbox scriptu"
  set -l cmd $argv[1]
  set -l args
  for arg in $argv[2..]
    if test -e $arg
      set args $args (wslpath -w (realpath $arg))
    else
      set args $args $arg
    end
  end
  bash -c 'cd /mnt/c && "$0" "$@"' $cmd $args
end

function _jb_kill_js_service --description "Kill lingering WebStorm js-language-service.js processes (also runs every 5 min via cron, see ~/.config/cron/crontab.jobs)"
  bash "$HOME/.config/cron/scripts/jb_kill_js_service.sh"
end

## Aliases ##
alias ws="_jb_open webstorm"
alias pch="_jb_open pycharm"
