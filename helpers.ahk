#Include, %A_ScriptDir%\mh.ahk
global StoredClip = ; global Clipboard variable
SendMode, Input
#SingleInstance, force

/*
* Debugging and helpers
*/
; ----------------------------------------------------------------------------
;; Used for debugging/creating window specific hotkeys
;; displays all active windows (with ID, class and title) in a popup

getText(){
    storeClipboard(true)
    Sleep, 250
    textToGet =
    Send, {ShiftDown}{Home}{ShiftUp}
    SendInput , ^x
    ClipWait 1, 1
    textToGet = %Clipboard%
    restoreClipboard(true)

    return textToGet
}

^+!l::	;Ctrl + Shift + Alt + l
    WinGet, id, list,,, Program Manager
    Loop, %id%
    {
        this_id := id%A_Index%
        WinActivate, ahk_id %this_id%
        WinGetClass, this_class, ahk_id %this_id%
        WinGetTitle, this_title, ahk_id %this_id%
        MsgBox, 4, , Visiting All Windows`n%a_index% of %id%`nID: %this_id%`nCLASS: %this_class%`nTITLE: %this_title%`n`nContinue?
        ifMsgBox, NO, break
    }
Return

;; inserts section separator if in sublime, in mh.ahk
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
    Send, ^c   ; copy selected content
    ClipWait, 1, "text"
    length := StrLen(Clipboard)
    MsgBox, 0, Character length, %length% characters selected, 5
    restoreClipboard(true)
Return

appendToClipboard(){
    clipBreak = |

    Send, ^c
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
                MsgBox, found wrapper
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