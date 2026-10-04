#!/usr/bin/with-contenv bashio
set -e

USERNAME="$(bashio::config 'username')"
PASSWORD="$(bashio::config 'password')"

if [ -z "$PASSWORD" ]; then
  bashio::log.fatal "Set a password in the Radicale app configuration before starting."
  exit 1
fi

mkdir -p /data/collections /data/config

htpasswd -Bbc /data/users "$USERNAME" "$PASSWORD" >/dev/null 2>&1

cat > /data/config/config <<'EOF'
[server]
hosts = 0.0.0.0:5232

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

bashio::log.info "Starting Radicale on port 5232"
exec python3 -m radicale --config /data/config/config
