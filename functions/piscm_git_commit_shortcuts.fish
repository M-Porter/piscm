# git commit with numbered shortcut expansion (e.g. `gc 2`).
# Shortcuts may refer to files from piscm_git_status_shortcuts.
function piscm_git_commit_shortcuts
    __piscm_require_repo; or return 1

    set -l args (piscm_expand_args $argv)
    git commit $args
    piscm_git_status_shortcuts
end
