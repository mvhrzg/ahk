#SingleInstance force
; #Include, %A_ScriptDir%\main.ahk

;; paste MAKEs as REMOVEs
^+r::   ; Ctrl + Shift + r
    StringCaseSense, On
    StringReplace, clipboard, clipboard, MAKE, REMOVE, All  ; replace MAKE with REMOVE
    StringCaseSense, Off

    prevClip := Clipboard   ; save previous clip

    StringReplace, Clipboard, Clipboard, `r`n`r, `n, All                ; remove LF
    ; StringReplace, Clipboard, Clipboard, XX1S_QLF, EOF, All                ; remove LF

    ; StringSplit, linesArray, Clipboard, XX1S_QLF,
    qlf = "QLF"
    StringReplace, OutputVar, InputVar, SearchText [, ReplaceText, All]
    StringReplace, Clipboard, Clipboard, XX1S_QLF, XX1S_QLF, UseErrorLevel
    MsgBox, %ErrorLevel%

    ; Loop, Parse, clipboard, qlf
    Loop, Parse, Clipboard, qlf`r
        var := a_index
        inString := InStr(clipboard, "PROJECT=")    ; look for PROJECT=
        If (inString > 0)   ; if string is found
        {
            ; find second occurrence of +, starting at where PROJECT= was found + 1
            findSecondPlus := InStr(clipboard, "+",, inString, 2)
            If (findSecondPlus > 0) ; if a second + is found
            {
                beginningString := SubStr(clipboard, 1, (findSecondPlus-1))   ; build the beginning of the string until the character before second +
                findEnd := InStr(clipboard, ") From XX1S_QLF", true, findSecondPlus) ; find the end of the string -- returns position of )
                endingString := SubStr(clipboard, findEnd) ; extract the end of the make call
                clipboard = ; clear clipboard
                clipboard := beginningString . endingString
                MsgBox, %clipboard%
                Sleep, 25
            }
        }
    MsgBox, % "number of lines =" . var
    ; }
    ; paste the string
    SendInput, ^v
    Sleep, 50
    Clipboard := prevClip
Return


^+c:: ; Ctrl + Shift + c
    ; append lines to the clipboard -- 
    ; if c typed
        ; clear Clipboard
    ; Else
        ; store Clipboard
        ; copy selected Text
        ; a
    Input, clear, L2 T1, {Enter},
    If (clear = "c")
        ; clearClip()
    ; if (clear = "c"){
    ;     Clipboard = ;
    ; }else{
        if (!saved){
            SendInput, ^c
            ; MsgBox, saved is empty
            saved = %Clipboard%
            Clipboard = ;
        }else{
            ; MsgBox, saved not empty
            SendInput, ^c
            ClipWait, 1, 1
            ; MsgBox, saved is not empty:`n%saved%
            saved = %saved%`n%Clipboard%
            MsgBox, saved = %saved%`nClip = %Clipboard%
            Clipboard = ;
            ; SendInput, ^c
            ; saved = %saved%`n%Clipboard%
            ; Clipboard = ;
        }
    ; }

    ; MsgBox, %clipboard%
    ; Loop, Parse, saved, `n
    ; {
    ;     MsgBox 4, ,Word %A_Index% is %A_LoopField%`n`nContinue?
    ;     IfMsgBox, No, break
    ; }
    ; SendInput, ^c
    ; Clipboard := saved . "`n" . Clipboard
    ; SendInput, ^v
Return