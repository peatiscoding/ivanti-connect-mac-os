# Auto Connect to Ivanti

macOS AppleScript automation for connecting to Ivanti Secure Access VPN with TOTP authentication.

## Prerequisites

- macOS with Ivanti Secure Access Client installed
- Accessibility permissions granted to your terminal app (System Settings > Privacy & Security > Accessibility)

## Usage

### One-command connect

```bash
osascript auto-connect.applescript <TOTP_CODE>
```

This will:
1. Check current connection status
2. Click Connect if disconnected (skip if already connected)
3. Wait for the TOTP authentication dialog
4. Fill in the TOTP code and submit
5. Verify connection succeeded
6. Dismiss the upgrade dialog if it appears

Output messages:
- `Already connected.`
- `Connected successfully.`
- `Connection failed. TOTP may be expired or invalid.`
- `Error: TOTP dialog did not appear within 15 seconds.`
- `Timeout: still <status> after 30 seconds.`

### Configuration

Edit the `connectionName` property at the top of `auto-connect.applescript` to match your Ivanti connection profile name (default: `TrueID-Web`).

