#Include, %A_ScriptDir%\main.ahk
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
    ClipWait, 0, 1
}

cut(){
    Send, {LControl Down}{x Down}
    Send, {x Up}{LControl Up}
    ClipWait, 1, 1
    sleep(250)
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
    textToGet := Clipboard
    if (callRestoreClipboard){
        restoreClipboard(true)
    }

    return textToGet
}

;; count selected characters, display number
^#c::   ; Ctrl + Win + c
    storeClipboard(true)
    copy()   ; copy selected content
    ClipWait, 1, "text"
    length := StrLen(Clipboard)
    MsgBox, 0, Character length, %length% characters selected, 5
    restoreClipboard(true)
Return

;; count selected characters, return number
countCharacters(){
    selectedText := getText(true)
    return StrLen(selectedText)
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

; replaces selected text with string of ascii numbers for each character
::-ascii::  ; auto-complete -ascii
toAscii := getText(true)
Loop % StrLen(toAscii) {
    character := SubStr(toAscii, A_Index, 1)
    number := Asc(character)
    Send, %character%{Space}%number%{Space}
}
Return

; returns ascii number of character passed in
ascii(character){
    return Asc(character)
}

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
    assignClipboard(true, StoredClip)
}

assignClipboard(clearFirst, variable := "") {
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
    StringCaseSense, On
    return (c >= "A") && (c <= "Z")
}

; returns true if a character is lower cased
isLower(c) {
    ; StringCaseSense, On
    return (c >= "a") && (c <= "z")
}




/*
* Helpers to replace characters
*/
; ----------------------------------------------------------------------------
replaceWhatMsg:
    continue := false
    InputBox, replaceWhat,, Replace this:
    if (ErrorLevel) {
        Goto, cancel
    } else {
        if replaceWhat Is Number
        {
            Gosub, whatConvert
        } else {
            Gosub, replaceWhatMsgLiteral
        }
    }
Return

whatConvert:
    SetTimer, ChangeButtonNames, 50 
    MsgBox, 4, Literal or Conversion, Is this a literal number or a character conversion?
    IfMsgBox, Yes                   ; literal
        Gosub, replaceWhatMsgLiteral
    Else IfMsgBox, No               ; conversion
        Gosub, replaceWhatMsgConvert
Return

replaceWhatMsgLiteral:
    MsgBox, 3,,  Replace `"%replaceWhat%`". Is this correct?
    IfMsgBox, Yes
        continue := true
    Else IfMsgBox, No
        Gosub, replaceWhatMsg
Return

replaceWhatMsgConvert:
    replaceWhat := Chr(replaceWhat)
    MsgBox, 3,,  Replace `"%replaceWhat%`". Is this correct?
    IfMsgBox, Yes
        continue := true
    Else IfMsgBox, No
        Gosub, replaceWhatMsg
Return

replaceWithMsg:
    continue := false
    InputBox, replaceWith,, Replace `"%replaceWhat%`" with:
    if (ErrorLevel) {
        Goto, cancel
    } else {
        if replaceWith Is Number
        {
            Gosub, withConvert
        } else {
            Gosub, replaceWithMsgLiteral
        }
    }
Return

withConvert:
    SetTimer, ChangeButtonNames, 50 
    MsgBox, 4, Literal or Conversion, Is this a literal number or a character conversion?
    IfMsgBox, Yes                   ; literal
        Gosub, replaceWithMsgLiteral
    Else IfMsgBox, No               ; conversion
        Gosub, replaceWithMsgConvert

Return

replaceWithMsgLiteral:
    MsgBox, 3,,  Replace `"%replaceWhat%`" with `"%replaceWith%`". Is this correct?
    IfMsgBox, Yes
        continue := true
    Else IfMsgBox, No
        Gosub, replaceWithMsg
Return

replaceWithMsgConvert:
    replaceWith := Chr(replaceWith)
    MsgBox, 3,,  Replace `"%replaceWhat%`" with `"%replaceWith%`". Is this correct?
    IfMsgBox, Yes
        continue := true
    Else IfMsgBox, No
        Gosub, replaceWithMsg
Return

cancel:
    MsgBox, inside cancel. Stored = %StoredClip%
    restoreClipboard(false)
    paste()
Return

/*
* Helper to change MsgBox buttons
*/
; ----------------------------------------------------------------------------

ChangeButtonNames: 
    IfWinNotExist, Literal or Conversion
        return  ; Keep waiting.
    SetTimer, ChangeButtonNames, off 
    WinActivate 
    ControlSetText, Button1, &Literal
    ControlSetText, Button2, &Conversion 
return
; ----------------------------------------------------------------------------