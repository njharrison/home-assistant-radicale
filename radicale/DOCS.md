# Radicale

This app runs a lightweight Radicale CalDAV/CardDAV server on Home Assistant OS.

## Setup

1. Set a username and password in the app configuration.
2. Start the app.
3. Open `http://HOME_ASSISTANT_IP:5232` on your local network.
4. Sign in with the username and password you configured.
5. Create a calendar/task collection in Radicale.

## Home Assistant

Add the **CalDAV** integration and point it at `http://HOME_ASSISTANT_IP:5232`.

Use the same Radicale username and password. VTODO collections can then be exposed by Home Assistant as to-do entities.

## Apple Reminders

On iPhone, go to **Settings → Apps → Reminders → Reminders Accounts → Add Account → Other → Add CalDAV Account** and use your Home Assistant host/IP plus the Radicale credentials.

## Data

Radicale collections and authentication data are stored under the app's persistent `/data` directory.
