#!/usr/bin/with-contenv bashio
set -e

U="$(bashio::config 'username')"
P="$(bashio::config 'password')"
DOMAIN="$(bashio::config 'domain')"
DUCKDNS_TOKEN="$(bashio::config 'duckdns_token')"

[ -n "$P" ] || { bashio::log.fatal "Set a Radicale password before starting."; exit 1; }
[ -n "$DOMAIN" ] || { bashio::log.fatal "Set the DuckDNS domain before starting."; exit 1; }
[ -n "$DUCKDNS_TOKEN" ] || { bashio::log.fatal "Set the DuckDNS token before starting."; exit 1; }

mkdir -p /data/collections /data/config /data/acme /data/tls
htpasswd -Bbc /data/users "$U" "$P" >/dev/null 2>&1

if [ ! -x /data/acme/acme.sh ]; then
  cp -a /root/.acme.sh/. /data/acme/
fi

export DuckDNS_Token="$DUCKDNS_TOKEN"
ACME=/data/acme/acme.sh

# 0.3.0 accidentally registered acme.sh with radicale@localhost. Remove only
# that stale account state; collections and Radicale data are untouched.
if grep -Rqs 'radicale@localhost' /data/acme 2>/dev/null; then
  bashio::log.info "Removing stale ACME account registration from v0.3.0"
  rm -rf /data/acme/ca/acme-v02.api.letsencrypt.org
fi

bashio::log.info "Checking Let's Encrypt certificate for $DOMAIN"
if [ ! -s /data/tls/fullchain.pem ] || ! openssl x509 -checkend 2592000 -noout -in /data/tls/fullchain.pem >/dev/null 2>&1; then
  "$ACME" --home /data/acme --server letsencrypt --issue --dns dns_duckdns -d "$DOMAIN" --keylength ec-256
  "$ACME" --home /data/acme --install-cert -d "$DOMAIN" --ecc \
    --key-file /data/tls/privkey.pem \
    --fullchain-file /data/tls/fullchain.pem
else
  "$ACME" --home /data/acme --server letsencrypt --renew -d "$DOMAIN" --ecc || true
  "$ACME" --home /data/acme --install-cert -d "$DOMAIN" --ecc \
    --key-file /data/tls/privkey.pem \
    --fullchain-file /data/tls/fullchain.pem
fi

cat > /data/config/radicale.conf <<EOF
[server]
hosts = 0.0.0.0:5232
ssl = True
certificate = /data/tls/fullchain.pem
key = /data/tls/privkey.pem

[auth]
type = htpasswd
htpasswd_filename = /data/users
htpasswd_encryption = bcrypt

[storage]
filesystem_folder = /data/collections

[rights]
type = owner_only

[web]
type = internal
EOF

bashio::log.info "Starting Radicale for https://$DOMAIN"
exec python3 -m radicale --config /data/config/radicale.conf
