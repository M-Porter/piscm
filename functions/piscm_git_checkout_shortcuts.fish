# git checkout with numbered shortcut expansion (e.g. `gco 2`).
# Shortcuts may refer to files from piscm_git_status_shortcuts or branches from piscm_git_branch_shortcuts.
function piscm_git_checkout_shortcuts
    if not git rev-parse --show-toplevel >/dev/null 2>&1
        echo -s (set_color red) 'Not a git repository (or any of the parent directories)' (set_color normal)
        return 1
    end
    set -l args (piscm_expand_args $argv)
    if test (count $args) -eq 0
        git checkout
        return $status
    end
    git checkout $args
end
