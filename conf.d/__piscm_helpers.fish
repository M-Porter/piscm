# Shared helpers for piscm git shortcut functions.
# Loaded at startup via fish/conf.d/.

# Clear numbered shortcut variables ($e1, $e2, ...) until the first unset one.
function __piscm_clear_vars
    for i in (seq 1 $PISCM_MAX_CHANGES)
        if not set -q $PISCM_ENV_CHAR$i
            break
        end
        set -e $PISCM_ENV_CHAR$i
    end
end

# Undo git's C-style quoting of porcelain paths (e.g. "a \"b" -> a "b).
function __piscm_unquote --argument-names path
    if not string match -q '"*"' -- "$path"
        echo "$path"
        return
    end
    set -l len (string length -- "$path")
    set -l inner (string sub -s 2 -l (math $len - 2) -- "$path")
    string replace -ra '\\\\(.)' '$1' -- "$inner"
end

# Return 0 (true) when the shortcut aliases and their completions are active,
# i.e. PISCM_AUTO_ALIAS is not explicitly set to "off".
function __piscm_auto_alias_active
    test "$PISCM_AUTO_ALIAS" != "off"
end

# Print $target as a path relative to $base (both absolute).
function __piscm_relative --argument-names base target
    set -l bp (string split / -- "$base")
    set -l tp (string split / -- "$target")
    set -l max (count $bp)
    if test (count $tp) -lt $max
        set max (count $tp)
    end
    set -l i 1
    while test $i -le $max; and test "$bp[$i]" = "$tp[$i]"
        set i (math $i + 1)
    end
    set -l common (math $i - 1)
    set -l ups ''
    set -l k (math (count $bp) - $common)
    while test $k -gt 0
        set ups "$ups../"
        set k (math $k - 1)
    end
    set -l start (math $common + 1)
    set -l rest (string join / -- $tp[$start..-1])
    if test -z "$rest"
        echo .
    else
        echo "$ups$rest"
    end
end
