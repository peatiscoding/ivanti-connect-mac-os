-- auto-connect.applescript
-- Usage: osascript auto-connect.applescript <TOTP_CODE>
-- Orchestrates full Ivanti VPN connection: checks state, clicks Connect,
-- waits for TOTP dialog, fills code, and verifies connection success.

-- Connection profile name (change this to match your Ivanti connection)
property connectionName : "TrueID-Web"

on dismissUpgradeDialog()
	-- Wait briefly for upgrade dialog to appear, then cancel it
	delay 2
	try
		tell application "System Events"
			tell process "Ivanti Secure Access"
				click (first button of sheet 1 of window connectionName whose name is "Cancel")
			end tell
		end tell
	end try
end dismissUpgradeDialog

on getStatus()
	tell application "System Events"
		tell process "Ivanti Secure Access"
			set r to row 1 of outline 1 of scroll area 1 of group 1 of window "Ivanti Secure Access Client"
			set statusText to name of static text 1 of group 1 of r
			-- statusText is like "TrueID-Web\nConnected" or "TrueID-Web\nDisconnected"
			set AppleScript's text item delimiters to linefeed
			set parts to text items of statusText
			set AppleScript's text item delimiters to ""
			return last item of parts
		end tell
	end tell
end getStatus

on run argv
	if (count of argv) is not 1 then
		error "Usage: osascript auto-connect.applescript TOTP_CODE"
	end if
	set totpCode to item 1 of argv

	-- Step 1: Check current connection status
	set currentStatus to my getStatus()

	if currentStatus is "Connected" then
		my dismissUpgradeDialog()
		return "Already connected."
	end if

	if currentStatus is not "Disconnected" then
		return "Unexpected status: " & currentStatus & ". Please check Ivanti manually."
	end if

	-- Step 2: Click Connect button
	tell application "System Events"
		tell process "Ivanti Secure Access"
			set connectButton to first button of row 1 of outline 1 of scroll area 1 of group 1 of window "Ivanti Secure Access Client" whose name is "Connect"
			click connectButton
		end tell
	end tell

	-- Step 3: Wait for TOTP sheet to appear (up to 15 seconds)
	set sheetReady to false
	repeat 30 times
		try
			tell application "System Events"
				tell process "Ivanti Secure Access"
					set s to sheet 1 of window connectionName
					-- Verify the secure text field exists
					set tokenField to first text field of s whose description is "secure text field"
					set sheetReady to true
				end tell
			end tell
		end try
		if sheetReady then exit repeat
		delay 0.5
	end repeat

	if not sheetReady then
		return "Error: TOTP dialog did not appear within 15 seconds."
	end if

	-- Step 4: Fill TOTP and click Connect
	tell application "System Events"
		tell process "Ivanti Secure Access"
			set authSheet to sheet 1 of window connectionName
			set tokenField to first text field of authSheet whose description is "secure text field"
			set value of tokenField to totpCode
			click (first button of authSheet whose name is "Connect")
		end tell
	end tell

	-- Step 5: Wait for connection result (up to 30 seconds)
	-- Poll status: "Connecting" → "Connected" or back to "Disconnected" (failure)
	repeat 60 times
		delay 0.5
		set currentStatus to my getStatus()

		if currentStatus is "Connected" then
			-- Dismiss upgrade dialog if it appears
			my dismissUpgradeDialog()
			return "Connected successfully."
		end if

		if currentStatus is "Disconnected" then
			return "Connection failed. TOTP may be expired or invalid."
		end if

		-- "Connecting" or other transitional state — keep waiting
	end repeat

	return "Timeout: still " & currentStatus & " after 30 seconds."
end run
