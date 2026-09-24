# git commit with numbered shortcut expansion (e.g. `gc 2`).
# Shortcuts may refer to files from piscm_git_status_shortcuts.
function piscm_git_commit_shortcuts
    if not git rev-parse --show-toplevel >/dev/null 2>&1
        echo -s (set_color red) 'Not a git repository (or any of the parent directories)' (set_color normal)
        return 1
    end
    set -l args (piscm_expand_args $argv)
    git commit $args
    piscm_git_status_shortcuts
end