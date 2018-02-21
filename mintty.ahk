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
::-py::	; auto-complete -p
	Send, python
Return

#IfWinActive


; [end YES]
; ----------------------------------------------------------------------------