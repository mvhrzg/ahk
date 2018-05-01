
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
;; switch to open stride tab if open. otherwise, open hipchat
#r:: ; Win + r
    SetTitleMatchMode, 2    ; open a window if its class contains stride
    Process, Exist, Stride.exe ; check if stride is running
    If (errorLevel) ; if process exists, switch to window
        WinActivate, Stride
    Else ; if process doesn't exist, errorLevel = 0
        run, "C:\Users\Mariana\AppData\Local\Stride\app-1.17.82\Stride.exe"
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
        WinActivate, ahk_exe firefox.exe ; ahk_class MozillaWindowClass
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
#Esc::
    Send, ^+{Esc}
Return

;; switch to SSMS
#w::    ; Win +  w
    Process, Exist, Ssms.exe ; check if running
    If (errorLevel) ; if process exists, switch to window
        WinActivate, ahk_exe Ssms.exe
    Else ; if process doesn't exist, errorLevel = 0
        run, "C:\Program Files (x86)\Microsoft SQL Server\140\Tools\Binn\ManagementStudio\Ssms.exe
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
=======
#Include, %A_ScriptDir%\helpers.ahk
#Include, %A_ScriptDir%\mintty.ahk

SendMode, Input
#SingleInstance, force

; ----------------------------------------------------------------------------
; #IfWinNotActive, ahk_class mintty
!x:: WinMaximize A ; Alt + x - maximize current window
!z:: WinMinimize A ; Alt + F2 - minimize current window
^#x:: WinClose, A  ; Alt + Win + x - close current window
; #IfWinNotActive

; set mouse to left-handed configuration
^F1:: ; Ctrl + F1
    swapMouseButtons(True)
Return

^F2:: ; Ctrl + F2
    swapMouseButtons(False)
Return

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
* Google search highlighted Text
*/

MButton::
    textToSearch := "!g " ; !g reset variable
    storeClipboard(false)
    copy()
    textToSearch .= Clipboard
    assignClipboard(false, textToSearch)
    WinActivate, ahk_exe firefox.exe
    Send, ^t        ; open new tab
    sleep(150)      ; wait for new tab
    paste()
    sleep(150)
    Send, {Enter}
    restoreClipboard(false)
Return

; [end Google search]


; ----------------------------------------------------------------------------
/*
* Taskbar hotkeys
*/
; ----------------------------------------------------------------------------
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
        WinActivate, ahk_exe firefox.exe ; ahk_class MozillaWindowClass
    Else ; if process doesn't exist, errorLevel = 0
        run, "C:\Program Files\Firefox Developer Edition\firefox.exe"
Return
;; switch to open amazon music window
#LAlt::    ; Win + leftAlt
    Process, Exist, "Amazon Music.exe" ; check if amazon music is running
    If (errorLevel) ; if process exists, switch to window
        WinActivate, ahk_exe "Amazon Music.exe" ; ahk_class Amazon Music
    Else ; if process doesn't exist, errorLevel = 0
        run, "C:\Users\mvher\AppData\Local\Amazon Music\Amazon Music.exe"
Return

; switch to task manager window if open, or start process if not
#Esc::
    Send, ^+{Esc}
Return

;; <<<<<<<< cycle through windows of same class >>>>>>>>
#+Tab:: ; Win + Shift + Tab : switch between windows of the same class
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
^!x::    ; Ctrl + Alt + x
    invertedClip = ;
    storeClipboard(false)   ; store previous clipboard and clear it
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

; pascal case selected Text
^!p::   ; Ctrl + Alt + p
    pascalClip = ;
    storeClipboard(false)   ; store previous clipboard and clear it
    cut()                   ; cut selected text

    StringUpper, pascalClip, Clipboard, T   ; title/pascal case the clipboard
    assignClipboard(true, pascalClip)       ; clear clipboard, then assign to pascalClip
    paste()
    sleep(250)
    restoreClipboard(true)                  ; clear clipboard and restore to previous
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

; replace one character with another
; TODO: expand replaceWhat selection to multiple
^!q::   ; Ctrl + Alt + q
    continue := false, newClip = ;
    cut()
    storeClipboard(false)

    ; ask what character(s) to replace. handles character conversion if input is numeric
    Gosub, replaceWhatMsg

    ; if routine not cancelled, ask with what character to replace the previous input. handles conversion
    If (continue) {
        Gosub, replaceWithMsg
    }

    ; if routine not cancelled, replace every occurrence of replaceWhat with replaceWith
    If (continue) {
        newClip := StrReplace(Clipboard, replaceWhat, replaceWith)
    }

    assignClipboard(false, newClip)     ; replace previous clip with replaced characters
    paste()                             ; paste new clip
    sleep(250)                          ; wait
    restoreClipboard(false)             ; restore clip to previous
return

; [end Text]
; ----------------------------------------------------------------------------