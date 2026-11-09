#!/bin/sh
set -e

if [ -z "$UPSTREAM_HOST" ]; then
  echo "ERREUR: la variable UPSTREAM_HOST est obligatoire (ex: monsite.com, sans https://)" >&2
  exit 1
fi

# Nettoie la valeur au cas ou l'utilisateur met https:// ou un / final
UPSTREAM_HOST=$(echo "$UPSTREAM_HOST" | sed -e 's#^https\?://##' -e 's#/.*$##')
export UPSTREAM_HOST

envsubst '${UPSTREAM_HOST}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf
nginx -t

# Le volume Railway est monte en root : on donne la main a Tor sur ce dossier.
mkdir -p /var/lib/tor/hs
chown -R debian-tor:debian-tor /var/lib/tor
chmod 700 /var/lib/tor/hs

nginx

# Affiche l'adresse onion quand Tor l'a generee (en arriere-plan).
(
  for i in $(seq 1 60); do
    if [ -s /var/lib/tor/hs/hostname ]; then
      echo "=== ADRESSE ONION : $(cat /var/lib/tor/hs/hostname) ==="
      break
    fi
    sleep 2
  done
) &

exec su -s /bin/sh debian-tor -c "tor -f /etc/tor/torrc"
