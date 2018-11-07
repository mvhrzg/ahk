#Include, %A_ScriptDir%\helpers.ahk
SendMode, Input
#SingleInstance, force


;; makes all selected text upper case
^!u::    ; Ctrl + Alt + u
    storeClipboard(false)
    sleep(150)
    cut()   ; Ctrl + c
    StringUpper, Clipboard, Clipboard
    paste()
    sleep(250)
    restoreClipboard(false)
Return

;; makes all selected text lower case
^!l::    ; Ctrl + Alt + l
    storeClipboard(false)
    sleep(150)
    cut()   ; Ctrl + c
    StringLower, Clipboard, Clipboard
    paste()
    sleep(250)
    restoreClipboard(false)
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

; append lines to clipboard
^+c:: ; Ctrl + Shift + c
    storeClipboard(true)
    copy()
    appendToClipboard(Clipboard)
Return

; ----------------------------------------------------------------------------
; Visual Studio Code
; ----------------------------------------------------------------------------
#ifWinActive ahk_exe Code.exe
;; paste console.log(); in visual studio code
^l::    ; Ctrl + l
    console = console.log();
    Send, %console%{Left 2}
Return
#ifWinActive