#Include, %A_ScriptDir%\eclipse.ahk
SendMode, Input
#SingleInstance, force

;; instance text helper
_instance(contents){
    StringLeft, flag, contents, 1, 1  ; get XX1B or XX3F code
    if (flag = 1)
        code = XX1B
    else if (flag = 3)
        code = XX3F
    else if (flag != 1 and flag != 3){
        Return [""]
    }
    dash := InStr(contents, "-",, 2)    ; if we find a dash, it means we want the instance name to be different than its abbreviation
    if (dash > 0){
        name := SubStr(contents, (dash+1))
        StringUpper, name, name
        abbrevLength := (StrLen(contents) - StrLen(flag) - StrLen(name) - 1) ; length of whole string - length of flag (1) - length of name (?) - 1 (dash length)
    }else{
        abbrevLength := (StrLen(contents) - StrLen(flag) - StrLen(name)) ; length of whole string - length of flag (1) - length of name (?)
    }
        
    StringMid, abbrev, contents, 2, abbrevLength	; get abbreviation
    StringUpper, abbrev, abbrev                         ; set abbreviation to upper case
    array := [code, abbrev, name]

    Return array
}

;; qlf text helper
_qlf(contents){
    StringLeft, flag, contents, 1                       	; get the activity code flag
    if (flag = 1)
        code = QLFXX1B_XX1B
    else if (flag = 2)
        code = QLFXX1S_
    else if (flag = 3)
        code = QLFXX3F_XX3F
    else if (flag != 1 and flag != 2 and flag != 3)
        Return [""]
    StringMid, abbrev, contents, 2, strlen(contents)-1,     ; get the entity/script name/abbreviation
    StringUpper, abbrev, abbrev
    array := [code, abbrev]
    Return array
}

_freeGroup(code){
    Send, FreeGroup %code% : Kill %code%
}

_buildTestBlock(testName){
    StringUpper, testName, testName
    testBlock = ;
    testBlock = #**`r`n#* `r`n#*!`r`n
    testBlock = %testBlock%Subprog %testName% : Call CLEANUP from XX1S_QLF
    testBlock = %testBlock%`r`n
    testBlock = %testBlock%  # setup
    testBlock = %testBlock%  # pre-condition
    testBlock = %testBlock%  # action
    testBlock = %testBlock%  # assertion
    testBlock = %testBlock%  Call CHECK_EQUAL(1, 0, "not implemented") From XX1S_QLF
    testBlock = %testBlock%  # cleanup
    testBlock = %testBlock%End

    assignClipboard(false, testBlock)
    ; Send, {Enter Down}{Enter Up}{Tab Down}{Tab Up}
    ; Send, {#} setup{Enter Down}{Enter Up}
    ; Send, {#} pre-condition{Enter Down}{Enter Up}
    ; Send, {#} action{Enter Down}{Enter Up}
    ; Send, {#} assertion{Enter Down}{Enter Up}
    ; Send, Call CHECK_EQUAL(1,0, "test not implemented") From XX1S_QLF{Enter Down}{Enter Up}
    ; Send, {#} cleanup{Enter Down}{Enter Up}

    ; Send, {Home}End
    ; Send, {NumpadUp 8}

    ; Gosub, ^.

    ; Send, {F7 Down}{F7 Up}
    ; Send, {LControl Up}
}