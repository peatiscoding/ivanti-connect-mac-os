# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

macOS AppleScript automation for connecting to Ivanti Secure Access VPN. Scripts use UI automation via `System Events` to interact with the Ivanti client.

## Running Scripts

```bash
# Click the Connect button in main Ivanti window
osascript connect.applescript

# Fill TOTP code and click Connect in auth dialog
osascript fill-totp.applescript <TOTP_CODE>

# Inspect UI elements (for debugging element hierarchy)
osascript inspect.applescript          # main window
osascript inspect-totp.applescript     # TrueID-Web auth sheet
```

## Architecture

- **connect.applescript** — Clicks "Connect" button in main Ivanti window (outline > row 1 > button)
- **fill-totp.applescript** — Takes TOTP code as CLI arg, fills secure text field in `TrueID-Web` sheet, clicks Connect
- **inspect.applescript** — Dumps UI element hierarchy of main window (roles, names, descriptions)
- **inspect-totp.applescript** — Dumps UI elements inside `TrueID-Web` auth sheet

## Key Details

- All scripts target process `"Ivanti Secure Access"` via System Events
- TOTP auth window is `window "TrueID-Web"`, auth controls are in `sheet 1`
- Token field identified by `description is "secure text field"`
- Requires macOS Accessibility permissions for the calling app (Terminal, iTerm, etc.)
