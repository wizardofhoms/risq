
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
