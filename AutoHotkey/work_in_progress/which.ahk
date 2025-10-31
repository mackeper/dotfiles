#Persistent ; Keep this script running until the user explicitly exits it.

hotkeys := {}
hotkeys["Ctrl+C"] := "Copy"
hotkeys["Ctrl+V"] := "Paste"
hotkeys["Ctrl+X"] := "Cut"
hotkeys["Ctrl+Z"] := "Undo"
hotkeys["Ctrl+Y"] := "Redo"
hotkeys["Ctrl+A"] := "Select All"
hotkeys["Ctrl+S"] := "Save"
hotkeys["Ctrl+O"] := "Open"
hotkeys["Ctrl+N"] := "New"
hotkeys["Ctrl+F"] := "Find"

; https://www.autohotkey.com/board/topic/38882-detect-fullscreen-application/
isActiveWindowFullScreen() {
    WinGet, winID, ID, A
    WinGetActiveTitle, winTitle

	If ( !winID )
		Return false

	WinGet style, Style, ahk_id %WinID%
	WinGetPos ,,,winW,winH, %winTitle%
	Return ((style & 0x20800000) or winH < A_ScreenHeight or winW < A_ScreenWidth) ? false : true
}

CreateGui(hotkeys) {
    if isActiveWindowFullScreen()
        return

    SysGet, Monitor, Monitor
    ScreenWidth := MonitorRight - MonitorLeft
    ScreenHeight := MonitorBottom - MonitorTop

    LineHeight := 30
    GuiWidth := Round(ScreenWidth * 0.98)
    GuiHeight := LineHeight * 5
    GuiX := (ScreenWidth - GuiWidth) // 2
    GuiY := ScreenHeight - GuiHeight - Round(ScreenHeight * 0.01)

    Gui, +LastFound +AlwaysOnTop +ToolWindow -Caption +Border +0x08000000
    Gui, Color, 18191f
    WinSet, Transparent, 220 ; Set transparency level (0-255)
    Gui, Font, s14, Arial Black

    KeyColor := "0xff479c"
    ValueColor := "0xffffff"
    LineWidth := 220
    CurrentRowPos := LineHeight // 2
    CurrentColumnPos := 10
    Counter := 0
    for key, value in hotkeys
    {
        ValueXPos := CurrentColumnPos + 84
        Gui, Add, Text, x%CurrentColumnPos% y%CurrentRowPos% w%LineWidth% h%LineHeight% c%KeyColor%, %key%:
        Gui, Add, Text, x%ValueXPos% y%CurrentRowPos% w%LineWidth% h%LineHeight% c%ValueColor%, %value%
        CurrentRowPos += %LineHeight%
        Counter++
        if (mod(Counter, 4) == 0)
        {
            CurrentColumnPos += LineWidth
            CurrentRowPos := LineHeight // 2
        }
    }

    Gui, Show, w%GuiWidth% h%GuiHeight% x%GuiX% y%GuiY% NoActivate, MyWindow

} 

~ctrl::
    CreateGui(hotkeys)
keywait, ctrl
ToolTip
If WinExist("MyWindow")
{
    Gui, Destroy
    WinClose, MyWindow
}
return

GuiClose:
ExitApp
return
