# Radicale

Radicale CalDAV/CardDAV for Home Assistant OS with automatic publicly trusted HTTPS.

## Configuration

Set:

- `username`: the household CalDAV username.
- `password`: the household CalDAV password.
- `domain`: your DuckDNS hostname, for example `harrison-household.duckdns.org`.
- `duckdns_token`: your DuckDNS token.

The app uses DuckDNS DNS-01 validation to obtain and renew a Let's Encrypt certificate. No private CA or certificate profile is required on phones.

## Eero

Reserve the Home Assistant machine's LAN address, then create a TCP port forward:

- External port: 443
- Device: Home Assistant
- Internal port: 5232

Do not forward port 80 or Home Assistant's own port 8123 for this app.

## Apple Reminders

Add a CalDAV account on each iPhone using:

- Server: `harrison-household.duckdns.org`
- SSL: enabled
- Port: 443
- Username/password: the Radicale credentials

Both phones can use the same Radicale account and therefore the same task collections.

## Certificate renewal

Certificate state is stored under the app's persistent `/data` directory. On startup, the app checks the certificate and renews it through DuckDNS when it is within 30 days of expiry.

## Data

Radicale collections, authentication data, ACME state and TLS certificates are persistent under `/data`.
