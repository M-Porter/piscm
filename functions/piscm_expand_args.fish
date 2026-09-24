# Expand numbered file/branch shortcuts (1, 2-7) into the values recorded by
# piscm_git_status_shortcuts / piscm_git_branch_shortcuts. Prints one argument per line.
function piscm_expand_args
    set -l prev ''
    for arg in $argv
        set -l skip 0
        if contains -- $prev -n -C -A -B --max-count --skip --depth
            set skip 1
        end
        if test $skip -eq 1
            echo "$arg"
        else if string match -q -r '^[0-9]+$' -- "$arg"
            if test -e "$arg"
                echo "$arg"
            else
                set -l n (math $arg + 0)
                if set -q piscm_shortcuts; and test (count $piscm_shortcuts) -ge $n
                    echo "$piscm_shortcuts[$n]"
                else
                    echo "piscm_expand_args: no shortcut $PISCM_ENV_CHAR$arg set" >&2
                end
            end
        else if string match -q -r '^[0-9]+-[0-9]+$' -- "$arg"
            set -l parts (string split - -- "$arg")
            set -l start (math $parts[1] + 0)
            set -l end (math $parts[2] + 0)
            for i in (seq $start $end)
                if set -q piscm_shortcuts; and test (count $piscm_shortcuts) -ge $i
                    echo "$piscm_shortcuts[$i]"
                end
            end
        else
            echo "$arg"
        end
        set prev $arg
    end
end
