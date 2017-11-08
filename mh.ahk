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
    storeClipboard(true)
    copy()
    appendToClipboard(Clipboard)
Return

;; clears clipboard
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
        run, "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\HipChat\HipChat.lnk"
Return

;; switch to open sublime tab if open. otherwise, open sublime
#s:: ; Win + s
    Process, Exist, sublime_text.exe ; check if sublime is running
    If (errorLevel) ; if process exists, switch to window
        WinActivate, ahk_class PX_WINDOW_CLASS
    Else ; if process doesn't exist, errorLevel = 0
        run, "C:\Program Files\Sublime Text 3\sublime_text.exe"
Return

;; switch to open firefox tab if open. otherwise, open firefox
#`:: ; Win + `
    Process, Exist, firefox.exe ; check if firefox is running
    If (errorLevel) ; if process exists, switch to window
        WinActivate, ahk_class MozillaWindowClass
    Else ; if process doesn't exist, errorLevel = 0
        run, "C:\Program Files (x86)\Mozilla Firefox\firefox.exe"
Return

#q::    ; Win + q to switch to eclipse
    Goto, #5
Return

;; switch to open eclipse tab if open. otherwise, open eclipse
#5:: ; Win + 5
    Process, Exist, eclipse.exe ; check if eclipse is running
    If (errorLevel) ; if process exists, switch to window
        WinActivate, ahk_class SWT_Window0
    Else ; if process doesn't exist, errorLevel = 0
        run, "C:\Program Files (x86)\eclipse\eclipse.exe"
Return

;; <<<<<<<< cycle through windows of same class >>>>>>>>
#PgDn:: ; Wing + PgDn : next window
WinGetClass, CurrentActive, A
WinGet, Instances, Count, ahk_class %CurrentActive%
If Instances > 1
    WinSet, Bottom,, A
WinActivate, ahk_class %CurrentActive%
return

#PgUp:: ; Wing + PgUp : previous window
WinGetClass, CurrentActive, A
WinGet, Instances, Count, ahk_class %CurrentActive%
If Instances > 1
    WinActivateBottom, ahk_class %CurrentActive%
return
;; <<<<<<<< [end] cycle windows of same class >>>>>>>>

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
; [end MING64]
; ----------------------------------------------------------------------------

; ----------------------------------------------------------------------------
/*
* Text hotkeys
*/
; ----------------------------------------------------------------------------
;; makes all selected text upper case
^!u::    ; Ctrl + Alt + u
    copy()   ; Ctrl + c
    StringUpper, Clipboard, Clipboard
    paste()
Return

; inverts case of selected text
!x::    ; Alt + x
    invertedClip = ;
    storeClipboard(false)    ; store previous clipboard and clear it
    cut()                   ; cut selected text

    Loop, Parse, Clipboard
    {
        if (isUpper(A_LoopField)){
            StringLower, character, A_LoopField
        }else if (isLower(A_LoopField)){
            StringUpper, character, A_LoopField
        ; if this character is a space, any punctuation, etc    
        }else if ((ascii(A_LoopField) >= 32  && ascii(A_LoopField) <= 64) || (ascii(A_LoopField) >= 91  && ascii(A_LoopField) <= 96) || (ascii(A_LoopField) >= 123 && ascii(A_LoopField) <= 126)){
            character := A_LoopField
        }

        invertedClip .= character
    }
    assignClipboard(true, invertedClip) ; clear clipboard, then assign to invertedClip
    paste()
    sleep(250)
    restoreClipboard(true)  ; clear clipboard and restore to previous
return

; paste and replace clipboard contents with currently selected text
^+v::   ; Ctrl + Shift + v
    storeClipboard(false)               ; stores clip without clearing after
    cut()                               ; cut the current selection
    tempClip := Clipboard               ; temporarily store selection
    restoreClipboard(true)              ; clear clip and restore clip to initial state
    paste()                             ; paste initial clip
    sleep(250)                          ; this has to be here. any less, clip is empty at this point
    assignClipboard(false, tempClip)    ; replace initial clip with latest selection (tempClip)
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