#Requires AutoHotkey v2.0
#SingleInstance

; ! → Alt
; ^ → Ctrl
; + → Shift

; ==================================================================
; ===                      Hotstrings                           ===
; ==================================================================
:*:marost@::marost@raysearchlabs.com
:*:marcus.ostling@::marcus.ostling@raysearchlabs.com
:*:mpt@::mpt.ostling@gmail.com
:*:mpt.ostling@::mpt.ostling@gmail.com
:*:ftw@::marcus.ftw94@gmail.com
:*:marcus.ftw94@::marcus.ftw94@gmail.com

!-::SendText "—"

; ==================================================================
; ===                       General                             ===
; ==================================================================

^+!T::ToggleWindowTransparency()

; Track transparency per-window ourselves instead of inferring it from the
; WS_EX_LAYERED extended style bit: WinSetTransparent(255, ...) does not clear
; that bit (only "Off" does), and many modern apps already have it set for
; unrelated reasons (Mica/acrylic effects), so it's not a reliable state check.
global transparentWindows := Map()

ToggleWindowTransparency() {
    global transparentWindows
    hwnd := WinExist("A")
    if !hwnd
        return

    isTransparent := transparentWindows.Has(hwnd) && transparentWindows[hwnd]
    if isTransparent {
        WinSetTransparent("Off", "ahk_id " hwnd)
        transparentWindows[hwnd] := false
    } else {
        WinSetTransparent(180, "ahk_id " hwnd)
        transparentWindows[hwnd] := true
    }
}

ToggleAlwaysOnTop() {
    hwnd := WinExist("A")
    if !hwnd
        return

    WinSetAlwaysOnTop(-1, "ahk_id " hwnd)
    isOnTop := WinGetExStyle("ahk_id " hwnd) & 0x8  ; WS_EX_TOPMOST
    ToolTip(isOnTop ? "Always on top: ON" : "Always on top: OFF", , , 1)
    Sleep 800
    ToolTip("", , , 1)
}

; Reload all scripts
^!r::ReloadAllScripts()

ReloadAllScripts() {
    DetectHiddenWindows true
    for hwnd in WinGetList("ahk_class AutoHotkey") {
        PostMessage 0x111, 65303,, , hwnd  ; 0x111 = WM_COMMAND, 65303 = ID_RELOAD
    }
}

; Generate a GUID, copy it, and paste at cursor
^!g::PasteNewGuid()

PasteNewGuid() {
    guid := ComObject("Scriptlet.TypeLib").GUID
    guid := StrUpper(StrReplace(StrReplace(guid, "{"), "}"))
    PasteTextPreservingClipboard(guid)
}

::mvh::PasteSignature()

PasteSignature() {
    PasteTextPreservingClipboard("
    (LTrim
        Med vänlig hälsning,
        Marcus Östling
        )")
}

; Copy the full path of the selected Explorer item(s) to the clipboard
!+c::CopyExplorerSelectionPath()

CopyExplorerSelectionPath() {
    if !(WinActive("ahk_class CabinetWClass") || WinActive("ahk_class ExploreWClass"))
        return

    paths := GetExplorerSelectionPaths()
    if !paths.Length {
        ToolTip("No item found", , , 1)
        Sleep 800
        ToolTip("", , , 1)
        return
    }

    text := ""
    for path in paths
        text .= (text = "" ? "" : "`r`n") '"' path '"'
    A_Clipboard := text

    ToolTip("Path copied", , , 1)
    Sleep 800
    ToolTip("", , , 1)
}

; Write current date and time
!+d::WriteDateTimeAndUser()

WriteDateTimeAndUser() {
    dt := FormatTime("", "yyyy-MM-dd HH:mm:ss")
    user := A_UserName
    SendText dt "`n" user
}

; Functions
PasteTextPreservingClipboard(text) {
    oldClipboard := ClipboardAll()
    A_Clipboard := text
    ClipWait 1
    Send "^v"
    Sleep 150
    A_Clipboard := oldClipboard
}

; Return the full path of each selected item in the active Explorer window,
; or the current folder's path if nothing is selected
GetExplorerSelectionPaths() {
    paths := []
    activeHwnd := WinActive("A")
    for window in ComObject("Shell.Application").Windows {
        try {
            if (window.HWND != activeHwnd)
                continue
            selected := window.Document.SelectedItems
            if (selected.Count > 0) {
                for item in selected
                    paths.Push(item.Path)
            } else {
                paths.Push(window.Document.Folder.Self.Path)
            }
        }
    }
    return paths
}

; ==================================================================
; ===                       Testing                             ===
; ==================================================================

; Write version
!+v::WriteTestVersions()

WriteTestVersions() {
    Send "9.1.0.60649"
    Send "{Tab}"
    Send "TrueBeamDriver2.0.0.60945"
    Send "{Tab}"
    Send "17.2.0.162"
}

; Send "PASSED"
!+p::WriteTestResult("PASSED")

; Send "FAILED"
!+F::WriteTestResult("FAILED")

WriteTestResult(result) {
    dt := FormatTime("", "yyyy-MM-dd HH:mm:ss")
    SendText dt "`n" result
}

; ==================================================================
; ===                       Pomodoro                            ===
; ==================================================================

global pomodoroEndTick := 0
global pomodoroLabel := ""

StartPomodoro(minutes, label) {
    global pomodoroEndTick, pomodoroLabel
    SetTimer(PomodoroFinished, 0)  ; cancel any running timer first

    pomodoroLabel := label
    pomodoroEndTick := A_TickCount + Integer(minutes * 60000)
    SetTimer(PomodoroFinished, -Integer(minutes * 60000))
    TrayTip(minutes " minutes", label " started", 1)
}

StopPomodoro() {
    global pomodoroEndTick, pomodoroLabel
    if !pomodoroEndTick {
        TrayTip("Nothing to stop", "Pomodoro", 2)
        return
    }

    SetTimer(PomodoroFinished, 0)
    stopped := pomodoroLabel
    pomodoroEndTick := 0
    pomodoroLabel := ""
    TrayTip("Cancelled", stopped, 2)
}

ShowPomodoroStatus() {
    global pomodoroEndTick, pomodoroLabel
    if !pomodoroEndTick {
        TrayTip("No timer running", "Pomodoro", 1)
        return
    }

    remainingMs := pomodoroEndTick - A_TickCount
    if (remainingMs < 0)
        remainingMs := 0
    totalSeconds := Integer(remainingMs // 1000)
    TrayTip(Format("{:02}:{:02} left", totalSeconds // 60, Mod(totalSeconds, 60)), pomodoroLabel, 1)
}

PomodoroFinished() {
    global pomodoroEndTick, pomodoroLabel
    finished := pomodoroLabel
    pomodoroEndTick := 0
    pomodoroLabel := ""

    TrayTip("Time is up", finished, 1)
    SoundBeep(880, 250)
    SoundBeep(660, 250)
}

; ==================================================================
; ===                        Apps                               ===
; ==================================================================

; Auto-detect work vs. private machine from the logged-in Windows account
isWorkMode := (A_UserName = "marost")

; App shortcuts

; Misc apps
OpenBrowser() {
    if isWorkMode
        OpenOrFocusProgram("C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe", "chrome.exe")
    else
        OpenOrFocusProgram(EnvGet("LOCALAPPDATA") "\\Thorium\\Application\\thorium.exe", "thorium.exe")
}
^!+B::OpenBrowser()

OpenMusicOrVault() {
    if isWorkMode
        OpenOrFocusProgram(A_AppData "\\Spotify\\Spotify.exe", "Spotify.exe")
    else
        OpenOrFocusProgram("D:\\Documents\\Software\\Security\\KeePass-2.50\\KeePass.exe", "KeePass.exe")
}
^!+S::OpenMusicOrVault()
;^!+W::{
;        OpenOrFocusProgram("C:\\Program Files\\Microsoft Office\\root\\Office16\WINWORD.EXE", "WINWORD.EXE")
;}

OpenSteam() {
    OpenOrFocusProgram("D:\\Program Files (x86)\\Steam\\Steam.exe", "steam.exe")
}
^!+G::OpenSteam()

; Code apps
OpenTerminal() {
    OpenOrFocusProgram(EnvGet("LOCALAPPDATA") "\\Microsoft\\WindowsApps\\wt.exe", "WindowsTerminal.exe")
}
^!T::OpenTerminal()

OpenCodeEditor() {
    OpenOrFocusProgram("C:\\Program Files\\Microsoft VS Code\\Code.exe", "Code.exe")
}
^!+V::OpenCodeEditor()

OpenIde() {
    if isWorkMode {
        riderPath := FindRiderExecutable()
        if riderPath
            OpenOrFocusProgram(riderPath, "rider64.exe")
        else
            ToolTip("Rider not found under C:\\Program Files\\JetBrains", , , 1)
    } else {
        OpenOrFocusProgram("C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\Common7\\IDE\\devenv.exe", "devenv.exe")
    }
}
^!+I::OpenIde()

; Communication apps
;^!+M::{
;    OpenOrFocusProgram("C:\\Program Files\\Microsoft Office\\root\\Office16\\OUTLOOK.EXE", "OUTLOOK.EXE")
;}
OpenChat() {
    if isWorkMode
        ; Stable AUMID, unlike the versioned WindowsApps path
        OpenOrFocusShellApp("MSTeams_8wekyb3d8bbwe!MSTeamsShortcut", "ms-teams.exe")
    else
        ; Update.exe resolves the current versioned Discord folder
        OpenOrFocusProgram(EnvGet("LOCALAPPDATA") "\\Discord\\Update.exe --processStart Discord.exe", "Discord.exe")
}
^!+C::OpenChat()

; Note taking
OpenWikiIndex() {
    Run 'wt.exe -p "PowerShell" -d "C:\git\wiki" nvim "C:\git\wiki\index.md" "+normal G"'
}
^+W::OpenWikiIndex()

OpenWikiJournal() {
    Run 'wt.exe -p "PowerShell" -d "C:\git\wiki" nvim +MikiJournal "+normal G"'
}
^+J::OpenWikiJournal()

OpenWikiCurrent() {
    Run 'wt.exe -p "PowerShell" -d "' EnvGet("USERPROFILE") '\\OneDrive - RaySearch Laboratories AB\\Marcus\\10_Documents\\05_wiki" nvim "current.md" "+normal G"'
}
^+C::OpenWikiCurrent()

; Functions
OpenOrFocusProgram(programPath, exeName) {
    pid := ProcessExist(exeName)
    if !pid {
        Run(programPath)
    } else {
        WinActivate("ahk_exe " exeName)
    }
}

; Launch or focus a Store/MSIX app by its AUMID
OpenOrFocusShellApp(aumid, exeName) {
    pid := ProcessExist(exeName)
    if !pid {
        Run("shell:AppsFolder\" aumid)
    } else {
        WinActivate("ahk_exe " exeName)
    }
}

; Return the most recently modified subfolder matching a wildcard pattern, or "" if none found
FindNewestDir(pattern) {
    newestPath := ""
    newestTime := ""
    Loop Files, pattern, "D"
    {
        if (newestTime = "" || A_LoopFileTimeModified > newestTime) {
            newestPath := A_LoopFileFullPath
            newestTime := A_LoopFileTimeModified
        }
    }
    return newestPath
}

; Locate rider64.exe under the newest installed Rider version folder.
; Loop Files only supports wildcards in the final path segment, so the
; versioned folder ("JetBrains Rider*") must be resolved before appending
; the fixed "\bin\rider64.exe" suffix.
FindRiderExecutable() {
    riderDir := FindNewestDir("C:\\Program Files\\JetBrains\\JetBrains Rider*")
    if !riderDir
        return ""
    exePath := riderDir "\\bin\\rider64.exe"
    return FileExist(exePath) ? exePath : ""
}

; ==================================================================
; ===                    Command Palette                        ===
; ==================================================================

global paletteCommands := []

AddPaletteCommand(label, action) {
    global paletteCommands
    paletteCommands.Push({label: label, action: action})
}

AddPaletteCommand("App: Browser", OpenBrowser)
AddPaletteCommand("App: Music / Password manager", OpenMusicOrVault)
AddPaletteCommand("App: Steam", OpenSteam)
AddPaletteCommand("App: Windows Terminal", OpenTerminal)
AddPaletteCommand("App: VS Code", OpenCodeEditor)
AddPaletteCommand("App: IDE (Rider / Visual Studio)", OpenIde)
AddPaletteCommand("App: Teams / Discord", OpenChat)
AddPaletteCommand("Wiki: Index", OpenWikiIndex)
AddPaletteCommand("Wiki: Journal", OpenWikiJournal)
AddPaletteCommand("Wiki: Current", OpenWikiCurrent)

AddPaletteCommand("General: Generate GUID", PasteNewGuid)
AddPaletteCommand("General: Paste signature (mvh)", PasteSignature)
AddPaletteCommand("General: Copy Explorer selection path", CopyExplorerSelectionPath)
AddPaletteCommand("General: Insert date/time + username", WriteDateTimeAndUser)
AddPaletteCommand("General: Toggle window transparency", ToggleWindowTransparency)
AddPaletteCommand("General: Toggle always on top", ToggleAlwaysOnTop)
AddPaletteCommand("General: Reload all scripts", ReloadAllScripts)

AddPaletteCommand("Testing: Write versions", WriteTestVersions)
AddPaletteCommand("Testing: Write PASSED", WriteTestResult.Bind("PASSED"))
AddPaletteCommand("Testing: Write FAILED", WriteTestResult.Bind("FAILED"))

AddPaletteCommand("Pomodoro: Start focus (25 min)", StartPomodoro.Bind(25, "Focus"))
AddPaletteCommand("Pomodoro: Start short break (5 min)", StartPomodoro.Bind(5, "Short break"))
AddPaletteCommand("Pomodoro: Start long break (15 min)", StartPomodoro.Bind(15, "Long break"))
AddPaletteCommand("Pomodoro: Show time remaining", ShowPomodoroStatus)
AddPaletteCommand("Pomodoro: Stop timer", StopPomodoro)

; Auto-discover repos so the list stays current without editing this script
OpenRepoInTerminal(path) {
    Run('wt.exe -d "' path '"')
}
OpenRepoInVSCode(path) {
    Run('"C:\\Program Files\\Microsoft VS Code\\Code.exe" "' path '"')
}
OpenRepoInRider(path) {
    riderPath := FindRiderExecutable()
    if riderPath
        Run('"' riderPath '" "' path '"')
    else
        ToolTip("Rider not found under C:\\Program Files\\JetBrains", , , 1)
}
OpenRepoInExplorer(path) {
    Run('explorer.exe "' path '"')
}
Loop Files, "C:\\git\\*", "D"
{
    repoPath := A_LoopFileFullPath
    repoName := A_LoopFileName
    AddPaletteCommand("Repo: " repoName " (Terminal)", OpenRepoInTerminal.Bind(repoPath))
    AddPaletteCommand("Repo: " repoName " (VS Code)", OpenRepoInVSCode.Bind(repoPath))
    AddPaletteCommand("Repo: " repoName " (Rider)", OpenRepoInRider.Bind(repoPath))
    AddPaletteCommand("Repo: " repoName " (Explorer)", OpenRepoInExplorer.Bind(repoPath))
}

; Ctrl+Alt+Space -> Open the command palette
^!Space::ShowCommandPalette()

; Score how well pattern fuzzy-matches text as an ordered subsequence
; (like VS Code's Ctrl+P). Returns -1 if pattern isn't a subsequence of text.
FuzzyMatchScore(text, pattern) {
    textLower := StrLower(text)
    patternLower := StrLower(pattern)
    searchStart := 1
    consecutive := 0
    score := 0

    Loop StrLen(patternLower) {
        ch := SubStr(patternLower, A_Index, 1)
        pos := InStr(textLower, ch, , searchStart)
        if !pos
            return -1

        gap := pos - searchStart
        consecutive := (gap = 0) ? consecutive + 1 : 0

        matchScore := 10 + consecutive * 5 - gap
        prevChar := (pos = 1) ? "" : SubStr(textLower, pos - 1, 1)
        if (pos = 1 || !RegExMatch(prevChar, "[a-z0-9]"))
            matchScore += 10  ; bonus for matching at a word boundary

        score += matchScore
        searchStart := pos + 1
    }

    return score
}

; Simple insertion sort by descending score (palette lists are short)
SortByScoreDesc(matches) {
    Loop matches.Length - 1 {
        i := A_Index + 1
        current := matches[i]
        j := i - 1
        while (j >= 1 && matches[j].score < current.score) {
            matches[j + 1] := matches[j]
            j -= 1
        }
        matches[j + 1] := current
    }
}

ShowCommandPalette() {
    global paletteCommands
    chosen := "", guiVisible := true

    guia := Gui("+AlwaysOnTop -Caption +Border", "Command Palette")
    guia.MarginX := 20
    guia.MarginY := 10
    guia.SetFont("s10")
    guia.BackColor := "1e1e1e"

    guia.AddText("w500 Center cWhite", "Type to filter commands:")
    filterEdit := guia.AddEdit("w500")

    guia.SetFont("s12 Bold")
    guia.AddText("w500 Background2d2d2d cWhite", "Command")
    guia.SetFont("s10")
    commandList := guia.AddListView("w500 h400 -Multi -Hdr Background252525 cWhite", ["Command"])
    commandList.ModifyCol(1, 480)
    guiHwnd := guia.Hwnd

    UpdateList("")
    UpdateList(filterText) {
        commandList.Delete()
        if (filterText = "") {
            for cmd in paletteCommands
                commandList.Add("", cmd.label)
        } else {
            matches := []
            for cmd in paletteCommands {
                score := FuzzyMatchScore(cmd.label, filterText)
                if (score >= 0)
                    matches.Push({label: cmd.label, score: score})
            }
            SortByScoreDesc(matches)
            for m in matches
                commandList.Add("", m.label)
        }
        if (commandList.GetCount() > 0)
            commandList.Modify(1, "Select Focus")
    }

    filterEdit.OnEvent("Change", (*) => UpdateList(filterEdit.Value))
    commandList.OnEvent("DoubleClick", SelectCommand)

    SelectCommand(*) {
        rowNum := commandList.GetNext(0)
        if (rowNum) {
            chosen := commandList.GetText(rowNum, 1)
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
        rowNum := commandList.GetNext(0)
        if (!rowNum && commandList.GetCount() > 0)
            rowNum := 1
        if (rowNum) {
            chosen := commandList.GetText(rowNum, 1)
            CleanupAndClose()
        }
    }

    CleanupAndClose() {
        guiVisible := false
        HotIfWinActive("ahk_id " guiHwnd)
        Hotkey("Enter", "Off")
        Hotkey("Down", "Off")
        Hotkey("Up", "Off")
        HotIfWinActive()
        guia.Destroy()
    }

    HandleDown(*) {
        totalRows := commandList.GetCount()
        if (totalRows = 0)
            return
        if (ControlGetFocus(guia) = filterEdit.Name) {
            commandList.Focus()
            commandList.Modify(1, "Select Focus")
            return
        }
        currentRow := commandList.GetNext(0)
        if (currentRow && currentRow < totalRows)
            commandList.Modify(currentRow + 1, "Select Focus Vis")
    }

    HandleUp(*) {
        totalRows := commandList.GetCount()
        if (totalRows = 0)
            return
        currentRow := commandList.GetNext(0)
        if (currentRow && currentRow > 1)
            commandList.Modify(currentRow - 1, "Select Focus Vis")
        else if (currentRow = 1)
            filterEdit.Focus()
    }

    guia.Show("AutoSize Center")
    filterEdit.Focus()

    while (guiVisible)
        Sleep 50

    if (chosen) {
        for cmd in paletteCommands {
            if (cmd.label = chosen) {
                cmd.action.Call()
                break
            }
        }
    }
}

