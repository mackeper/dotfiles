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

; Copy file as path (only for explorer.exe)
; Alt+Shift+C
!+c::{
    if WinActive("ahk_class CabinetWClass") || WinActive("ahk_class ExploreWClass") {
        Send "+{AppsKey}a"
        ToolTip("Path copied", , , 1)
        Sleep 800
        ToolTip("", , , 1)
    }
}

; Write current date and time
; Alt+Shift+D
!+d:: {
    dt := FormatTime("", "yyyy-MM-dd HH:mm:ss")
    user := A_UserName
    SendText dt "`n" user
}

; ------------ Testing -------------
; Write version
!+v::{
    Send "9.1.0.60649"
    Send "{Tab}"
    Send "TrueBeamDriver2.0.0.60945"
    Send "{Tab}"
    Send "17.2.0.162"
}

; Send "PASSED"
; Alt+Shift+P
!+p:: {
    dt := FormatTime("", "yyyy-MM-dd HH:mm:ss")
    SendText dt "`nPASSED"
}

; Send "FAILED"
; Alt+Shift+F
!+F:: {
    dt := FormatTime("", "yyyy-MM-dd HH:mm:ss")
    SendText dt "`nFAILED"
}
