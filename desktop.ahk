#Include, %A_ScriptDir%\helpers.ahk

SendMode, Input
#SingleInstance, force
#WinActivateForce

; ----------------------------------------------------------------------------
/*
* Taskbar hotkeys
*/
; ----------------------------------------------------------------------------
;; switch to open stride tab if open. otherwise, open hipchat
#i:: ; Win + i
    SetTitleMatchMode, 2    ; open a window if its class contains stride
    Process, Exist, Stride.exe ; check if stride is running
    If (errorLevel) ; if process exists, switch to window
        WinActivate, Stride
    Else ; if process doesn't exist, errorLevel = 0
        run, "C:\Users\Mariana\AppData\Local\Stride\Stride.exe"
Return

;; switch to open sublime tab if open. otherwise, open sublime
#s:: ; Win + s
    Process, Exist, sublime_text.exe ; check if sublime is running
    If (errorLevel) ; if process exists, switch to window
        WinActivate, ahk_exe sublime_text.exe ; ahk_class PX_WINDOW_CLASS
    Else ; if process doesn't exist, errorLevel = 0
        run, "C:\Program Files\Sublime Text 3\sublime_text.exe"
Return

;; switch to open firefox tab if open. otherwise, open firefox
#`:: ; Win + `
    Process, Exist, firefox.exe ; check if firefox is running
    If (errorLevel) ; if process exists, switch to window
        WinActivate, ahk_class MozillaWindowClass ; ahk_exe firefox.exe
    Else ; if process doesn't exist, errorLevel = 0
        run, "C:\Program Files\Firefox Developer Edition\firefox.exe"
Return

;; switch to open eclipse tab if open. otherwise, open eclipse
#q::    ; Win + q to switch to eclipse
    Process, Exist, eclipse.exe ; check if eclipse is running
    If (errorLevel) ; if process exists, switch to window
        WinActivate, ahk_exe eclipse.exe ; ahk_class SWT_Window0
    Else ; if process doesn't exist, errorLevel = 0
        run, "C:\Program Files (x86)\eclipse\eclipse.exe"
Return

;; switch to open amazon music window
#LAlt::    ; Win + leftAlt
    Process, Exist, "Amazon Music.exe" ; check if amazon music is running
    If (errorLevel) ; if process exists, switch to window
        WinActivate, ahk_exe "Amazon Music.exe" ; ahk_class Amazon Music
    Else ; if process doesn't exist, errorLevel = 0
        run, "C:\Users\Mariana\AppData\Local\Amazon Music\Amazon Music.exe"
Return

; switch to task manager window if open, or start process if not
#-::
    Send, ^+{Esc}
Return

;; switch to SSMS
#w::    ; Win +  w
    Process, Exist, Ssms.exe ; check if running
    If (errorLevel) ; if process exists, switch to window
        WinActivate, ahk_exe Ssms.exe
    Else ; if process doesn't exist, errorLevel = 0
        run, "C:\Program Files (x86)\Microsoft SQL Server\140\Tools\Binn\ManagementStudio\Ssms.exe"
Return

;; switch to Outlook
#o::    ; Win +  o
    Process, Exist, OUTLOOK.EXE ; check if running
    If (errorLevel) ; if process exists, switch to window
        WinActivate, ahk_exe OUTLOOK.EXE
    Else ; if process doesn't exist, errorLevel = 0
        run, "C:\Program Files (x86)\Microsoft Office\root\Office16\OUTLOOK.EXE"
Return

;; switch to chrome
#+`::
    Process, Exist, chrome.exe ; check if running
    If (errorLevel) ; if process exists, switch to window
        WinActivate, ahk_exe chrome.exe
    Else ; if process doesn't exist, errorLevel = 0
        run, "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
Return

;; <<<<<<<< cycle through windows of same class >>>>>>>>
^`:: ; Ctrl + ` : switch between windows of the same class
WinGetClass, CurrentActive, A
WinGet, Instances, Count, ahk_class %CurrentActive%
If Instances > 1
    WinActivateBottom, ahk_class %CurrentActive%
return

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