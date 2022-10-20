
local command arguments
command="${args[command]}"
arguments=( "${args[arguments]}" )

case "${command}" in
    (show) pass_show_once "${arguments[@]}" ;;
    *) qvm-pass "${arguments[@]}" ;;
esac
