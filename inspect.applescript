tell application "System Events"
    tell process "Ivanti Secure Access"
        set outputText to ""
        set outlineElement to outline 1 of scroll area 1 of group 1 of window 1

        set outputText to outputText & "Rows: " & (count of rows of outlineElement) & linefeed

        repeat with r in rows of outlineElement
            set outputText to outputText & "ROW" & linefeed

            try
                repeat with c in UI elements of r
                    set outputText to outputText & "  " & (role of c as text)

                    try
                        set outputText to outputText & " | " & (name of c as text)
                    end try

                    try
                        set outputText to outputText & " | " & (description of c as text)
                    end try

                    set outputText to outputText & linefeed
                end repeat
            end try
        end repeat

        return outputText
    end tell
end tell

