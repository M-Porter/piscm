# Concise git status with numbered file shortcuts.
# Sets $e1, $e2, ... (PISCM_ENV_CHAR) to the absolute path of each listed file.
# Optional single group filter: 1|staged, 2|unmerged, 3|unstaged, 4|untracked.
function piscm_git_status_shortcuts
    if not git rev-parse --show-toplevel >/dev/null 2>&1
        echo -s (set_color red) 'Not a git repository (or any of the parent directories)' (set_color normal)
        return 1
    end
    set -l project_root (git rev-parse --show-toplevel 2>/dev/null)
    set -l porcelain (git status --porcelain -b 2>/dev/null)
    set -l changes $porcelain[2..-1]

    if test (count $changes) -gt $PISCM_MAX_CHANGES
        git status
        echo -s (set_color yellow) "There were more than $PISCM_MAX_CHANGES changed files. piscm has fallen back to standard git status for performance reasons." (set_color normal)
        return 1
    end

    __piscm_clear_vars
    set -e piscm_shortcuts 2>/dev/null

    # Branch name and ahead/behind counts.
    set -l branch (git symbolic-ref --short HEAD 2>/dev/null)
    if test -z "$branch"
        set branch HEAD
    end
    set -l ahead ''
    set -l behind ''
    set -l first $porcelain[1]
    if string match -q -r 'ahead ?\d+' -- "$first"
        set ahead (string replace -r '.*ahead ?(\d+).*' '$1' -- "$first")
    end
    if string match -q -r 'behind ?\d+' -- "$first"
        set behind (string replace -r '.*behind ?(\d+).*' '$1' -- "$first")
    end

    # Parse porcelain lines into display entries.
    set -l stat_files
    set -l stat_msgs
    set -l stat_cols
    set -l stat_sfiles
    set -l stat_grp
    for line in $changes
        set -l x (string sub -l 1 -- "$line")
        set -l y (string sub -s 2 -l 1 -- "$line")
        set -l path (string sub -s 4 -- "$line")

        # Renames/copies carry 'old -> new'; shortcuts point at the new path.
        set -l is_rename 0
        if string match -q -r '[RC]' -- "$x"; or string match -q -r '[RC]' -- "$y"
            set is_rename 1
        end
        set -l new_path $path
        if test $is_rename -eq 1
            set -l m (string replace -r '^.* -> ("(?:[^"\\\\]|\\\\.)*"|[^"]*)$' '$1' -- "$path")
            if test "$m" != "$path"
                set new_path $m
            end
        end
        set -l sfile (__piscm_unquote "$new_path")

        # Index (staged / unmerged) states.
        set -l msg ''; set -l col ''; set -l group ''
        switch "$x$y"
            case 'DD'; set msg '   both deleted'; set col red; set group unmerged
            case 'AU'; set msg '    added by us'; set col yellow; set group unmerged
            case 'UD'; set msg 'deleted by them'; set col red; set group unmerged
            case 'UA'; set msg '  added by them'; set col yellow; set group unmerged
            case 'DU'; set msg '  deleted by us'; set col red; set group unmerged
            case 'AA'; set msg '     both added'; set col yellow; set group unmerged
            case 'UU'; set msg '  both modified'; set col green; set group unmerged
            case '*'
                switch "$x"
                    case 'M'; set msg '  modified'; set col green; set group staged
                    case 'A'; set msg '  new file'; set col yellow; set group staged
                    case 'D'; set msg '   deleted'; set col red; set group staged
                    case 'R'; set msg '   renamed'; set col blue; set group staged
                    case 'C'; set msg '    copied'; set col yellow; set group staged
                    case 'T'; set msg 'typechange'; set col magenta; set group staged
                    case '?'
                        if test "$x$y" = '??'
                            set msg ' untracked'; set col cyan; set group untracked
                        end
                end
        end
        if test -n "$msg"
            if test $is_rename -eq 1
                set -a stat_files "$path"
            else
                set -a stat_files "$new_path"
            end
            set -a stat_msgs "$msg"
            set -a stat_cols "$col"
            set -a stat_sfiles "$sfile"
            set -a stat_grp "$group"
        end

        # Work tree (unstaged) states.
        set -l msg ''; set -l col ''
        if test $is_rename -eq 1; and test "$y" = 'M'
            set msg '  modified'; set col green
        else if test "$x" != 'R'; and test "$y" = 'M'
            set msg '  modified'; set col green
        else if test "$y" = 'D'; and test "$x" != 'D'; and test "$x" != 'U'
            set msg '   deleted'; set col red
        else if test "$y" = 'T'
            set msg 'typechange'; set col magenta
        end
        if test -n "$msg"
            set -a stat_files "$new_path"
            set -a stat_msgs "$msg"
            set -a stat_cols "$col"
            set -a stat_sfiles "$sfile"
            set -a stat_grp unstaged
        end
    end

    # Header
    echo -n -s (set_color white --dim)'#'(set_color normal)' On branch: '(set_color --bold)"$branch"(set_color normal)
    if test -n "$ahead"; or test -n "$behind"
        set -l parts ''
        if test -n "$ahead"; set parts "+$ahead"; end
        if test -n "$behind"
            if test -n "$parts"; set parts "$parts/-$behind"; else; set parts "-$behind"; end
        end
        echo -n -s (set_color white --dim)'  |  '(set_color normal)(set_color yellow)"$parts"(set_color normal)
    end
    if test (count $changes) -eq 0
        echo -n -s (set_color white --dim)'  |  '(set_color normal)(set_color green)'No changes (working directory clean)'(set_color normal)
        echo
        return 0
    end
    echo -n -s (set_color white --dim)'  |  ['(set_color normal)'*'(set_color white --dim)'] => $'$PISCM_ENV_CHAR'*'(set_color normal)
    echo
    echo -s (set_color white --dim)'#'

    # Groups
    set -l group_names staged unmerged unstaged untracked
    set -l headings 'Changes to be committed' 'Unmerged paths' 'Changes not staged for commit' 'Untracked files'
    set -l group_colors yellow red green cyan
    set -l filter $argv[1]
    set -l n 0
    for g in 1 2 3 4
        set -l name $group_names[$g]
        if test -n "$filter"; and test "$filter" != "$g"; and test "$filter" != "$name"
            continue
        end
        set -l c_grp (set_color $group_colors[$g])
        set -l has 0
        for i in (seq 1 (count $stat_files))
            if test "$stat_grp[$i]" = "$name"
                set has 1
                break
            end
        end
        if test $has -eq 1
            echo -s (set_color --bold $group_colors[$g])'➤'(set_color normal)' '$headings[$g]
            echo -s $c_grp'#'(set_color normal)
            for i in (seq 1 (count $stat_files))
                if test "$stat_grp[$i]" = "$name"
                    set n (math $n + 1)
                    set -l pad ''
                    if test $n -lt 10; and test (count $changes) -ge 10
                        set pad ' '
                    end
                    set -l rel (__piscm_relative (pwd -P) "$project_root/$stat_files[$i]")
                    echo -s $c_grp'#'(set_color normal)'     '(set_color normal)(set_color $stat_cols[$i])"$stat_msgs[$i]: "(set_color white --dim)'['(set_color normal)"$n"(set_color white --dim)']'$pad' '(set_color normal)$c_grp"$rel"(set_color normal)
                    set -gx $PISCM_ENV_CHAR$n "$project_root/$stat_sfiles[$i]"
                    set -g piscm_shortcuts[$n] "$project_root/$stat_sfiles[$i]"
                end
            end
            echo -s $c_grp'#'(set_color normal)
        end
    end
end
