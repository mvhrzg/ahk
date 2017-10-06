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


; ----------------------------------------------------------------------------
; SSMS
; #IfWinActive, ahk_class HwndWrapper[DefaultDomain;;9dcb1362-b06b-4061-9df6-20a9aa8e8f79]
;     MsgBox, you are in SSMS
;     Send, ^u ; Ctrl + u
;     Send, x
; #IfWinActive
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
    Send, ^c   ; Ctrl + c
    ClipWait, 1, 1
    StringUpper, Clipboard, Clipboard
    Send, ^v   ; Ctrl + v
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
