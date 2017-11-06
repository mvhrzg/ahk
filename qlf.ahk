;; [start] Globals
global StoredClip = ; global Clipboard variable
;; [end] Globals

; ----------------------------------------------------------------------------
; This is your main hotkey. Others functions are helpers
/**
* This can be used in the following ways:
* 1: copy entire test block (With Call TEST(), etc - supports multiple lines)
* 2: Copy each test name with quotes (tests should be on different lines)
* 3: copy each test name without quotes (tests should be on different lines)
*/
; ----------------------------------------------------------------------------
#ifWinActive ahk_class SWT_Window0
;; build single or multiple test block(s)
^b::   ; Ctrl + b
    storeClipboard(false)
    builtBlock = ;
    ; replace eclipse's line endings to make it easier to loop through clipboard
    StringReplace, Clipboard, Clipboard, `r`n`r`n, `n, All
    ; if it starts with "Call TEST(" and we have more than one, this would mean
    ; the user copied a whole block of tests (of at least 2)
    if (InStr(Clipboard, "Call TEST(", true, 1, 2)) {
        Loop, Parse, Clipboard, `n
        {
    		; find the positions of the 1st and 2nd quotes on each line
            firstQuote := InStr(A_LoopField, """",, 1)
            secondQuote := InStr(A_LoopField, """",, firstQuote, 2) 
            ; if we have quotes, parse out the test name
            if (firstQuote && secondQuote) {
                thisTest := SubStr(A_LoopField, firstQuote+1, secondQuote-(firstQuote+1))
                builtBlock .= _buildTestBlock(thisTest)
            }
        }
    } else{
    	; if it doesn't start with "Call TEST(", the user may have just copied the test names
        firstQuote := InStr(Clipboard, """",, 1)
        secondQuote := InStr(Clipboard, """",, firstQuote, 2)
        ; parse out test names (i.e.: remove quotes)
        if (firstQuote && secondQuote) {
            thisTest := SubStr(Clipboard, firstQuote+1, secondQuote-(firstQuote+1))
            builtBlock .= _buildTestBlock(thisTest)
            ; MsgBox, builtBlock = %builtBlock%
        } else{
        	; if we don't have quotes, no parsing needed
            builtBlock := _buildTestBlock(Clipboard)
        }
    }

    ; assign built string to clipboard (and clear clip first)
    assignClipboard(true, builtBlock)
    paste()
    sleep(250)
    restoreClipboard(true)
Return
#ifWinActive


; ----------------------------------------------------------------------------
; helpers
; ----------------------------------------------------------------------------

; clears clipboard
clearClipboard() {
     Clipboard = ; clear clipboard
     sleep(100)
}

; stores the clipboard in a global var so we can restore it after the operation
storeClipboard(clearAfterStore){
    StoredClip := Clipboard
    if(clearAfterStore){
        clearClipboard()
    }
}

; assigns contents of variable to clipboard
assignClipboard(clearFirst, variable := ""){
    if (clearFirst){
        clearClipboard()
    }
    Clipboard := variable
}

; restores clipboard to previous stored state
restoreClipboard(clearBeforeRestore){
    if (clearBeforeRestore){
        clearClipboard()
    }
    assignClipboard(true, StoredClip)
    ; Clipboard := StoredClip ; alternate
}

paste(){
    Send, ^v
}

sleep(milliseconds){
    Sleep, % milliseconds
}

; build the entire formatted string for the test stub and returns it
; assignable to clipboard
_buildTestBlock(testName){
    StringUpper, testName, testName
    testBlock = ;
    testBlock = #**`r`n#* `r`n#*!`r`n
    testBlock .= "Subprog " . testName  . " : Call CLEANUP from XX1S_QLF`r`n"
    testBlock .= "  # setup`r`n"
    testBlock .= "  # pre-condition`r`n"
    testBlock .= "  # action`r`n"
    testBlock .= "  # assertion`r`n"
    testBlock = %testBlock%  Call CHECK_EQUAL(1, 0, "not implemented") From XX1S_QLF
    testBlock .="`r`n"
    testBlock .= "  # cleanup`r`n"
    testBlock .= "End`r`n`r`n"

    return testBlock
}
