# git diff with numbered shortcut expansion (e.g. `gd 2`).
function piscm_git_diff_shortcuts
    __piscm_require_repo; or return 1

    git diff (piscm_expand_args $argv)
end
