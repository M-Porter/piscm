# git branch with numbered shortcuts.
# Sets $e1, $e2, ... (PISCM_ENV_CHAR) to branch names.
# Other args (e.g. -d, -m) pass through to git with shortcuts expanded.
function piscm_git_branch_shortcuts
    if not git rev-parse --show-toplevel >/dev/null 2>&1
        echo -s (set_color red) 'Not a git repository (or any of the parent directories)' (set_color normal)
        return 1
    end
    set -l is_all 0
    if test (count $argv) -eq 1; and test "$argv[1]" = '-a'
        set is_all 1
    end
    set -l local_count (git branch 2>/dev/null | count)
    if test "$local_count" -gt 300
        git branch (piscm_expand_args $argv)
        return $status
    end
    if test (count $argv) -gt 0; and test $is_all -eq 0
        git branch (piscm_expand_args $argv)
        return $status
    end

    set -l args ()
    if test $is_all -eq 1
        set args -a
    end
    set -l raw (git branch --color=always $args 2>/dev/null)

    __piscm_clear_vars
    set -e piscm_shortcuts 2>/dev/null

    set -l n 0
    set -l count (count $raw)
    for line in $raw
        set n (math $n + 1)
        set -l color normal
        if string match -q -r '\x1b\[32m' -- "$line"
            set color green --bold
        else if string match -q -r '\x1b\[31m' -- "$line"
            set color blue
        end
        set -l clean (string replace -ra '\x1b\[[0-9;]*m' '' -- "$line")
        set -l marker (string sub -l 2 -- "$clean")
        set -l name (string sub -s 3 -- "$clean")
        set -l pad ' '
        if test $n -lt 10; and test $count -gt 9
            set pad '  '
        end
        set -l name_color $color
        # if test "$color" = 'green'
        #     set name_color green --bold
        # end
        echo -n -s (set_color $color)"$marker"(set_color white --dim)'['(set_color normal)(set_color white)"$n"(set_color white --dim)']'$pad(set_color normal)(set_color $name_color)"$name"(set_color normal)
        echo
        set -gx $PISCM_ENV_CHAR$n "$name"
        set -g piscm_shortcuts[$n] "$name"
    end
end
