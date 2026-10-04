# Radicale

Radicale CalDAV/CardDAV for Home Assistant OS.

## HTTPS setup

Version 0.2.0 generates a persistent private local CA and an HTTPS certificate for the configured `certificate_ip`.

1. Set `certificate_ip` to the Home Assistant machine's fixed/reserved LAN IPv4 address.
2. Start the app.
3. On an iPhone/iPad, open `http://HOME_ASSISTANT_IP:5233/radicale-local-ca.crt` in Safari.
4. Install the downloaded profile in Settings.
5. Go to **Settings → General → About → Certificate Trust Settings** and enable full trust for **Home Assistant Radicale Local CA**.
6. Radicale is then available at `https://HOME_ASSISTANT_IP:5232`.

Port 5233 serves only the public CA certificate. The CA private key remains in the app's persistent `/data` directory.

## Apple Reminders

Add a CalDAV account using the Home Assistant LAN IP, the configured Radicale username/password, SSL enabled, and port 5232.

## Data

Collections, authentication data and TLS material are stored persistently under `/data`.
