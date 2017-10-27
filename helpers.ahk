#Include, %A_ScriptDir%\mh.ahk
SendMode, Input
#SingleInstance, force
;; [start] Globals
global StoredClip = ; global Clipboard variable
;; [end] Globals

/*
* Debugging and helpers: used for debugging/creating window specific hotkeys
*/
; ----------------------------------------------------------------------------

copy(){
    ; Send, {LControl Down}{c Down}
    ; Send, {c Up}{LControl Up}
    Send, ^c
    ClipWait, 1, 1
}

paste(){
    Send, ^v
    ; Send, {LControl Down}{v Down}
    ; Send, {v Up}{LControl Up}
}

cut(){
    Send, {LControl Down}{x Down}
    Send, {x Up}{LControl Up}
    ClipWait, 1, 1
}

sleep(milliseconds){
    Sleep, % milliseconds
}

getText(callRestoreClipboard){
    storeClipboard(true)
    sleep(250)
    textToGet =
    Send, {ShiftDown}{Home}{ShiftUp}
    cut()
    ClipWait 1, 1
    textToGet = %Clipboard%
    if (callRestoreClipboard){
        restoreClipboard(true)
    }

    return textToGet
}

;; displays all active windows (with ID, class, title and text) in a popup
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

::-ascii::
toAscii := getText(true)
Loop % StrLen(toAscii) {
    character := SubStr(toAscii, A_Index, 1)
    number := Asc(character)
    Send, %number%
}
Return

;; inserts section separator if in sublime
#ifWinActive ahk_class PX_WINDOW_CLASS
^1::	;Ctrl + 1
	Send, {Enter}
	Send, ^/   ;Ctrl + / 
	Send, {- 76}
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

appendToClipboard(appendage) {
    clipBreak = |

    if (!StoredClip){   ; 1. StoredClip is empty
        storeClipboard(false)
        StoredClip := clipBreak . appendage
    }
    else{
        StoredClip := StoredClip . clipBreak . appendage
    }
    assignClipboard(false, StoredClip)
}

clearClipboard() {
     Clipboard = ; clear clipboard
     sleep(100)
}

storeClipboard(clearAfterStore){
    StoredClip := Clipboard
    if(clearAfterStore){
        clearClipboard()
    }
}

restoreClipboard(clearBeforeRestore){
    if (clearBeforeRestore){
        clearClipboard()
    }
    Clipboard := StoredClip
}

assignClipboard(clearFirst, variable := ""){
    if (clearFirst){
        clearClipboard()
    }
    Clipboard := variable
}

parseStringToArray(string, delimiter, wrapper := 0){
    parsedArray := Object()
    StringReplace, string, string, +, {+}, All
    StringReplace, string, string, (, {(}, All
    StringReplace, string, string, ), {)}, All
    ; MsgBox, % "wrapper = " . wrapper
    if (!wrapper){
        Loop, Parse, string, %delimiter%
        {
            parsedArray[A_index] := A_LoopField
        }
    }else{
        MsgBox, yes wrapper
        Loop, Parse, string, % delimiter
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
                MsgBox, % "parsedArray[A_index] = " . parsedArray[A_Index]
                MsgBox, % "A_LoopField = " . A_LoopField
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