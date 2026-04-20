; ^ = Ctrl
; ! = Alt
; + = Shift
; # = Win

#SingleInstance
#Requires AutoHotkey v2.0

; Define snippets globally
global snippets := Map(
    "1", "Impact analysis tests",
)

global promptTexts := Map(
    "1", "
    (RTrim0
      * Regression tests
        * Manual
        * Automatic
      * Verification tests
        * Manual
        * Automatic
    )",
)

:*::snippets::
{
    oldClip := A_Clipboard
    global chosen := "", guiVisible := true

    guia := Gui("+AlwaysOnTop -Caption +Border", "Prompt Menu")
    guia.MarginX := 20
    guia.MarginY := 10
    guia.SetFont("s10")
    guia.BackColor := "1e1e1e"

    guia.AddText("w300 Center cWhite", "Type to filter snippets:")
    filterEdit := guia.AddEdit("w300")

    guia.SetFont("s12 Bold")
    headerText := guia.AddText("w300 Background2d2d2d cWhite", "Key    Prompt")
    guia.SetFont("s10")
    promptList := guia.AddListView("w300 h200 -Multi -Hdr Background252525 cWhite", ["Key", "Prompt"])

    promptList.ModifyCol(1, 40)
    promptList.ModifyCol(2, 250)
    guiHwnd := guia.Hwnd

    UpdateList("")
    UpdateList(filterText) {
        promptList.Delete()
        for key, desc in snippets {
            if (filterText = "" || InStr(desc, filterText) || InStr(key, filterText))
                promptList.Add("", key, desc)
        }
        if (promptList.GetCount() > 0)
            promptList.Modify(1, "Select Focus")
    }

    filterEdit.OnEvent("Change", (*) => UpdateList(filterEdit.Value))
    promptList.OnEvent("DoubleClick", SelectPrompt)

    SelectPrompt(*) {
        rowNum := promptList.GetNext(0)
        if (rowNum) {
            chosen := promptList.GetText(rowNum, 1)
            CleanupAndClose()
        }
    }

    guia.OnEvent("Escape", HandleEscape)
    HandleEscape(*) {
        CleanupAndClose()
    }

    HotIfWinActive("ahk_id " guiHwnd)
    Hotkey("Enter", HandleEnter)
    Hotkey("Down", HandleDown)
    Hotkey("Up", HandleUp)
    HotIfWinActive()

    HandleEnter(*) {
        rowNum := promptList.GetNext(0)
        if (!rowNum && promptList.GetCount() > 0)
            rowNum := 1
        if (rowNum) {
            chosen := promptList.GetText(rowNum, 1)
            CleanupAndClose()
        }
    }

    CleanupAndClose() {
        global guiVisible
        guiVisible := false
        HotIfWinActive("ahk_id " guiHwnd)
        Hotkey("Enter", "Off")
        Hotkey("Down", "Off")
        Hotkey("Up", "Off")
        HotIfWinActive()
        guia.Destroy()
    }

    HandleDown(*) {
        totalRows := promptList.GetCount()
        if (totalRows = 0)
            return

        if (ControlGetFocus(guia) = filterEdit.Name) {
            promptList.Focus()
            promptList.Modify(1, "Select Focus")
            return
        }

        currentRow := promptList.GetNext(0)
        if (currentRow && currentRow < totalRows) {
            promptList.Modify(currentRow + 1, "Select Focus Vis")
        }
    }

    HandleUp(*) {
        totalRows := promptList.GetCount()
        if (totalRows = 0)
            return

        currentRow := promptList.GetNext(0)
        if (currentRow && currentRow > 1) {
            promptList.Modify(currentRow - 1, "Select Focus Vis")
        }
        else if (currentRow = 1) {
            filterEdit.Focus()
        }
    }

    guia.Show("AutoSize Center")
    filterEdit.Focus()

    while (guiVisible)
        Sleep 50

    if (chosen) {
        A_Clipboard := promptTexts[chosen]
        Sleep 50
        Send "^v"
        Sleep 100
    }

    A_Clipboard := oldClip
}
