
tell application "System Events"
    tell process "Ivanti Secure Access"
        tell window "TrueID-Web"
            set outputText to "WINDOW: TrueID-Web" & linefeed

            repeat with s in sheets
                set outputText to outputText & "SHEET" & linefeed

                repeat with e in UI elements of s
                    set outputText to outputText & (role of e as text)

                    try
                        set outputText to outputText & " | name=" & (name of e as text)
                    end try

                    try
                        set outputText to outputText & " | description=" & (description of e as text)
                    end try

                    try
                        set outputText to outputText & " | value=" & (value of e as text)
                    end try

                    set outputText to outputText & linefeed
                end repeat
            end repeat

            return outputText
        end tell
    end tell
end tell
