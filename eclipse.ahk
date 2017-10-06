#Include, %A_ScriptDir%\eclipseHelper.ahk
#Include, %A_ScriptDir%\helpers.ahk
#SingleInstance, force
SendMode, Input

/*
* Eclipse context specific hotkeys
*/
; ----------------------------------------------------------------------------
#ifWinActive ahk_class SWT_Window0
    ;; MAKE
    ^m::    ; Ctrl + m
        Input, tableCode, T1L1, Enter
        if(tableCode = 1){
            tableCode = "XX1B"
        }else{
            tableCode = ""
        }
        Send, Call MAKE(%tableCode%, "") From XX1S_QLF{Left 20}
    Return

    ;; REMOVE
    ^r::    ; Ctrl + Alt + r
        Send, Call REMOVE("XX1B", "") From XX1S_QLF{Left 20}
    Return

    ;; paste MAKEs as REMOVEs
    ^+r::   ; Ctrl + Shift + r
        StringCaseSense, On
        StringReplace, clipboard, clipboard, MAKE, REMOVE, All  ; replace MAKE with REMOVE
        StringCaseSense, Off

        storeClipboard(false)
        StringReplace, Clipboard, Clipboard, `r`n`r`n, `n, All                ; remove LF
        StringReplace, Clipboard, Clipboard, XX1S_QLF, XX1S_QLF, UseErrorLevel
        counter = 0

        Loop, Parse, Clipboard, `n
        {
            inString := -1   ; variable reset
            ; TODO: incorporate the string "SITE=" for PJ make/remove
            inString := InStr(clipboard, "PROJECT=", false)    ; look for PROJECT=
            If (inString > 0)   ; if string is found
            {
                findSecondPlus := -1    ; variable reset
                ; find second occurrence of +, starting at where this line"s PROJECT= was found + 2
                findSecondPlus := InStr(clipboard, "+",, inString, counter+2)
                If (findSecondPlus > 0) ; if a second + is found
                {
                    beginningString := SubStr(clipboard, 1, (findSecondPlus-2))   ; build the beginning of the string until the character before second +
                    findEnd := InStr(clipboard, ") From XX1S_QLF", true, findSecondPlus) ; find the end of the string -- returns position of )
                    endingString := SubStr(clipboard, findEnd) ; extract the end of the make call
                    clipboard = ; clear clipboard
                    clipboard := beginningString . endingString
                    counter += 1
                }
            }
            ; else{
            ;     Input, howManyAssignments, L1, Space
            ;     inString := (Clipboard, "+",,1, (howManyAssignments*2))    ; look for position of whatever assignment we want *2, so we can trim back
            ;     MsgBox, found secondPlus at %inString%
            ;     beginningString := SubStr(clipboard, 1, (inString-2))   ; build the beginning of the string until the character before second +
            ;     findEnd := InStr(clipboard, ") From XX1S_QLF", true, inString) ; find the end of the string -- returns position of )
            ;     endingString := SubStr(clipboard, findEnd) ; extract the end of the make call
            ;     clipboard = ; clear clipboard
            ;     clipboard := beginningString . endingString
            ;     counter += 1
            ; }
        }

        ; paste the string
        Send, ^v
        Sleep, 10
        restoreClipboard(true)
    Return

    ; local variable
    ::lv::
        scope   := "Local "
        scopeId := "[L]"
        lineText  := getText()
        ; parts: [1]type (i, c, d, dt, dtm), [2]variable name, [3]value, [4]global modifier
        parts := parseStringToArray(lineText, A_Space)
        type  = % parts[1]
        length = ;

        if (type = "i"){
            type := "Integer "
            getLength := false
        }else if (type = "c"){
            type := "Char "
            getLength := true
        }else if(type = "d"){
            type := "Decimal "
            getLength := false
        }else if (type = "dt"){
            type := "Date "
            getLength := false
        }else if (type = "dtm"){
            type := "Datetime "
            getLength := false
        }
        name  = % parts[2]
        value = % parts[3]
        if (parts[4] = "g"){
            scope   := "Global "
            scopeId := "[V]"
        }

        if (parts[3]){  ; if there"s a value, send assignment
            if (getLength){
                length := "(" . StrLen(value)-2 . ")"
                Send, % scope . type . name . length . " : " . scopeId . name . " = " . value
            ; }
            ; lParens := "("
            ; foundLeftParens := InStr(name, lParens)
            ; if (foundLeftParens){
                ; StringTrimRight, name2, name, (StrLen(name)-(foundLeftParens-2))
                ; Send, % scope . type . name . length . " : " . scopeId . name2 . " = " . value
            }else{
                Send, % scope . type . name . length . " : " . scopeId . name . " = " . value
            }
        }else{  ; send declaration
            Send, % scope . type . name
        }
    return

    ; log_instance
    ::-log::  ; auto-complete hotkey
        instance := getText()
        if (instance){
            Send, Call LOG_INSTANCE(%instance%) From XX1S_QLF
        }else{
            Send, Call LOG_INSTANCE() From XX1S_QLF{Left 15}
        }

    Return

    ; prepend CST_ to text
    ::cst::
        Send, CST_
    Return

    ::cstx::
        Send, CST_XX1B_
    Return

    ;; add test stub
    ^t::    ; Ctrl + t
        Send, Call TEST("") From XX1S_QLF{Left 16}
    Return

    ;; add group description
    ^!/::   ; Ctrl + Alt + /
        Input, description,, {Enter},,
        StringLen, length, description
        length := length + 4
        Loop, %length%{
            SendRaw, #
        }
        Send, {Enter}{#}{Space}
        Send, %description%
        Send, {Space}{#}{Enter}
        Loop, %length%{
            SendRaw, #
        }
        Send, {Enter 2}
    Return

; ----------------------------------------------------------------------------
    ;; TODO: INSERT HOTKEY TO CLEAR LAST LINE OF CLIPBOARD
; ----------------------------------------------------------------------------

    ;; paste whole test + teardown block
    ^+b::   ; Ctrl + Shift + b
        Input, teardown, T1, {Enter},,
        storeClipboard(false)
        StringUpper, Clipboard, Clipboard
        Send, Subprog %clipboard%{Enter}{Tab}
        Send, {#} setup{Enter}
        Send, {#} pre-condition{Enter}
        Send, {#} action{Enter}
        Send, {#} assertion{Enter}
        Send, Call CHECK_EQUAL(1,0, "test not implemented") From XX1S_QLF{Enter}

        ; teardownText = %clipboard%_TEARDOWN

        if (teardown = "t") {
            teardownText = %clipboard%_TEARDOWN
            ; teardownText = GENERIC_%teardownText%
            ; secondUnderscore := InStr(teardownText, "_",, 1, 2)  ; find second underscore
            ; teardownText := SubStr(teardownText, 1, secondUnderscore-1) 
            ; teardownText = %teardownText%_TEARDOWN
            Send, {#} cleanup{Enter}
            Send, Call %teardownText%{Enter}{BackSpace 2}
        }else{
            Send, {#} no cleanup{Enter}
        }

        Send, {Home}End

        if (teardown = "t") {
            Send, {Enter 2}Subprog %teardownText%{Enter 2}End
            Send, {NumpadUp 13}
        } else{
            Send, {NumpadUp 8}
        }

        Gosub, ^.
        Send, {Home}

        if (teardown = "t"){
            Send, {NumpadDown 15}
        }else{
            Send, {NumpadDown 11}
        }
        Send, {F7}
        Send, {NumpadUp}
        restoreClipboard(true)
    Return

    ;; surround clipboard contents with Call and _TEARDOWN
    ^b::    ;Ctrl + b
        Input, teardown, T1, {Enter},,
        if (teardown = "t") {
            Send, Call{Space}^v_TEARDOWN
        } else {
            Send, Call ^v
        }
    Return

    ;; paste freegroup and kill
    ^+f::   ; Ctrl + Shift + f
        Input, code,, {Enter},,
        StringUpper, code, code
        _freeGroup(code)
        ; Send, FreeGroup %code% : Kill %code%
    Return

    ;; insert full timing log calls
    ^!t::  ; Ctrl + Alt + t
        Input, logNumber, T3, {Enter},,
        Send, Call START_TIMING_LOG("", %logNumber%) From XX1S_DEBUG{Enter}
        Send, Call ADD_UNTIMED_LOG_LINE("", %logNumber%) From XX1S_DEBUG{Enter}
        Send, Call CLOSE_TIMING_LOG(%logNumber%) From XX1S_DEBUG{Enter}{NumpadUp 3}{Home}{Right 23}
    Return

    ;; insert log_line call
    ^+t::   ; Ctrl + Shift + t
        Input, logNumber, T3, {Enter},,
        Send, Call ADD_UNTIMED_LOG_LINE("", %logNumber%) From XX1S_DEBUG{Home}{Right 27}
    Return

    ;; insert local file call
    ^!l::   ; Ctrl + Alt + l
        Input, table,, {Enter},,    ; type 1 or 3 + table abbreviation (without activity code) + Enter
        StringLeft, flag, table, 1
        if(flag = 1){
            code = XX1B
        }
        else if (flag = 3){
            code = XX3F
        }
        StringRight, table, table, StrLen(table) - 1
        Send, Local File %code%%table%{[}{]}{Left 1}
    Return

    ;; print QLF string and run it
    ^!q::
        Input, contents,,{Enter},,                          ; start with 1, 2, 3; enter abbreviation; press Enter
        q_array := _qlf(contents)
        if q_array [1] != ""
        {
            code := q_array[1]
            abbrev := q_array[2]
            Send, %code%%abbrev%.TESTSUITE{Enter}
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
            Send, Local Instance %identifier% Using C_%code%%abbrev% : %identifier% = NewInstance C_%code%%abbrev% AllocGroup null{Enter 2}{Tab}
            _freeGroup(identifier)
            ; Send, %identifier%{Enter}
        }
    Return

    ;; add comment block in eclipse
    ^.::    ; Ctrl + .
        Send, {#}{*}{*}{Enter}
    Return

    ;; print INLINE_LOG with comment
    !^d::   ; Alt + Ctrl + d + text to log + Enter
        Input, log,,{Enter},,
        if !log
            Send, Call INLINE_LOG("") From XX1S_QLF{Left 16}
        else
            Send, Call INLINE_LOG("%log%") From XX1S_QLF{Left 15}{-}num$(){Left}
    Return

    ;; print CHECK_EQUAL
    ^+z::   ; Ctrl + Shift + z
        Send, Call CHECK_EQUAL(,, "") From XX1S_QLF{Left 20}
    Return

    ;; print CHECK_NOTEQUAL
    ^+n::   ; Ctrl + Shift + n
        Send, Call CHECK_NOTEQUAL(,, "") From XX1S_QLF{Left 20}
    Return

    ;; ASETERROR
    ::-ase::   ; auto-complete -aset
        lineText := getText()   ; get line text
        ; parts: [1]instance, [2]field name, [3]text, [4]severity, [5]assignable integer
        parts := parseStringToArray(lineText, A_Space, """")   ; parse each thing separated by spaces

        if (parts[1]){  ; if parts 1 is not empty, build string
            if (parts[1] = "-"){  ; could be u, or - (for U_THIS or this)
                instance := "this"
            }else{
                if (StrLen(parts[1]) > 1){
                    instance = % parts[1]
                }else{
                    instance := parts[1] . "_THIS"
                }

                StringUpper, instance, instance
            }
            if (parts.MaxIndex() > 1){    ; get the number of parts passed in
                if (parts[2] = "-"){
                    field = ""
                }else{
                    field = % parts[2]
                    StringUpper, field, field
                }
                if (parts[3]){
                    prompt = % parts[3]
                    StringReplace, prompt, prompt, `", `", All
                }
                if (parts[4]){
                    severity = % parts[4]
                    moveback := StrLen(severity) + 2
                }
                lineText := instance . ".ASETERROR(" . field . ", " . prompt . ", " . severity
                if (parts[5]){
                    assign = % parts[5]
                    lineText := assign . " = fmet " . lineText
                }else{
                    lineText := "Callmet " . lineText
                }
                ; moveback := moveback + 3
                Send, %lineText%{Left %moveback%}
            }
            
        }else{
            Send, Callmet this.ASETERROR("", "", CST_)
        }
    Return

    ;; restart eclipse
    ^!+r::
        Send, !f{Down 27}{Enter}    ; Alt + f + Down (27 times) + Enter : 27 for Oxygen; 18 for Neon
    Return
#ifWinActive

; make it also work in "Open Safe X3 source file" window
#ifWinActive ahk_class #32770
;; print QLF string and run it
    ^!q::
        Input, contents,,{Enter},,                          ; start with 1, 2, 3; enter abbreviation; press Enter
        q_array := _qlf(contents)
        if q_array [1] != ""
        {
            code := q_array[1]
            abbrev := q_array[2]
            Send, %code%%abbrev%
        }
    Return
#ifWinActive