#Include, %A_ScriptDir%\helpers.ahk
#Include, %A_ScriptDir%\eclipse.ahk
#Include, %A_ScriptDir%\eclipseHelper.ahk
#SingleInstance, force

; append lines to clipboard
^+c:: ; Ctrl + Shift + c
    Input, shouldClear, L1T0.5,,
    If (shouldClear = "c"){
        clearClipboard()
        MsgBox, cleared
    }Else{
        storeClipboard(true)
        appendToClipboard()
        clearClipboard()
        array := parseStringToArray(StoredClip, "|")
    }
Return

;; clear clipboard
^!BackSpace:: ; Ctrl + Alt + Backspace
    clearClipboard()    ; clear it
Return

^!p::
    tests := parseStringToArray(Clipboard, "QLF`n")
    Loop, Parse, tests, QLF`n
    {
        MsgBox, % "test" . A_index . " = " . A_LoopField
    }
return

; ----------------------------------------------------------------------------
#IfWinNotActive, ahk_class mintty
;; print AutoHotKey
::ahk::   ; auto-complete ahk
    Send, AutoHotKey{Space}  ; Return AutoHotKey
Return

::gahk::
    Send, {!}g{Space}AutoHotKey{Space}
Return
#IfWinNotActive
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
    SendInput, %StoredClip%
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

#ifWinActive ahk_class PX_WINDOW_CLASS
^!b::
    Reload
    Sleep 1000 ; If successful, the reload will close this instance during the Sleep, so the line below will never be reached.
    MsgBox, 4,, The script could not be reloaded. Would you like to open it for editing?
    IfMsgBox, Yes, Edit
return
#ifWinActive ahk_class PX_WINDOW_CLASS

; ----------------------------------------------------------------------------	
