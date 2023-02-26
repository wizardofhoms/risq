
local onion host tmp

# The onion argument has been validated as an onion V3 link already,
# but we still need the host string without any URL path component.
onion="${args['onion']}"
host="$(get_url_host "$onion")"

_info "Verifying Onion link"

# 0 - Pre-run tasks
# Fist locate ourselves in a temp directory in which to download stuff
tmp="$(mktemp -d -q --suffix risq)"
cd "$tmp" || _failure "Failed to cd into temp directory $tmp"

# Refresh blacklisted onions lists and root keys
[[ "${args['--refresh']}" -eq 1 ]] && risq_refresh_command

# 1 - If the onion is blacklisted
[[ $(onion_is_blacklisted "${onion}") ]] \
    && _failure "Link blacklisted, aborting before establishing any connection to it."

# Get onion files (GPG, mirrors, etc)
get_onion_auth_files "${onion}"

# Verify GPG signatures
# * Either ghlkgfjlf.onion/pgp.txt
# * Or specified with --key flag
# * Or we might already have a key in our keyring for this: either fallback to this or check if we have one.

# Check mirrors
check_onion_mirrors "${onion}" "${tmp}"

# 5 - Import the GPG public key in our vault keyring 
_info "Importing GPG public key in keyring"

# 6 - Check the signature file against the newly imported key. 
_info "Verifying signatures match"
# qubes-gpg-import-key

# Clean up tmp dir
cd && _run shred -u "$tmp"

# 7 - At this point, in all likelihood our site is legit
_success "Onion URL verified against GPG key"
