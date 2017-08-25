#Include, %A_ScriptDir%\eclipseHelper.ahk
#Include, %A_ScriptDir%\helpers.ahk
#SingleInstance, force

/*
* Eclipse context specific hotkeys
*/
; ----------------------------------------------------------------------------
#ifWinActive ahk_class SWT_Window0
    ;; MAKE
    ^m::    ; Ctrl + m
        SendInput, Call MAKE('XX1B', '') From XX1S_QLF{Left 20}
    Return

    ;; REMOVE
    ^r::    ; Ctrl + Alt + r
        SendInput, Call REMOVE('XX1B', '') From XX1S_QLF{Left 20}
    Return

    ;; paste MAKEs as REMOVEs
    ^+r::   ; Ctrl + Shift + r
        StringCaseSense, On
        StringReplace, clipboard, clipboard, MAKE, REMOVE, All  ; replace MAKE with REMOVE
        ; StringReplace, Clipboard, Clipboard, #, `n, All
        StringCaseSense, Off

        storeClipboard(false)
        StringReplace, Clipboard, Clipboard, `r`n`r`n, `n, All                ; remove LF
        qlf = "QLF"
        StringReplace, Clipboard, Clipboard, XX1S_QLF, XX1S_QLF, UseErrorLevel
        counter = 0

        Loop, Parse, Clipboard, `n
        {
            inString := -1   ; variable reset
            ; TODO: incorporate the string "SITE=" for PJ make/remove
            inString := InStr(clipboard, "PROJECT=")    ; look for PROJECT=
            If (inString > 0)   ; if string is found
            {
                findSecondPlus := -1    ; variable reset
                ; find second occurrence of +, starting at where this line's PROJECT= was found + 2
                findSecondPlus := InStr(clipboard, "+",, inString, counter+2)
                If (findSecondPlus > 0) ; if a second + is found
                {
                    beginningString := SubStr(clipboard, 1, (findSecondPlus-1))   ; build the beginning of the string until the character before second +
                    findEnd := InStr(clipboard, ") From XX1S_QLF", true, findSecondPlus) ; find the end of the string -- returns position of )
                    endingString := SubStr(clipboard, findEnd) ; extract the end of the make call
                    clipboard = ; clear clipboard
                    clipboard := beginningString . endingString
                    counter += 1
                }
            }
        }

        ; paste the string
        SendInput, ^v
        Sleep, 10
        restoreClipboard(true)
    Return

    ::li::  ; auto-complete hotkey
        instance := getText()
        if (instance){
            SendInput, Call LOG_INSTANCE(%instance%) From XX1S_QLF
        }else{
            SendInput, Call LOG_INSTANCE() From XX1S_QLF{Left 15}
        }

    Return

    ; PAD SELECTED TEXT WITH CST_A
    ^,::    ; Ctrl + ,
        storeClipboard(true)
        SendInput, ^x   ; cut
        ClipWait, 1, 1

        StringUpper, clipboard, clipboard
        Sleep, 30
        clipboard = CST_A%clipboard%
        Sleep, 30
        SendInput, ^v
        Sleep, 10
        restoreClipboard(true)
    Return

    ;; add test stub
    ^t::    ; Ctrl + t
        SendInput, Call TEST('') From XX1S_QLF{Left 16}
    Return

    ;; add group description
    ^!/::   ; Ctrl + Alt + /
        Input, description,, {Enter},,
        StringLen, length, description
        length := length + 4
        Loop, %length%{
            SendRaw, #
        }
        SendInput, {Enter}{#}{Space}
        SendInput, %description%
        SendInput, {Space}{#}{Enter}
        Loop, %length%{
            SendRaw, #
        }
        SendInput, {Enter 3}
    Return

; ----------------------------------------------------------------------------
    ;; TODO: INSERT HOTKEY TO CLEAR LAST LINE OF CLIPBOARD
; ----------------------------------------------------------------------------

    ;; paste whole test + teardown block
    ^+b::   ; Ctrl + Shift + b
        Input, teardown, T1, {Enter},,
        storeClipboard(false)
        StringUpper, Clipboard, Clipboard
        SendInput, Subprog %clipboard%{Enter}{Tab}
        SendInput, Call SETUP_ALL{Enter}
        SendInput, Call CHECK_EQUAL(1,0, 'test not implemented') From XX1S_QLF{Enter}

        teardownText = %clipboard%_TEARDOWN

        if (teardown = "t") {
            teardownText = GENERIC_%teardownText%
            secondUnderscore := InStr(teardownText, "_",, 1, 2)  ; find second underscore
            ; MsgBox, % "2nd_ = " secondUnderscore
            teardownText := SubStr(teardownText, 1, secondUnderscore-1) 
            teardownText = %teardownText%_TEARDOWN
        }

        SendInput, Call %teardownText%{Enter}
        SendInput, {Home}End

        ; if (teardown = "t") {
        ;     SendInput, {Enter 2}Subprog %teardownText%{Enter 2}End
        ;     SendInput, {NumpadUp 9}
        ; } else{
        SendInput, {NumpadUp 5}
        ; }

        Gosub, ^.

        ; if (teardown = "t"){
        ;     SendInput, {NumpadDown 10}
        ; }else{
        SendInput, {NumpadDown 7}
        ; }
        SendInput, {Enter 3}
        ; SendInput, {F7}
        SendInput, {NumpadUp}
        restoreClipboard(true)
    Return

    ;; surround clipboard contents with Call and _TEARDOWN
    ^b::    ;Ctrl + b
        Input, teardown, T1, {Enter},,
        if (teardown = "t") {
            SendInput, Call{Space}^v_TEARDOWN
        } else {
            SendInput, Call ^v
        }
    Return

    ;; paste freegroup and kill
    ^+f::   ; Ctrl + Shift + f
        Input, code,, {Enter},,
        StringUpper, code, code
        _freeGroup(code)
        ; SendInput, FreeGroup %code% : Kill %code%
    Return

    ;; insert full timing log calls
    ^!t::  ; Ctrl + Alt + t
        Input, logNumber, T3, {Enter},,
        SendInput, Call START_TIMING_LOG('', %logNumber%) From XX1S_DEBUG{Enter}
        SendInput, Call ADD_UNTIMED_LOG_LINE('', %logNumber%) From XX1S_DEBUG{Enter}
        SendInput, Call CLOSE_TIMING_LOG(%logNumber%) From XX1S_DEBUG{Enter}{NumpadUp 3}{Home}{Right 23}
    Return

    ;; insert log_line call
    ^+t::   ; Ctrl + Shift + t
        Input, logNumber, T3, {Enter},,
        SendInput, Call ADD_UNTIMED_LOG_LINE('', %logNumber%) From XX1S_DEBUG{Home}{Right 27}
    Return

    ;; insert local file call
    ^!l::   ; Ctrl + Alt + l
        Input, table,, {Enter},,    ; type 1 or 3 + table abbreviation (without activity code) + Enter
        StringLeft, flag, table, 1
        if flag = 1
            code = XX1B
        else if flag = 3
            code = XX3F
        StringRight, table, table, StrLen(table) - 1
        SendInput, Local File %code%%table%{[}{]}{Left 1}
    Return

    ;; print QLF string and run it
    ^!q::
        Input, contents,,{Enter},,                          ; start with 1, 2, 3; enter abbreviation; press Enter
        q_array := _qlf(contents)
        if q_array [1] != ""
        {
            code := q_array[1]
            abbrev := q_array[2]
            SendInput, %code%%abbrev%.TESTSUITE{Enter}
        }
    Return

    ;; build instance
    ^!i::
        Input, contents,,{Enter},,
        r_array := _instance(contents)
        if (r_array [1] != "")  ; if we returned the code
        {
            code := r_array[1]
            abbrev := r_array[2]
            name := r_array[3]

            identifier := (name ? name : abbrev) ; if name is empty, use abbrev : else, use name
            SendInput, Local Instance %identifier% Using C_%code%%abbrev% : %identifier% = NewInstance C_%code%%abbrev% AllocGroup null{Enter 2}{Tab}
            _freeGroup(identifier)
            ; SendInput, %identifier%{Enter}
        }
    Return

    ;; add comment block in eclipse
    ^.::    ; Ctrl + .
        SendInput, {#}{*}{*}{Enter}
    Return

    ;; print INLINE_LOG with comment
    !^d::   ; Alt + Ctrl + d + text to log + Enter
        Input, log,,{Enter},,
        if !log
            SendInput, Call INLINE_LOG('') From XX1S_QLF{Left 16}
        else
            SendInput, Call INLINE_LOG('%log%') From XX1S_QLF{Left 15}{-}num$(){Left}
    Return

    ;; print CHECK_EQUAL without comment
    ^+z::   ; Ctrl + Shift + z
        SendInput, Call CHECK_EQUAL(,, '') From XX1S_QLF{Left 20}
    Return

    ;; ASETERROR
    ::-ase::   ; auto-complete -aset
        lineText := getText()   ; get line text
        parts := parseStringToArray(lineText, ",")   ; parse each thing separated by commas

        if (parts[1]){  ; if parts 1 is not empty, build string
            instance = % parts[1] ; first thing should be instance
            if (parts.MaxIndex() > 1){    ; get the number of parts passed in
                if (parts[2] = "-"){
                    field = ''
                }else{
                    field = % parts[2]
                }
                prompt = % parts[3]
                if (parts[4] != "-"){
                    promptValue = % "-" . parts[4]
                }
                severity = % parts[5]
                lineText := instance . ".ASETERROR(" . field . ", " . prompt . promptValue . ", " . severity
                if (parts[6]){
                    assign = % parts[6]
                    lineText := assign . "= fmet " . lineText
                }else{
                    lineText := "Callmet " . lineText
                }
                Send, %lineText%
            }
            
        }else{
            Send, Callmet this.ASETERROR('', '', )
        }
    Return

    ;; restart eclipse
    ^!+r::
        Send, !f{Down 27}{Enter}    ; Alt + f + Down (27 times) + Enter : 27 for Oxygen; 18 for Neon
    Return
#ifWinActive

; make it also work in 'Open Safe X3 source file' window
#ifWinActive ahk_class #32770
;; print QLF string and run it
    ^!q::
        Input, contents,,{Enter},,                          ; start with 1, 2, 3; enter abbreviation; press Enter
        q_array := _qlf(contents)
        if q_array [1] != ""
        {
            code := q_array[1]
            abbrev := q_array[2]
            SendInput, %code%%abbrev%
        }
    Return
#ifWinActive