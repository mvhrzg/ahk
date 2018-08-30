#Include, %A_ScriptDir%\helpers.ahk
#Include, %A_ScriptDir%\eclipse.ahk
#Include, %A_ScriptDir%\eclipseHelper.ahk
#Include, %A_ScriptDir%\desktop.ahk
#Include, %A_ScriptDir%\mintty.ahk
#Include, %A_ScriptDir%\text.ahk
SendMode, Input
#SingleInstance, force
#WinActivateForce

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

;; reload mh.ahk from any .ahk script
#ifWinActive ahk_class PX_WINDOW_CLASS
^!s::   ; Ctrl + Alt + s
    WinGetActiveTitle, currentWindow
    StringGetPos, findSlash, currentWindow, \ , R1 ; gets the position of the last character before "\"
    currentScript := SubStr(currentWindow, findSlash + 2)  ; + 2 to forget the last character before "\" and also "\"

    StringGetPos, findDash, currentScript, -, L
    currentScript := SubStr(currentScript, 1, findDash - 1)    ; remove the right end of the string ( - Sublime Text)

    StringGetPos, findSlash, A_ScriptFullPath, \ , R1 ; gets the position of the last character before "\"
    activeScript := SubStr(A_ScriptFullPath, findSlash + 2)

    if WinActive("ahk_class PX_WINDOW_CLASS") and InStr(currentWindow, .ahk) > 0{
        sleep(300)
        MsgBox, % "reloading [" . activeScript . "] from [" . currentScript . "]"
        reload, A_ScriptFullPath
    }
Return
#IfWinActive