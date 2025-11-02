#SingleInstance
isWorkMode := true

; GUIs
^!+?::ShowShortcutsGUI(isWorkMode)

; App shortcuts

; Misc apps
^!+B::{
    if isWorkMode {
        OpenOrFocusProgram("C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe", "chrome.exe")
    } else {
        OpenOrFocusProgram("C:\\Users\\macke\\AppData\\Local\\Thorium\\Application\\thorium.exe", "thorium.exe")
    }
}

^!+S::{
    if isWorkMode {
        OpenOrFocusProgram("C:\\Users\\macke\\AppData\\Roaming\\Spotify\\Spotify.exe", "Spotify.exe")
    } else {
        OpenOrFocusProgram("D:\\Documents\\Software\\Security\\KeePass-2.50\\KeePass.exe", "KeePass.exe")
    }
}
^!+W::{
        OpenOrFocusProgram("C:\\Program Files\\Microsoft Office\\root\\Office16\WINWORD.EXE", "WINWORD.EXE")
}



^!+G::{
    OpenOrFocusProgram("D:\\Program Files (x86)\\Steam\\Steam.exe", "steam.exe")
}

; Code apps
^!+T::{
    OpenOrFocusProgram("C:\\Users\\macke\\AppData\\Local\\Microsoft\\WindowsApps\\wt.exe", "WindowsTerminal.exe")
}
^!+V::{
    OpenOrFocusProgram("C:\\Program Files\\Microsoft VS Code\\Code.exe", "Code.exe")
}
^!+I::{
    if isWorkMode {
        OpenOrFocusProgram("C:\\Program Files\\JetBrains\\JetBrains Rider 2021.2.2\\bin\\rider64.exe", "rider64.exe")
    } else {
        OpenOrFocusProgram("C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\Common7\\IDE\\devenv.exe", "devenv.exe")
    }
}

; Communication apps
^!+M::{
    OpenOrFocusProgram("C:\\Program Files\\Microsoft Office\\root\\Office16\\OUTLOOK.EXE", "OUTLOOK.EXE")
}
^!+C::{
    if isWorkMode {
        OpenOrFocusProgram("C:\\Program Files\\WindowsApps\\MSTeams_25044.2208.3471.2155_x64__8wekyb3d8bbwe\\ms-teams.exe", "ms-teams.exe")
    } else {
        OpenOrFocusProgram("C:\\Users\\macke\\AppData\\Local\\Discord\\app-1.0.9151\\Discord.exe", "Discord.exe")
    }
}

; Note taking
^+W::{
    Run 'wt.exe -p "PowerShell" -d "C:\git\wiki" nvim +MikiIndex "+normal G"'
}
^+J::{
    Run 'wt.exe -p "PowerShell" -d "C:\git\wiki" nvim +MikiJournal "+normal G"'
}
^+C::{
    Run 'wt.exe -p "PowerShell" -d "C:\git\wiki" nvim +MikiCurrent "+normal G"'
}

; Functions
ShowShortcutsGUI(isWorkMode) {
    shortcutGui := Gui()
    shortcutGui.BackColor := "Black"
    shortcutGui.SetFont("s14 cGreen", "Verdana")

    shortcutGui.Add("Text",, "Alt+Ctrl+Shift+S: Spotify")
    shortcutGui.Add("Text",, "Alt+Ctrl+Shift+K: KeePass")
    shortcutGui.Add("Text",, "Alt+Ctrl+Shift+B: Browser")
    shortcutGui.Add("Text",, "Alt+Ctrl+Shift+T: Windows Terminal")

    if isWorkMode {
        shortcutGui.Add("Text",, "Alt+Ctrl+Shift+O: Outlook")
        shortcutGui.Add("Text",, "Alt+Ctrl+Shift+C: Teams")
        shortcutGui.Add("Text",, "Alt+Ctrl+Shift+I: Rider")
    } else {
        shortcutGui.Add("Text",, "Alt+Ctrl+Shift+G: Steam")
        shortcutGui.Add("Text",, "Alt+Ctrl+Shift+C: Discord")
        shortcutGui.Add("Text",, "Alt+Ctrl+Shift+I: Visual Studio")
    }

    shortcutGui.Show("w400 h400", "Shortcuts Window")
}

OpenOrFocusProgram(programPath, exeName) {
    pid := ProcessExist(exeName)
    if !pid {
        Run(programPath)
    } else {
        WinActivate("ahk_exe " exeName)
    }
}
