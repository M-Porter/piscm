# piscm version
set -gx PISCM_VERSION "1.0.0"

# Git shortcut settings
# Prefix character for shortcut variables, so shortcuts are stored as $e1, $e2, etc.
set -gq PISCM_ENV_CHAR; or set -gx PISCM_ENV_CHAR e
# Maximum number of changed files before falling back to plain git status for performance
set -gq PISCM_MAX_CHANGES; or set -gx PISCM_MAX_CHANGES 150
# When yes, deleted files are staged with git rm instead of git add
set -gq PISCM_AUTO_REMOVE; or set -gx PISCM_AUTO_REMOVE yes

# Set PISCM_AUTO_ALIAS to "off" to skip defining the shortcut aliases below.
if test "$PISCM_AUTO_ALIAS" != "off"
    alias gs piscm_git_status_shortcuts
    alias gb piscm_git_branch_shortcuts
    alias ga piscm_git_add_shortcuts
    alias gco piscm_git_checkout_shortcuts
    alias gc piscm_git_commit_shortcuts
end
