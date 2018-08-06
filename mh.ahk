#Include, %A_ScriptDir%\helpers.ahk
#Include, %A_ScriptDir%\eclipse.ahk
#Include, %A_ScriptDir%\eclipseHelper.ahk
#Include, %A_ScriptDir%\desktop.ahk
#Include, %A_ScriptDir%\text.ahk
SendMode, Input
#SingleInstance, force

#z:: WinMaximize A ; Alt + F2 - maximize current window
#x:: WinMinimize A ; Alt + F2 - minimize current window

;; clears clipboard

!BackSpace:: ; Ctrl + Alt + Backspace
    clearClipboard()    ; clear it
Return
; ----------------------------------------------------------------------------
^!1:: Send, XX1B ; print XX1B - Ctrl + Alt + 1
^!2:: Send, XX1S_ ; print XX1S_ - Ctrl + Alt + 2
^!3:: Send, XX3F ; print XX3F - Ctrl + Alt + 3
^!c:: Send, CRETE- ; Ctrl + Alt + c - print CRETE-
#IfWinActive, ahk_class mintty
    ^!c:: Send, CRETE- ; Ctrl + Alt + c - print CRETE-
#IfWinActive
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