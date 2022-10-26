
# validate_onion_v3 accepts a URL host location (without path)
# and check that it is a valid Onion V3 link.
validate_onion_v3 ()
{
    local host

    # First trim any path and protocol from the link
    host="$(get_url_host "$1")" 

    if [[ ! "$host" =~ ^[a-z2-7]{56}.onion ]] ; then
        echo "URL is not a valid Onion V3 link"
    fi
}
