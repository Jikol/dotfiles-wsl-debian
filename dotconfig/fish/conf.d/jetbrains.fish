## Functions ##
function _jb_open --description "JetBrains IDE launcher with WSL UNC working-dir fix"
  set _cmd $argv[1]
  set _args
  for arg in $argv[2..]
    if test -e $arg
      set _args $_args (wslpath -w (realpath $arg))
    else
      set _args $_args $arg
    end
  end
  set _prev $PWD
  builtin cd /mnt/c
  command $_cmd $_args
  builtin cd $_prev
end

## Aliases ##
alias ws="_jb_open webstorm"
alias pch="_jb_open pycharm"
