on run argv
    if (count of argv) is not 1 then
        error "Usage: osascript connect-ivanti.applescript TOTP_CODE"
    end if

    set totpCode to item 1 of argv

    tell application "System Events"
        tell process "Ivanti Secure Access"
            set authSheet to sheet 1 of window "TrueID-Web"

            set tokenField to first text field of authSheet whose description is "secure text field"
            set connectButton to first button of authSheet whose name is "Connect"

            set value of tokenField to totpCode
            click connectButton
        end tell
    end tell
end run
