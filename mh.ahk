#Include, %A_ScriptDir%\helpers.ahk
#Include, %A_ScriptDir%\eclipse.ahk
#Include, %A_ScriptDir%\eclipseHelper.ahk
SendMode, Input
#SingleInstance, force

^!1:: Send, XX1B ; print XX1B - Ctrl + Alt + 1
^!2:: Send, XX1S_ ; print XX1S_ - Ctrl + Alt + 2
^!3:: Send, XX3F ; print XX3F - Ctrl + Alt + 3
^!c:: Send, CRETE- ; Ctrl + Alt + c - print CRETE-
; ----------------------------------------------------------------------------
!f1:: WinMaximize A ; Alt + F1 - maximize current window
!f2:: WinMinimize A ; Alt + F2 - minimize current window

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

; ----------------------------------------------------------------------------
/*
* Taskbar hotkeys
*/
; ----------------------------------------------------------------------------
;; switch to open hipchat tab if open. otherwise, open hipchat
#h:: ; Win + h
    SetTitleMatchMode, 2    ; open a window if its class contains Sublime Text
    Process, Exist, HipChat.exe ; check if sublime is running
    If (errorLevel) ; if process exists, switch to window
        WinActivate, HipChat
    Else ; if process doesn't exist, errorLevel = 0
        run, "C:\Program Files (x86)\Atlassian\HipChat4\HipChat.exe"
Return

;; switch to open sublime tab if open. otherwise, open sublime
#s:: ; Win + s
    SetTitleMatchMode, 2    ; open a window if its class contains Sublime Text
    Process, Exist, sublime_text.exe ; check if sublime is running
    If (errorLevel) ; if process exists, switch to window
        WinActivate, Sublime Text
    Else ; if process doesn't exist, errorLevel = 0
        run, "C:\Program Files\Sublime Text 3\sublime_text.exe"
Return

;; switch to open firefox tab if open. otherwise, open firefox
#`:: ; Win + `
    SetTitleMatchMode, 2    ; open a window if its class contains Mozilla Firefox
    Process, Exist, firefox.exe ; check if sublime is running
    If (errorLevel) ; if process exists, switch to window
        WinActivate, Mozilla Firefox
    Else ; if process doesn't exist, errorLevel = 0
        run, "C:\Program Files (x86)\Mozilla Firefox\firefox.exe"
Return

#q::    ; Win + q to switch to eclipse
    Goto, #5
Return
;; switch to open eclipse tab if eclipse is open. otherwise, open eclipse
#5:: ; Win + 5
    Process, Exist, eclipse.exe ; check if eclipse is running
    If (errorLevel) ; if process exists, switch to window
        WinActivate, workspace
    Else ; if process doesn't exist, errorLevel = 0
        run, "C:\Program Files (x86)\eclipse\eclipse.exe"
Return
; [end Taskbar]
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

^+v::   ; Ctrl + Shift + v - paste and replace clipboard contents with currently selected text
    storeClipboard(true)
    cut()
    ClipWait, 1.5, 1
    Send, %StoredClip%
return
; [end MING64]
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
/*
* Text hotkeys
*/
; ----------------------------------------------------------------------------
;; makes all selected text upper case
^!u::    ; Ctrl + Alt + u
    Send, {CtrlDown}c{CtrlUp}   ; Ctrl + c
    ClipWait, 1, 1
    StringUpper, Clipboard, Clipboard
    Send, {CtrlDown}v{CtrlUp}   ; Ctrl + v
Return

; inverts case of selected text
!x::    ; Alt + x
    invertedClip = ;
    StringCaseSense, On
    cut()
    Loop % StrLen(Clipboard) {
        character := SubStr(Clipboard, A_Index, 1)  ; look at each character separately
        ; MsgBox, character is %character%
        if (isUpper(character)) {
            StringLower, character, character 
            ; Send, % character
        } else{
            StringUpper, character, character
            ; Send, % character
        }
        invertedClip .= character
    }
    Clipboard := invertedClip
    paste()
return
; [end Text]
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