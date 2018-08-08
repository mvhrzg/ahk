#Include, %A_ScriptDir%\helpers.ahk
#Include, %A_ScriptDir%\eclipse.ahk
#Include, %A_ScriptDir%\eclipseHelper.ahk
#Include, %A_ScriptDir%\desktop.ahk
#Include, %A_ScriptDir%\mintty.ahk
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

;; restart computer
^+!r::  ; Ctrl + Shift + Alt + r
if !WinActive("ahk_class SWT_Window0"){  ; if not using this command from eclipse
    Shutdown, 2 ; shutdown 2 = reboot. shutdown 6 = 2(reboot) + 4(force) = force reboot
}
Return