# Return 0 when inside a git repository, otherwise print an error and return 1.
# Usage: __piscm_require_repo; or return 1
function __piscm_require_repo
    if not git rev-parse --show-toplevel >/dev/null 2>&1
        echo -s (set_color red) 'Not a git repository (or any of the parent directories)' (set_color normal)
        return 1
    end
end
