#!/usr/bin/env bash
# Checks the outside services the page needs while it runs, which the link check
# cannot see because their addresses are built inside the page's script:
#   - one map picture per map from the map site (blank maps if it moved)
#   - the pinned squad-room script on unpkg
#   - the public chat broker that carries squad rooms
# Addresses and map names are read from index.html, so the check follows the page.
# Writes a short Markdown report to $1 (default: stdout). Exit 1 if anything fails.
set -uo pipefail

page="index.html"
report="${1:-/dev/stdout}"
failed=0
lines=()

check() { # name, url, expected status, actual status
  if [ "$4" = "$3" ]; then
    lines+=("- OK: $1 ($4)")
  else
    lines+=("- FAILED: $1 - got ${4:-no answer}, expected $3 - <$2>")
    failed=1
  fi
}

status() { # url, extra curl args...
  local url="$1"; shift
  curl -s -o /dev/null -m 20 --retry 2 --retry-delay 5 -w '%{http_code}' "$@" "$url" || true
}

# The broker keeps the connection open after agreeing (101), so curl stops at its
# time limit; no retries here, or a working broker would take a minute to pass.
ws_status() { # url
  curl -s -o /dev/null -m 10 -w '%{http_code}' --http1.1 \
    -H 'Connection: Upgrade' -H 'Upgrade: websocket' -H 'Sec-WebSocket-Version: 13' \
    -H 'Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==' -H 'Sec-WebSocket-Protocol: mqtt' "$1" || true
}

# Map names: the keys of the MAPS table, e.g. "  bakurani:  { name: ..."
maps=$(sed -n '/const MAPS = {/,/};/p' "$page" | sed -nE 's/^[[:space:]]+([a-z0-9_]+):[[:space:]]*\{.*/\1/p')
tile_tpl=$(sed -nE "s/.*const TILE_URL = .*\`([^\`]+)\`.*/\1/p" "$page")
broker=$(sed -nE "s/.*const BROKER = '([^']+)'.*/\1/p" "$page")
script=$(grep -oE 'https://unpkg\.com/[^"]+' "$page" | head -1)

if [ -z "$maps" ] || [ -z "$tile_tpl" ] || [ -z "$broker" ] || [ -z "$script" ]; then
  lines+=("- FAILED: could not read the map list, map address, broker or script address from $page (the page changed shape; update this check)")
  failed=1
else
  for m in $maps; do
    url=${tile_tpl//'${m}'/$m}
    url=${url//'${z}'/0}
    url=${url//'${x}'/0}
    url=${url//'${y}'/0}
    check "map picture for $m" "$url" 200 "$(status "$url")"
  done
  check "squad-room script" "$script" 200 "$(status "$script" -L)"
  # A real browser opens the broker as a WebSocket; 101 means it agreed to switch.
  https_broker="https://${broker#wss://}"
  check "squad-room broker" "$broker" 101 "$(status "$https_broker" --http1.1 \
    -H 'Connection: Upgrade' -H 'Upgrade: websocket' -H 'Sec-WebSocket-Version: 13' \
    -H 'Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==' -H 'Sec-WebSocket-Protocol: mqtt')"
fi

{
  if [ "$failed" = 0 ]; then
    echo "## Outside sources: all working"
  else
    echo "## Outside sources: something the page needs is down"
    echo
    echo "Blank maps mean the map site moved; squad rooms not joining means the broker or its script is down."
  fi
  echo
  printf '%s\n' "${lines[@]}"
} > "$report"

exit "$failed"
