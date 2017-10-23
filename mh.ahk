#Include, %A_ScriptDir%\helpers.ahk
#Include, %A_ScriptDir%\eclipse.ahk
#Include, %A_ScriptDir%\eclipseHelper.ahk
SendMode, Input
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
        ; clearClipboard()
        ; array := parseStringToArray(StoredClip, "|")
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

;; switch to open eclipse tab if eclipse is open. otherwise, open eclipse
#5:: ; Win + 5
    Process, Exist, eclipse.exe ; check if eclipse is running
    If (errorLevel) ; if process exists, switch to window
        WinActivate, workspace
    Else ; if process doesn't exist, errorLevel = 0
        run, "C:\Program Files (x86)\eclipse\eclipse.exe"
Return

#Q::    ; Win + Q to switch to eclipse
    Goto, #5
Return

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
^!1:: Send, XX1B ; print XX1B - Ctrl + Alt + 1
^!2:: Send, XX1S_ ; print XX1S_ - Ctrl + Alt + 2
^!3:: Send, XX3F ; print XX3F - Ctrl + Alt + 3
^!c:: Send, CRETE- ; Ctrl + Alt + c - print CRETE-
; ----------------------------------------------------------------------------
!f1:: WinMaximize A ; Alt + F1 - maximize current window
!f2:: WinMinimize A ; Alt + F2 - minimize current window
; ----------------------------------------------------------------------------

^+v::   ; Ctrl + Shift + v - paste and replace clipboard contents with currently selected text
    storeClipboard(true)
    Send, ^x
    ClipWait, 1.5, 1
    Send, %StoredClip%
return

; ----------------------------------------------------------------------------

;; makes all selected text upper case
^!u::    ; Ctrl + Alt + u
    Send, {CtrlDown}c{CtrlUp}   ; Ctrl + c
    ClipWait, 1, 1
    StringUpper, Clipboard, Clipboard
    Send, {CtrlDown}v{CtrlUp}   ; Ctrl + v
Return
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
; ----------------------------------------------------------------------------

/*
* Firefox context specific hotkeys
*/
; ----------------------------------------------------------------------------
;; opens a new tab at x3v11:8124 if firefox is open
#ifWinActive ahk_class MozillaWindowClass
;; print pull request template
!^p::	;Alt + Ctrl + p
    Send, {#} Description {Enter}*{Space}{Enter}{Enter}
    Send, {#} Dependencies {Enter}*{Space}{Enter}{Enter}
    Send, {#} Screenshots {Enter}*{Space}{Enter}{Enter}
    Send, {#} Test Script {Enter}*{Space}{Enter}
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
