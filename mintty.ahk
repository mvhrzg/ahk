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
; insert 'python' string
::-py::	; auto-complete -p
	Send, python
Return

#e::
	; directory = ;
	; WinGetActiveTitle, gitBashWindow
	; ; search for the first (R*1*) "/" coming from the right (*R*1) to extract the explorer window's title (it equals the directory)
	; StringGetPos, firstSlash, gitBashWindow, / , R1	; gets the position of the last character before "/"
	; ; extract the directory's name
	; directory := SubStr(gitBashWindow, firstSlash + 2)	; + 2 to forget the last character before "/" and also "/"
	; sleep(50)
	; ; if the window for this directory if already open, activate it
	; IfWinExist, % directory
	; {
	; 	WinActivate ; uses the last found window
	; }
	; else {
	; 	; otherwise, open it
	; 	storeClipboard(false)
	; 	assignClipboard(false, "start")
	; 	Send, %Clipboard% {Enter}
	; 	restoreClipboard(false)
	; }

	Send, {Home}start {Enter}
Return

#IfWinActive


; [end YES]
; ----------------------------------------------------------------------------