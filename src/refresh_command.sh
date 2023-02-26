
# Pre-run checks and tasks
[[ -e "${RISQ_DIR}/avoid" ]] || mkdir -p "${RISQ_DIR}/avoid"

# 1 - Blacklisted onion links
_info "Fetching lists of onions to avoid"
_info "- Tor Taxi..." && _run torify wget -O "${RISQ_DIR}/avoid/tortaxi" "${TOR_TAXI_ONION}/avoid" 


