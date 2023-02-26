
# Connected terminal
typeset -H _TTY
GPG_TTY=$(tty)  # Needed for GPG operations
export GPG_TTY

# Remove verbose errors when * don't yield any match in ZSH
setopt +o nomatch

# The generated script makes use of BASH_REMATCH, set compat for ZSH
setopt BASH_REMATCH

# Use colors unless told not to
{ ! option_is_set --no-color } && { autoload -Uz colors && colors }

## Checks ##

# Don't run as root
if [[ $EUID -eq 0 ]]; then
    echo "This script must be run as user"
    exit 2
fi

# Configuration file -------------------------------------------------------------------------------
#
# Directory where risk stores its state
typeset -rg RISQ_DIR="${HOME}/.risq"  

# Create the risk directory if needed
[[ -e $RISQ_DIR ]] || { mkdir -p $RISQ_DIR && _info "Creating RISKS directory in $RISQ_DIR" }

# Write the default configuration if it does not exist.
config_init

# Default filesystem settings from configuration file ----------------------------------------------

typeset -gr HUSH_DIR="$(config_get HUSH_DIR)"
typeset -gr GRAVEYARD="$(config_get GRAVEYARD)"
typeset -gH PASS_TIMEOUT="$(config_get PASS_TIMEOUT)"

# Other constants ----------------------------------------------------------------------------------

typeset -gr TOR_TAXI_ONION="$(config_get TOR_TAXI_ONION)"
typeset -gr DARKNET_LIVE_ONION="$(config_get DARKNET_LIVE_ONION)"
