## Functions ##
function list-path --description "List all PATH entries"
	echo (set_color cyan) "Path Variables" (set_color normal)
	set -f path $PATH
	for path in (string split ":" $path)
    if test -n "$path"
      echo $path
    else
    	echo "$path (!not exists)"
    end
  end
end

## Aliases ##
alias envpath="list-path"