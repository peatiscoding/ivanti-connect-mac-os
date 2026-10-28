# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

macOS AppleScript automation for connecting to Ivanti Secure Access VPN. Scripts use UI automation via `System Events` to interact with the Ivanti client.

## Running

Local or over SSH:
```bash
./auto-connect.sh <TOTP_CODE>
```

Direct (local only, no daemon needed):
```bash
osascript auto-connect.applescript <TOTP_CODE>
```

## Architecture

- **main.go** — Go HTTP daemon (`127.0.0.1:7492`) that executes AppleScript in GUI session context. Endpoints: `/connect?totp=X`, `/health`
- **auto-connect.applescript** — Full connection flow: checks status, clicks Connect, waits for TOTP dialog, fills code, verifies connection, dismisses upgrade dialog
- **auto-connect.sh** — CLI wrapper that curls the daemon
- **com.user.ivanti-auto-connect.plist** — LaunchAgent to keep daemon running at login

## Key Details

- Daemon runs as LaunchAgent in GUI session — solves SSH window server access (-1728 errors)
- All scripts target process `"Ivanti Secure Access"` via System Events
- TOTP auth window is `window "TrueID-Web"`, auth controls are in `sheet 1`
- Token field identified by `description is "secure text field"`
- Requires macOS Accessibility permissions for the calling app (Terminal, iTerm, etc.)
- Daemon listens on localhost only — no external access
