
local command arguments
command="${args[command]}"
arguments=( "${other_args[*]}" )

case "${command}" in
    (show) pass_show_once "${arguments[@]}" ;;
    *) qvm-pass "$command" "${arguments[@]}" ;;
esac
