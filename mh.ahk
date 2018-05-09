#Include, %A_ScriptDir%\helpers.ahk
#Include, %A_ScriptDir%\eclipse.ahk
#Include, %A_ScriptDir%\eclipseHelper.ahk
#Include, %A_ScriptDir%\desktop.ahk
#Include, %A_ScriptDir%\text.ahk
SendMode, Input
#SingleInstance, force

!f1:: WinMaximize A ; Alt + F2 - maximize current window
!f2:: WinMinimize A ; Alt + F2 - minimize current window

;; clears clipboard
^!BackSpace:: ; Ctrl + Alt + Backspace
    clearClipboard()    ; clear it
Return
; ----------------------------------------------------------------------------

; ----------------------------------------------------------------------------
/*
* MINGW64 terminal
*/
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
; [end MING64]
; ----------------------------------------------------------------------------