#!/usr/bin/with-contenv bashio
set -e
U="$(bashio::config 'username')"
P="$(bashio::config 'password')"
IP="$(bashio::config 'certificate_ip')"
[ -n "$P" ] || { bashio::log.fatal "Set a password before starting."; exit 1; }
mkdir -p /data/collections /data/config /data/tls /data/public
htpasswd -Bbc /data/users "$U" "$P" >/dev/null 2>&1
CA=/data/tls/ca.crt
CAKEY=/data/tls/ca.key
CERT=/data/tls/server.crt
KEY=/data/tls/server.key
if [ ! -s "$CA" ]; then
  openssl req -x509 -newkey rsa:4096 -nodes -days 3650 -sha256 -keyout "$CAKEY" -out "$CA" -subj "/CN=Home Assistant Radicale Local CA" -addext "basicConstraints=critical,CA:TRUE" -addext "keyUsage=critical,keyCertSign,cRLSign"
fi
if [ ! -s "$CERT" ] || [ ! -f /data/tls/ip ] || [ "$(cat /data/tls/ip 2>/dev/null)" != "$IP" ]; then
  openssl req -newkey rsa:2048 -nodes -keyout "$KEY" -out /data/tls/server.csr -subj "/CN=$IP" -addext "subjectAltName=IP:$IP"
  printf 'subjectAltName=IP:%s\nbasicConstraints=critical,CA:FALSE\nkeyUsage=critical,digitalSignature,keyEncipherment\nextendedKeyUsage=serverAuth\n' "$IP" > /data/tls/ext
  openssl x509 -req -in /data/tls/server.csr -CA "$CA" -CAkey "$CAKEY" -CAcreateserial -out "$CERT" -days 825 -sha256 -extfile /data/tls/ext
  printf '%s' "$IP" > /data/tls/ip
fi
cp "$CA" /data/public/radicale-local-ca.crt
cat > /data/config/config <<EOF
[server]
hosts = 0.0.0.0:5232
ssl = True
certificate = $CERT
key = $KEY
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
(cd /data/public && python3 -m http.server 5233 --bind 0.0.0.0 >/dev/null 2>&1) &
bashio::log.info "HTTPS: https://$IP:5232"
bashio::log.info "CA: http://$IP:5233/radicale-local-ca.crt"
exec python3 -m radicale --config /data/config/config
