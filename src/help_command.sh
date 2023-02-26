## Help command [@bashly-upgrade help]
## This file is a part of Bashly standard library
##
## Add this as a command to your bashly.yml:
##
##   commands:
##     - name: help
##       help: Show help about a command
##       args:
##       - name: command
##         help: Help subject
##
command="${args['command']}"
long_usage=yes

if [[ -z "$command" ]]; then
  # No command argument, show the global help
  help_function=risq_usage
else
  # Show the help for the requested command
  help_function="risq_${command}_usage"
fi

# Call the help function if it exists
if [[ $(type "$help_function") ]]; then
  "$help_function"
else
  echo "No help available for this command"
  exit 1
fi
