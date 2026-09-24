# git add with numbered shortcut expansion (e.g. `ga 2 4 5-7`).
# With PISCM_AUTO_REMOVE=yes, deleted files are staged with git rm instead.
function piscm_git_add_shortcuts
    if not git rev-parse --show-toplevel >/dev/null 2>&1
        echo -s (set_color red) 'Not a git repository (or any of the parent directories)' (set_color normal)
        return 1
    end
    if test (count $argv) -eq 0
        echo 'Usage: ga <file>   => git add <file>'
        echo '       ga 1        => git add $e1'
        echo '       ga 2-4      => git add $e2 $e3 $e4'
        echo '       ga 2 5-7    => git add $e2 $e5 $e6 $e7'
        if test "$PISCM_AUTO_REMOVE" = 'yes'
            echo
            echo 'Note: Deleted files will also be staged using this shortcut.'
        end
        return 1
    end
    set -l args (piscm_expand_args $argv)
    for file in $args
        if test "$PISCM_AUTO_REMOVE" = 'yes'; and not test -e "$file"
            echo -s (set_color white --dim)'# '(set_color normal)'git rm ' "$file"
            git rm --quiet -- "$file"
        else
            git add -- "$file"
            echo -s (set_color white --dim)'# Added ' (set_color normal)"'$file'"
        end
    end
    piscm_git_status_shortcuts
end
