# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

macOS AppleScript automation for connecting to Ivanti Secure Access VPN. Scripts use UI automation via `System Events` to interact with the Ivanti client.

## Running

```bash
osascript auto-connect.applescript <TOTP_CODE>
```

## Architecture

- **auto-connect.applescript** — Full connection flow: checks status, clicks Connect, waits for TOTP dialog, fills code, verifies connection, dismisses upgrade dialog

## Key Details

- All scripts target process `"Ivanti Secure Access"` via System Events
- TOTP auth window is `window "TrueID-Web"`, auth controls are in `sheet 1`
- Token field identified by `description is "secure text field"`
- Requires macOS Accessibility permissions for the calling app (Terminal, iTerm, etc.)
