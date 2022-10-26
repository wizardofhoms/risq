
local onion host tmp

# The onion argument has been validated as an onion V3 link already,
# but we still need the host string without any URL path component.
onion="${args[onion]}"
host="$(get_url_host "$onion")"

_message "Verifying Onion link"

# Fist locate ourselves in a temp directory in which to download stuff
tmp="$(mktemp -d -q --suffix risq)"
cd "$tmp" || _failure "Failed to cd into temp directory $tmp"

# 1 - Get the GPG public key associated to this onion. =================================================
# * Either ghlkgfjlf.onion/pgp.txt
# * Or fetched from another site
# * Or specified with --key flag
# * Or we might already have a key in our keyring for this: either fallback to this or check if we have one.
_message "Fetching GPG public keys"

# If we need to fetch the GPG key on the site itself
_run torify wget "${host}/pgp.txt"

# 2 - Get the signature file for this onion (generally mirrors.txt) =================================================
# In this signature file we must:
# - Find all onion links.
# - Find that one of those links matches the link we passed as argument.
_message "Fetching signature file and ensuring URL match"
_run torify wget "${host}/mirrors.txt"

# 3 - Import the GPG public key in our vault keyring =================================================
_message "Importing GPG public key in keyring"

# 4 - Check the signature file against the newly imported key. =================================================
_message "Verifying signatures match"

# 5 - At this point, in all likelihood our site is legit
_success "Onion URL verified against GPG key"
