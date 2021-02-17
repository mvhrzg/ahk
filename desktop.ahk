#Include, %A_ScriptDir%\helpers.ahk

SendMode, Input
#SingleInstance, force
#WinActivateForce


;; restart computer
^+!r::  ; Ctrl + Shift + Alt + r
MsgBox, 4,, Would you like to restart the computer?
IfMsgBox, Yes
    Shutdown, 2 ; shutdown 2 = reboot. shutdown 6 = 2(reboot) + 4(force) = force reboot
Return 

;; get current window's path information
f1::
    WinGet, activePath, ProcessPath, % "ahk_id" winActive("A")  ; activePath is the output variable and can be named anything you like, ProcessPath is a fixed parameter, specifying the action of the winget command.
    msgbox % activePath
return
; ----------------------------------------------------------------------------
/*
* Browsers
*/
; ----------------------------------------------------------------------------
;; switch to open opera tab if open. otherwise, open opera
#`:: ; Win + `
    Process, Exist, opera.exe ; check if opera is running
    If (errorLevel){ ; if process exists, switch to window
        WinActivate, ahk_exe opera.exe  ;; ahk_class MozillaWindowClass
        WinSet, Top,, A
    }
    Else ; if process doesn't exist, errorLevel = 0
        run, "C:\Users\mars\AppData\Local\Programs\Opera\launcher.exe"
Return

;; switch to open chrome tab if open. otherwise, open chrome
#c::    ; Win + c to switch to chrome
    Process, Exist, chrome.exe ; check if chrome is running
    If (errorLevel){ ; if process exists, switch to window
        WinActivate, ahk_exe chrome.exe
        WinSet, Top,, A
    }
    Else ; if process doesn't exist, errorLevel = 0
        run, "C:\Program Files\Google\Chrome\Application\chrome.exe"
Return
; [end Broswers]

; ----------------------------------------------------------------------------
/*
* Taskbar hotkeys
*/
; ----------------------------------------------------------------------------
;; switch to open sublime tab if open. otherwise, open sublime
#s:: ; Win + s
    Process, Exist, sublime_text.exe ; check if sublime is running
    If (errorLevel){ ; if process exists, switch to window
        WinActivate, ahk_exe sublime_text.exe ; ahk_class PX_WINDOW_CLASS
        WinSet, Top,, A
    }
    Else ; if process doesn't exist, errorLevel = 0
        run, "C:\Program Files\Sublime Text 3\sublime_text.exe"
Return

;; visual studio code
#v::
    Process, Exist, Code.exe ; check if eclipse is running
    If (errorLevel){ ; if process exists, switch to window
        WinActivate, ahk_exe Code.exe
        WinMaximize, A
        WinSet, Top,, A
    }
    Else ; if process doesn't exist, errorLevel = 0
        run, "C:\Users\%A_UserName%\AppData\Local\Programs\Microsoft VS Code\Code.exe"
Return

; switch to task manager window if open, or start process if not
!Esc::  ; Alt + Esc
    Send, ^+{Esc}
Return

;; switch to SSMS
#t::    ; Win +  t
    Process, Exist, Ssms.exe ; check if running
    If (errorLevel){ ; if process exists, switch to window
        WinActivate, ahk_exe Ssms.exe
        WinSet, Top,, A
    }
    Else ; if process doesn't exist, errorLevel = 0
        run, "C:\Program Files (x86)\Microsoft SQL Server\140\Tools\Binn\ManagementStudio\Ssms.exe"
Return

;; switch to or open Mail app
#o::    ; Win +  o
    run, outlookmail:
Return

;; switch to or open Calendar app
#q::    ; Win + q
    run, outlookcal:
Return

; ----------------------------------------------------------------------------
;; [POWERSHELL SCRIPT TO FIND EXECUTABLE OF STORE APP]
; ** NOTE: Found "Protocol" name in "C:\Program Files\WindowsApps\microsoft.windowscommunicationsapps_16005.13426.20566.0_x64__8wekyb3d8bbwe\AppxManifest.xml"

; $appName = Read-Host "App name"
; $installedapps = get-AppxPackage
; foreach ($app in $installedapps)
; {
;     foreach ($id in (Get-AppxPackageManifest $app).package.applications.application.id)
;     {
        
;         $line = $app.Name + " = " + $app.packagefamilyname + "!" + $id
;         if ($line.IndexOf($appName, [System.StringComparison]::CurrentCultureIgnoreCase) -ge 0) {
;             echo "shell:appsFolder\$app.packagefamilyname!$id" 
;         }
;     }
; }
; ----------------------------------------------------------------------------

;; <<<<<<<< cycle through windows of same class >>>>>>>>
^CapsLock:: ; Win + Capslock : switch between windows of the same class
WinGetClass, CurrentActive, A
WinGet, Instances, Count, ahk_class %CurrentActive%
If Instances > 1
    WinActivateBottom, ahk_class %CurrentActive%
return

#PgDn:: ; Win + PgDn : next window
WinGet, exe, ProcessName, A
WinGet, Instances, Count, ahk_exe %exe%
If Instances > 1
    WinSet, Bottom,, A
WinActivate, ahk_exe %exe%
return

#PgUp:: ; Win + PgUp : previous window
; WinGetClass, CurrentActive, A
WinGet, exe, ProcessName, A
WinGet, Instances, Count, ahk_exe %exe%
If Instances > 1
    WinActivateBottom, ahk_exe %exe%
return
;; <<<<<<<< [end] cycle windows of same class >>>>>>>>

; [end Taskbar]