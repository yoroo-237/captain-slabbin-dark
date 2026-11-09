#!/bin/sh
# Surveillance a lancer depuis une AUTRE machine qui a Tor (proxy SOCKS sur 127.0.0.1:9050).
# Usage : ./monitor.sh monadresse.onion
# Cron  : */5 * * * * /chemin/monitor.sh monadresse.onion || echo "onion DOWN" | mail -s alerte vous@example.com
ONION="$1"
[ -z "$ONION" ] && { echo "usage: $0 adresse.onion"; exit 2; }

CODE=$(curl --socks5-hostname 127.0.0.1:9050 -s -o /dev/null -m 60 -w "%{http_code}" "http://$ONION/")
echo "$(date -u +%FT%TZ) $ONION -> HTTP $CODE"
case "$CODE" in
  2*|3*) exit 0 ;;
  *) exit 1 ;;
esac
