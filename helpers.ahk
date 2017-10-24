#Include, %A_ScriptDir%\mh.ahk
global StoredClip = ; global Clipboard variable
SendMode, Input
#SingleInstance, force

/*
* Debugging and helpers: used for debugging/creating window specific hotkeys
*/
; ----------------------------------------------------------------------------

copy(){
    Send, ^c
}

paste(){
    Send, ^v
}

cut(){
    Send, ^x
}

getText(){
    storeClipboard(true)
    Sleep, 250
    textToGet =
    Send, {ShiftDown}{Home}{ShiftUp}
    cut()
    ClipWait 1, 1
    textToGet = %Clipboard%
    restoreClipboard(true)

    return textToGet
}

;; displays all active windows (with ID, class and title) in a popup
;; loop through all open windows and print their info
^+!l::	;Ctrl + Shift + Alt + l
    WinGet, id, list,,, Program Manager
    Loop, %id%
    {
        this_id := id%A_Index%
        WinActivate, ahk_id %this_id%
        WinGetClass, this_class, ahk_id %this_id%
        WinGetTitle, this_title, ahk_id %this_id%
        WinGetText, this_text, ahk_id %this_id%
        MsgBox, 4, ,Window %a_index% of %id%`nID: %this_id%`nCLASS: %this_class%`nTITLE: %this_title%`nTEXT: %this_text%`n`nContinue (Ctrl + C to copy all text)?
        ifMsgBox, NO, break
    }
Return

;; inserts section separator if in sublime
#ifWinActive ahk_class PX_WINDOW_CLASS
^1::	;Ctrl + 1
	SetTitleMatchMode, 3
	#ifWinActive, mh.ahk
		Send, {Enter}
		Send, ^/   ;Ctrl + / 
		Send, {- 76}
	#ifWinActive

Return
#ifWinActive

;; key history window : used for debugging hotkeys
*ScrollLock::   ; ScrollLock
    KeyHistory
Return

;; count selected characters
^#c::   ; Ctrl + Win + c
    storeClipboard(true)
    copy()   ; copy selected content
    ClipWait, 1, "text"
    length := StrLen(Clipboard)
    MsgBox, 0, Character length, %length% characters selected, 5
    restoreClipboard(true)
Return

appendToClipboard(){
    clipBreak = |

    copy()
    ClipWait, 0.5, 1
    if (!StoredClip){   ; 1. StoredClip is empty
        storeClipboard(false)
        ; StoredClip := clipBreak . Clipboard ; 1. StoredClip = hello?
    }
    else{   ; 2. StoredClip = hello?
        ; StoredClip = hello?|hello!|
        StoredClip := StoredClip . clipBreak . Clipboard
    }
}

clearClipboard() {
     Clipboard = ; clear clipboard
     Sleep, 100
}

storeClipboard(clearAfterStore){
    StoredClip := Clipboard
    if(clearAfterStore){
        clearClipboard()
    }
    ; MsgBox, % "storedClip = " . StoredClip
}

restoreClipboard(clearBeforeRestore){
    if (clearBeforeRestore){
        clearClipboard()
    }
    Clipboard := StoredClip
}

parseStringToArray(input, delimiter, wrapper := 0){
    parsedArray := Object()
    StringReplace, input, input, +, {+}, All
    StringReplace, input, input, (, {(}, All
    StringReplace, input, input, ), {)}, All
    ; MsgBox, % "wrapper = " . wrapper
    if (!wrapper){
        ; MsgBox, no wrapper
        Loop, Parse, input, % delimiter
        {
            parsedArray[A_index] := A_LoopField
        }
    }else{
        ; MsgBox, yes wrapper
        Loop, Parse, input, % delimiter
        {
            ; MsgBox, % "wrapper parse = " . A_LoopField
            if (InStr(A_LoopField, wrapper))
            {
                ; MsgBox, found wrapper
                Loop, Parse, A_LoopField, % wrapper
                {
                    tempLoopField = %tempLoopField% %A_LoopField%     ; keep adding to temp
                    ; MsgBox, temp = %tempLoopField%
                }
                StringReplace, tempLoopField, tempLoopField, % wrapper,, All
                parsedArray[A_index] := tempLoopField
            }else{
                parsedArray[A_index] := A_LoopField
            }
        }            
    }

    return parsedArray
}

; returns true if a character is upper cased
isUpper(c) {
  return (C >= "A") and (C <= "Z")
}

; returns true if a character is lower cased
isLower(c) {
  return (C >= "a") and (C <= "z")
}