#Include, %A_ScriptDir%\eclipseHelper.ahk
#Include, %A_ScriptDir%\helpers.ahk
#SingleInstance, force
SendMode, Input

;; this needs to be here to run preventKeySticking after building test block (^b)
#Persistent
SetTimer, ^b, 6000
Return

^!1:: Send, XX1B ; print XX1B - Ctrl + Alt + 1
^!2:: Send, XX1S_ ; print XX1S_ - Ctrl + Alt + 2
^!3:: Send, XX3F ; print XX3F - Ctrl + Alt + 3
^!c:: Send, CRETE- ; Ctrl + Alt + c - print CRETE-
; ----------------------------------------------------------------------------

;; print QLF outside of eclipse
^!q::   ; Ctrl + Alt + q
Input, contents,,{Enter},,                          ; start with 1, 2, 3; enter abbreviation; press Enter
q_array := _qlf(contents)
if (q_array [1] != ""){
    code := q_array[1]
    abbrev := q_array[2]
    Send, %code%%abbrev%
}
Return

/*
* Eclipse context specific hotkeys
*/
; ----------------------------------------------------------------------------
#ifWinActive ahk_class SWT_Window0
;; CREATE
::-c::    ; auto-complete -c
    storeClipboard(false)
    lineText := getText(true)
    lineText := Trim(lineText)
    if(lineText){
        tableCode := % lineText
    }else{
        tableCode = ""
    }
    Clipboard := "  Call CREATE(""" . tableCode . """, """",) From XX1S_QLF"
    paste()
    Send, {Left 17}
    restoreClipboard(false)
Return

;; EMBALM
::-e::   ; auto-complete -e
    storeClipboard(false)
    lineText := getText(true)
    lineText := Trim(lineText)
    if(lineText){
        tableCode := % lineText
    }
    ; else{
    ;     tableCode =   ""
    ; }
    Clipboard := "  Call EMBALM(""" . tableCode . """, """") From XX1S_QLF"
    paste()
    Send, {Left 16}
    restoreClipboard(false)
Return

; variable declarations
::-v::   ; auto-complete -v
    lineText  := getText(true)
    ; parts: [1] scope (l or g), [2]type (i, c, d, dt, dtm, f (file)), [3]variable/file name, [4]value/file abbreviation #, [4]global modifier
    parts := parseStringToArray(lineText, A_Space)
    scope   := "Local "
    scopeId = % parts [1]
    type = ;
    typeId  = % parts[2]
    length = ;

    if(scopeId = "l"){
        scopeId := "[L]"
    }else if(scopeId = "g"){
        scopeId := "[V]"
        scope   := "Global "
    }

    if(typeId = "i"){
        type := "Integer "
        getLength := false
    }else if(typeId = "c"){
        type := "Char "
        getLength := true
    }else if(typeId = "d"){
        type := "Decimal "
        getLength := false
    }else if(typeId = "dt"){
        type := "Date "
        getLength := false
    }else if(typeId = "dtm"){
        type := "Datetime "
        getLength := false
    }else if(typeId = "f"){
        type := "File "
        getLenth := false
    }
    name  = % parts[3]
    value = % parts[4]
    ; TODO: ADD WHERE CLAUSE
    if(typeId = "f"){ ; if this is a file declaration, name will be an integer followed by the table characters (e.g.: 1WBS)
        StringReplace, name, name, 1, XX1B, All ; replace starting 1 with XX1B
        StringReplace, name, name, 2, XX1S, All ; replace starting 2 with XX1S
        StringReplace, name, name, 3, XX3F, All ; replace starting 3 with XX3F
        if(parts[4]){  ; if the table abbreviation is different than the completing filename characters, append abbreviation to name
            name := name . "[" . value . "]"     ; append parts[4] (table abbreviation)
        }
    }else if(parts[4]){  ; value assignment
        ; if this not a file declaration, check if there's an assignment
        if(getLength){ ; if this is a char with a value
            length := "(" . StrLen(value)-2 . ")"
            Send, % scope . type . name . length . " : " . scopeId . name . " = " . value
            return
        }else{  ; if this is not a file or a char, but there's a value
            Send, % scope . type . name . length . " : " . scopeId . name . " = " . value
            return
        }
    }
    Send, % scope . type . name     ; send table declaration
return

; log_instance
::-log::  ; auto-complete hotkey
    storeClipboard(true)
    instance := getText(true)
    instance := RTrim(instance) ; remove trailing space between instanceName and -log
    call = ;
    if(instance){
        call := % "Call LOG_INSTANCE(" . instance . ") From XX1S_QLF"
        assignClipboard(false, call)
        paste()
        sleep(250)
    }else{
        call := "Call LOG_INSTANCE() From XX1S_QLF"
        assignClipboard(false, call)
        paste()
        sleep(100)
        Send, {Left 15}
    }
    restoreClipboard(false)
Return

; prepend CST_ to text
::cst::
    Send, [V]CST_
Return

::cstx::
    Send, [V]CST_XX1B_
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
Return

;; splits current line on cursor and adds &+{Tab}";" at beginning of new line
^Enter::    ; Ctrl + Enter
    newFieldLine = `r`n&    ; +  ";"
    storeClipboard(false)
    assignClipboard(false, newFieldLine)
    paste()
    sleep(100)
    restoreClipboard(false)
    ; Send, {Left 3}
Return

;; splits current line on cursor and adds & as first character of new line
^NumpadEnter::  ; Ctrl + NumpadEnter
    newFieldLine = `n&
    storeClipboard(false)
    assignClipboard(false, newFieldLine)
    paste()
    sleep(175)
    restoreClipboard(false)
Return

;; re-run previous test
^r::    ; Ctrl + r
    Send, {F7 Down}{F7 Up}                  ; compile
    sleep(200)
    Send, {Shift Down}{Alt Down}{q Down}    ; hit view-console shortcut
    sleep(100)
    Send, {Shift Up}{Alt Up}{q Up}          ; release view-console shortcut
    sleep(500)
    Send, {c Down}{c Up}                    ; hit and release terminal console key
    sleep(500)                              ; wait for terminal to open
    Send, {NumpadUp}{Enter}                 ; hit up + enter to run previous
Return

;; build single or multiple test block(s)
^b::   ; Ctrl + b
    storeClipboard(false)
    builtBlock = ;
    StringReplace, Clipboard, Clipboard, `r`n`r`n, `n, All
    ; delimiter = |
    if (InStr(Clipboard, "Call TEST(", true, 1, 2)) {
        ; testArray := parseStringToArray(Clipboard, delimiter)
        Loop, Parse, Clipboard, `n
        {
            firstQuote := InStr(A_LoopField, """",, 1)
            secondQuote := InStr(A_LoopField, """",, firstQuote, 2) 
            ; MsgBox, firstQuote = %firstQuote%. secondQuote = %secondQuote%
            if (firstQuote && secondQuote) {
                thisTest := SubStr(A_LoopField, firstQuote+1, secondQuote-(firstQuote+1))
                builtBlock .= _buildTestBlock(thisTest)
                ; MsgBox, builtBlock = %builtBlock%
            }
        }
    } else{
        firstQuote := InStr(Clipboard, """",, 1)
        secondQuote := InStr(Clipboard, """",, firstQuote, 2) 
        ; MsgBox, firstQuote = %firstQuote%. secondQuote = %secondQuote%
        if (firstQuote && secondQuote) {
            thisTest := SubStr(Clipboard, firstQuote+1, secondQuote-(firstQuote+1))
            builtBlock .= _buildTestBlock(thisTest)
            ; MsgBox, builtBlock = %builtBlock%
        } else{
            builtBlock := _buildTestBlock(Clipboard)
        }
    }
    assignClipboard(true, builtBlock)
    paste()
    sleep(250)
    restoreClipboard(true)
Return

;; prepend clipboard contents with "Call"
^+a::    ;Ctrl + Shift + a
    Send, Call{Space}
    paste()
Return

;; paste freegroup and kill
::-fg::   ; auto-complete: -fg
    storeClipboard(false)
    code := getText(false)
    code := RTrim(code)
    _freeGroup(code)
    sleep(100)
    restoreClipboard(false)
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

;; build instance. example: 1wp OR 1wp-package
^!i::   ; Ctrl + Alt + i
    Input, contents,,{Enter},,
    r_array := _instance(contents)
    if(r_array [1] != "")  ; if we returned the code
    {
        code := r_array[1]
        abbrev := r_array[2]
        name := r_array[3]

        identifier := (name ? name : abbrev) ; if name is empty, use abbrev : else, use name
        Send, Local Instance %identifier% Using C_%code%%abbrev% : [L]%identifier% = NewInstance C_%code%%abbrev% AllocGroup null
    }
Return

;; add comment block in eclipse
^.::    ; Ctrl + .
    Send, {#}{*}{*}{Enter Down}{Enter Up}
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
    lineText := getText(true)   ; get line text
    ; parts: [1]instance, [2]field name, [3]text, [4]severity, [5]assignable integer
    parts := parseStringToArray(lineText, A_Space, """")   ; parse each thing separated by spaces

    if(parts[1]){  ; if parts 1 is not empty, build string
        if(parts[1] = "-"){  ; could be u, or - (for U_THIS or this)
            instance := "this"
        }else{
            if(StrLen(parts[1]) > 1){
                instance = % parts[1]
            }else if(parts[1] = "U"){
                instance := parts[1] . "_THIS"
            }

            StringUpper, instance, instance
        }
        if(parts.MaxIndex() > 1){    ; get the number of parts passed in
            if(parts[2] = "-"){
                field = ""
            }else{
                field = % parts[2]
                StringUpper, field, field
            }
            if(parts[3]){
                prompt = % parts[3]
                StringReplace, prompt, prompt, `", `", All
            }
            if(parts[4]){
                severity = % parts[4]
                moveback := StrLen(severity) + 2
            }
            lineText := instance . ".ASETERROR(" . field . ", " . prompt . ", " . severity
            if(parts[5]){
                assign = % parts[5]
                lineText := assign . " = fmet " . lineText
            }else{
                lineText := "Callmet " . lineText
            }
            ; moveback := moveback + 3
            Send, %lineText%{Left %moveback%}
        }
        
    }else{
        Send, Callmet this.ASETERROR("", "", [V]CST_)
    }
Return

;; restart eclipse
^!+r::
    Send, !f{Up 2}{Enter}    ; Alt + f + Up (2 times) + Enter
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