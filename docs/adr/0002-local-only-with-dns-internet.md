# ADR 0002: Local-only product with DNS-only INTERNET

## Status
Accepted

## Context
Privacy Lens must not send user data to a server. Tracker Shield still needs
to forward allowed DNS lookups, which requires the INTERNET permission.

## Decision
The app declares INTERNET only so the VPN service can talk to the device's
existing DNS resolver. There is no HTTP client, no analytics, and no crash
reporter. The Settings screen states this in plain language.

Crash reporting is omitted on purpose. Failures stay on the device and are
logged only in debug builds, without package names or domains.

## Consequences
The Play Store privacy form, if we ever ship there, must describe INTERNET
as DNS forwarding for an optional local filter. Sideloaded users see the
same explanation in Settings.
