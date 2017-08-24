#SingleInstance force
; #Include, %A_ScriptDir%\test.ahk

; global Clipboard variable
global _previousClip := 

getText(){
    storeClipboard(true)
    Sleep, 250
    textToGet =
    SendInput, {ShiftDown}{Home}{ShiftUp}
    SendInput , ^x
    ClipWait 1, 1
    textToGet = %Clipboard%
    restoreClipboard(true)

    return textToGet
}

; ----------------------------------------------------------------------------
; TODO: FIX THIS!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
; ----------------------------------------------------------------------------
^+c:: ; Ctrl + Shift + c
    Input, clear, L2 T1, {Enter},
    If (clear = "c"){
        clearClipboard()
    }

    if (!saved){
        SendInput, ^c
        ; MsgBox, saved is empty
        ; saved = %Clipboard%
        clearClipboard()
    }else{
        ; MsgBox, saved not empty
        SendInput, ^c
        ClipWait, 1, 1
        ; MsgBox, saved is not empty:`n%saved%
        saved = %saved%`n%Clipboard%
        MsgBox, saved = %saved%`nClip = %Clipboard%
        clearClipboard()
        ; SendInput, ^c
        ; saved = %saved%`n%Clipboard%
        ; Clipboard = ;
    }
    ; }

    ; MsgBox, %clipboard%
    ; Loop, Parse, saved, `n
    ; {
    ;     MsgBox 4, ,Word %A_Index% is %A_LoopField%`n`nContinue?
    ;     IfMsgBox, No, break
    ; }
    ; SendInput, ^c
    ; Clipboard := saved . "`n" . Clipboard
    ; SendInput, ^v
Return

;; clear clipboard
^!BackSpace:: ; Ctrl + Alt + Backspace
    clearClipboard()    ; clear it
Return

clearClipboard() {
     Clipboard = ; clear clipboard
     Sleep, 100
}

storeClipboard(clearAfterStore){
    _previousClip := Clipboard
    if(clearAfterStore){
        clearClipboard()
    }
}

restoreClipboard(clearBeforeRestore){
    if (clearBeforeRestore){
        clearClipboard()
    }
    Clipboard := _previousClip
}
; ----------------------------------------------------------------------------
; ----------------------------------------------------------------------------
;; print AutoHotKey
!^a::   ; Alt + Ctrl + a + wait for h + wait for k
    Input, first, L2 T2, k,,    	; type hk
    if first = h                	; if letter before k is h
        SendInput, AutoHotKey{Space}  ; Return AutoHotKey
    else
        Return
Return
; ----------------------------------------------------------------------------
^!1:: SendInput, XX1B ; print XX1B - Ctrl + Alt + 1
^!2:: SendInput, XX1S_ ; print XX1S_ - Ctrl + Alt + 2
^!3:: SendInput, XX3F ; print XX3F - Ctrl + Alt + 3
^!c:: SendInput, CRETE- ; Ctrl + Alt + c - print CRETE-
; ----------------------------------------------------------------------------
!f1:: WinMaximize A ; Alt + F1 - maximize current window
!f2:: WinMinimize A ; Alt + F2 - minimize current window
; ----------------------------------------------------------------------------

^+v::   ; Ctrl + Shift + v - paste and replace clipboard contents with currently selected text
    storeClipboard(true)
    SendInput, ^x
    ClipWait, 1.5, 1
    SendInput, %_previousClip%
return

; ----------------------------------------------------------------------------

;; makes all selected text upper case
^!u::    ; Ctrl + Alt + u
    SendInput, ^c   ; Ctrl + c
    ClipWait, 1, 1
    StringUpper, Clipboard, Clipboard
    SendInput, ^v   ; Ctrl + v
Return
; ----------------------------------------------------------------------------

;; count selected characters
^#c::   ; Ctrl + Win + c
    storeClipboard(true)
    SendInput, ^c   ; copy selected content
    ClipWait, 1, "text"
    length := StrLen(Clipboard)
    MsgBox, 0, Character length, %length% characters selected, 5
    restoreClipboard(true)
Return
; ----------------------------------------------------------------------------

;; print QLF outside of eclipse
^!q::   ; Ctrl + Alt + q
    Input, contents,,{Enter},,                          ; start with 1, 2, 3; enter abbreviation; press Enter
    q_array := _qlf(contents)
    if q_array [1] != ""
    {
        code := q_array[1]
        abbrev := q_array[2]
        SendInput, %code%%abbrev%
    }
Return
; ----------------------------------------------------------------------------

/*
* Firefox context specific hotkeys
*/
; ----------------------------------------------------------------------------
;; opens a new tab at x3v11:8124 if firefox is open
#ifWinActive ahk_class MozillaWindowClass
!^x::   ; Alt + Ctrl + x + wait for 3
    Input, first, L2 T2, {Enter},,  ; type 3 + Enter
    if first = 3                	; if typed 3
        Run, http://x3v11:8124		; run x3v11:8124 in browser
    else
        Return
Return

;; print pull request template
!^p::	;Alt + Ctrl + p
    SendInput, {#} Description {Enter}*{Space}{Enter}{Enter}
    SendInput, {#} Dependencies {Enter}*{Space}{Enter}{Enter}
    SendInput, {#} Screenshots {Enter}*{Space}{Enter}{Enter}
    SendInput, {#} Test Script {Enter}*{Space}{Enter}
Return
#ifWinActive
; [end Firefox]
; ----------------------------------------------------------------------------



/*
* Eclipse context specific hotkeys
*/
; ----------------------------------------------------------------------------
#ifWinActive ahk_class SWT_Window0
    ;; MAKE
    ^m::	; Ctrl + m
    	SendInput, Call MAKE('XX1B', '') From XX1S_QLF{Left 20}
	Return

    ;; REMOVE
    ^r::	; Ctrl + Alt + r
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
	^t::	; Ctrl + t
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
	^+b::	; Ctrl + Shift + b
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
        freeGroup(code)
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
	^+t::	; Ctrl + Shift + t
		Input, logNumber, T3, {Enter},,
		SendInput, Call ADD_UNTIMED_LOG_LINE('', %logNumber%) From XX1S_DEBUG{Home}{Right 27}
	Return

	;; insert local file call
	^!l::	; Ctrl + Alt + l
		Input, table,, {Enter},,	; type 1 or 3 + table abbreviation (without activity code) + Enter
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
            freeGroup(identifier)
            ; SendInput, %identifier%{Enter}
        }
    Return

	;; add comment block in eclipse
    ^.::	; Ctrl + .
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
	^!s::   ; Ctrl + Alt + s
	    Input, error, T4,{Enter},,                                                      ; get error code
	    if (!error)                                                                     ; if none, print and set cursor
	        SendInput, Callmet U_THIS.ASETERROR('', '', ){Left 8}
	    else{
	        StringUpper, error, error                                                   ; if error, set to upper case
	        moveback := 12 + StrLen(error)                                                     ; add 12 to it
	        SendInput, Callmet U_THIS.ASETERROR('', '', CST_A%error%){Left %moveback%}   ; print error and set cursor            
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

;; instance text helper
_instance(contents){
    StringLeft, flag, contents, 1, 1                    ; get XX1B or XX3F code
    if (flag = 1)
        code = XX1B
    else if (flag = 3)
        code = XX3F
    else if (flag != 1 and flag != 3){
        Return [""]
    }
    dash := InStr(contents, "-",, 2)    ; if we find a dash, it means we want the instance name to be different than its abbreviation
    if (dash > 0){
        name := SubStr(contents, (dash+1))
        StringUpper, name, name
        abbrevLength := (StrLen(contents) - StrLen(flag) - StrLen(name) - 1) ; length of whole string - length of flag (1) - length of name (?) - 1 (dash length)
    }else{
        abbrevLength := (StrLen(contents) - StrLen(flag) - StrLen(name)) ; length of whole string - length of flag (1) - length of name (?)
    }
        
    ; MsgBox, % "contents.length = " . StrLen(contents) . "`ncode.length = " . StrLen(code) . "`nname.length = " . StrLen(name) . "`n abbrevLength =" . StrLen(abbrevLength)

    StringMid, abbrev, contents, 2, abbrevLength	; get abbreviation
    StringUpper, abbrev, abbrev                         ; set abbreviation to upper case
    array := [code, abbrev, name]

    Return array
}
;; qlf text helper
_qlf(contents){
    StringLeft, flag, contents, 1                       	; get the activity code flag
    if (flag = 1)
        code = QLFXX1B_XX1B
    else if (flag = 2)
        code = QLFXX1S_
    else if (flag = 3)
        code = QLFXX3F_XX3F
    else if (flag != 1 and flag != 2 and flag != 3)
        Return [""]
    StringMid, abbrev, contents, 2, strlen(contents)-1,     ; get the entity/script name/abbreviation
    StringUpper, abbrev, abbrev
    array := [code, abbrev]
    Return array
}

freeGroup(code){
    SendInput, FreeGroup %code% : Kill %code%
}
; [end Eclipse section]
; ----------------------------------------------------------------------------


/*
* Debugging and helpers
*/
; ----------------------------------------------------------------------------
;; Used for debugging/creating window specific hotkeys
;; displays all active windows (with ID, class and title) in a popup
^+!l::	;Ctrl + Shift + Alt + l
    WinGet, id, list,,, Program Manager
    Loop, %id%
    {
        this_id := id%A_Index%
        WinActivate, ahk_id %this_id%
        WinGetClass, this_class, ahk_id %this_id%
        WinGetTitle, this_title, ahk_id %this_id%
        MsgBox, 4, , Visiting All Windows`n%a_index% of %id%`nID: %this_id%`nCLASS: %this_class%`nTITLE: %this_title%`n`nContinue?
        ifMsgBox, NO, break
    }
Return

;; inserts section separator if in sublime, in mh.ahk
#ifWinActive ahk_class PX_WINDOW_CLASS
^1::	;Ctrl + 1
	SetTitleMatchMode, 2
	#ifWinActive, mh.ahk
		SendInput, {Enter}
		SendInput, ^/   ;Ctrl + / 
		SendInput, {- 76}
	#ifWinActive
Return
#ifWinActive

;; key history window : used for debugging hotkeys
*ScrollLock::   ; ScrollLock
    KeyHistory
Return
; ----------------------------------------------------------------------------	
