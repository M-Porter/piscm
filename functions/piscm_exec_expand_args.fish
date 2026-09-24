# Run a command with numbered shortcuts expanded, e.g. `ge echo 1-3`.
function piscm_exec_expand_args
    set -l args (piscm_expand_args $argv)
    if test (count $args) -eq 0
        return 0
    end
    command $args
end
