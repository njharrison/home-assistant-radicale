# Radicale for Home Assistant

A small Home Assistant app that runs Radicale, providing local CalDAV/CardDAV storage for calendars, contacts and VTODO task lists.

The initial use case is sharing a task list between Home Assistant and clients such as Apple Reminders.

## Install

Add this repository to the Home Assistant app store:

https://github.com/njharrison/home-assistant-radicale

Then install **Radicale**, set a username and password, and start it.

Radicale listens on TCP port **5232**.

## Supported architectures

- aarch64
- amd64

## Storage

Collections are stored in the app's persistent `/data` directory.

## Source

This is an independent community app and is not affiliated with the Radicale or Home Assistant projects.
