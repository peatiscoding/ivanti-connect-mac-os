tell application "System Events"
    tell process "Ivanti Secure Access"
        set connectButton to first button of row 1 of outline 1 of scroll area 1 of group 1 of window 1 whose name is "Connect"
        click connectButton
    end tell
end tell

