#Requires AutoHotkey v2.0
#SingleInstance

; ! → Alt
; ^ → Ctrl
; + → Shift

; ---- Hotstrings ----
:*:marost@::marost@raysearchlabs.com
:*:marcus.ostling@::marcus.ostling@raysearchlabs.com
:*:mpt@::mpt.ostling@gmail.com
:*:mpt.ostling@::mpt.ostling@gmail.com
:*:ftw@::marcus.ftw94@gmail.com
:*:marcus.ftw94@::marcus.ftw94@gmail.com


^!T::{  ; Ctrl + Alt + T
    ExStyle := WinGetExStyle("A")
    if (ExStyle & 0x80000)
        WinSetTransparent(255, "A")  ; Fully opaque
    else
        WinSetTransparent(180, "A")  ; Semi-transparent
}

; Reload all scripts
^!r:: {  ; Ctrl + Alt + R
    DetectHiddenWindows true
    WinGetList("ahk_class AutoHotkey")  ; Get all AutoHotkey script windows
    for hwnd in WinGetList("ahk_class AutoHotkey") {
        PostMessage 0x111, 65303,, , hwnd  ; 0x111 = WM_COMMAND, 65303 = ID_RELOAD
    }
}

; Ctrl+Alt+G -> Generate a new GUID (uppercase, without braces), copy it to clipboard, and paste at cursor
^!g:: {
    old_clipboard := A_Clipboard
    guid := ComObject("Scriptlet.TypeLib").GUID
    guid := StrUpper(StrReplace(StrReplace(guid, "{"), "}"))
    A_Clipboard := guid
    Send "^v"
    Sleep 100
    A_Clipboard := old_clipboard
}

::mvh::{
    old_clipboard := A_Clipboard
    A_Clipboard := "
    (LTrim
        Med vänlig hälsning,
        Marcus Östling
        )"
    Send "^v"
    Sleep 100
    A_Clipboard := old_clipboard
}

