
# get_url_host removes the protocol, path and ports from a URI and returns the result
get_url_host ()
{
    # url="$1"

    protocol=$(echo "$1" | grep "://" | sed -e's,^\(.*://\).*,\1,g')
    # Remove the protocol
    url_no_protocol=$(echo "${1/$protocol/}")
    # Use tr: Make the protocol lower-case for easy string compare
    protocol=$(echo "$protocol" | tr '[:upper:]' '[:lower:]')

    # Extract the user and password (if any)
    # cut 1: Remove the path part to prevent @ in the querystring from breaking the next cut
    # rev: Reverse string so cut -f1 takes the (reversed) rightmost field, and -f2- is what we want
    # cut 2: Remove the host:port
    # rev: Undo the first rev above 
    userpass=$(echo "$url_no_protocol" | grep "@" | cut -d"/" -f1 | rev | cut -d"@" -f2- | rev)
    # pass=$(echo "$userpass" | grep ":" | cut -d":" -f2)
    # if [ -n "$pass" ]; then
    #     user=$(echo "$userpass" | grep ":" | cut -d":" -f1)
    # else
    #     user="$userpass"
    # fi

    # Extract the host
    hostport=$(echo "${url_no_protocol/$userpass@/}" | cut -d"/" -f1)
    host=$(echo "$hostport" | cut -d":" -f1)
    # port=$(echo "$hostport" | grep ":" | cut -d":" -f2)
    # path=$(echo "$url_no_protocol" | grep "/" | cut -d"/" -f2-)

    # Print the URL host string
    print "$host"
}

# onion_link_in_file returns 1 if the provided onion 
# address is not found in the provided file path.
onion_link_in_file ()
{
    local onion="${1}"
    local file="${2}"

    grep -G "${onion}" < "${file}"
}

# onion_is_blacklisted returns 0 if the provided onion
# is found in one of our lists of links to avoid, and
# logs a corresponding message to the user.
onion_is_blacklisted ()
{
    local onion="${1}"

    find "${RISQ_DIR}/avoid/"* -print0 | 
    while IFS= read -r -d '' file; do 
        grep -G "${onion}" < "$file" \
            && _warning "Onion found in blacklist ${file} file !" && return
    done

    # The link is not blacklisted in our files.
    return 1
}

# downloads the gpg.txt and mirrors.txt for a given onion link
get_onion_auth_files ()
{
    local onion="${1}"

    _info "Fetching GPG public keys, please wait..."
    _run torify wget "${host}/pgp.txt"
    [[ $? ]] || _warning "Failed to fetch onion/gpg.txt"

    _info "Fetching signature file and ensuring URL match..."
    _run torify wget "${host}/mirrors.txt"
    [[ $? ]] || _warning "Failed to fetch onion/mirrors.txt"
}

# check_onion_mirrors fails and exits the program if the
# onion target is not found in the website mirrors.txt.
check_onion_mirrors ()
{
    local onion="${1}"
    local tmp="${2}"

    [[ ! -e "${tmp}/mirrors.txt" ]] && return

    [[ ! $(onion_link_in_file "${onion}" "${tmp}/mirrors.txt") ]] \
        && _failure "Target onion not found in mirrors.txt file"

    _success "Onion found in mirrors.txt file"
}

# get_onion_tortaxi fetches tortaxi data for the onion if available.
get_onion_tortaxi ()
{
    local onion="${1}"

    [[ ! -e "${RISQ_DIR}/tortaxi_sitenames" ]] && return

    # - Grep a line with the name of the site
    grep "${onion}" < "${RISQ_DIR}/tortaxi_sitenames" \
        _info "No website data on Tor Taxi index"

    # - Get the last part of this line, containing the corresponding URL path
    # - Append path to tor.taxi onion
    # - Fetch the corresponding mirrors.txt file
    # - Grep everything between BEGIN_PGP_SIGNED_info and ENG_PGP_SIGNATURE
    # - Compare with the one we have fetched on the site itself.
}
