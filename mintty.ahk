#Include, %A_ScriptDir%\helpers.ahk

SendMode, Input
#SingleInstance, force


; ----------------------------------------------------------------------------
/*
* If not in window
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

; [end NOT]
; ----------------------------------------------------------------------------

; ----------------------------------------------------------------------------
/*
* If in window
*/
; ----------------------------------------------------------------------------
#IfWinActive, ahk_class mintty
	MsgBox, mintty open
; insert 'python' string
::-p::	; auto-complete -p
	Send, python
Return
;; open new terminal window
^n: ; Ctrl + n
    Msgbox, you pressed ctrl+n
    Run, "C:\Program Files\Git\git-bash.exe"
Return
#IfWinActive


; [end YES]
; ----------------------------------------------------------------------------