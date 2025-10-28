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

; Functions
ShowShortcutsGUI(isWorkMode) {
    gui := Gui()
    gui.BackColor := "Black"
    gui.SetFont("s14 cGreen", "Verdana")

    gui.Add("Text",, "Alt+Ctrl+Shift+S: Spotify")
    gui.Add("Text",, "Alt+Ctrl+Shift+K: KeePass")
    gui.Add("Text",, "Alt+Ctrl+Shift+B: Browser")
    gui.Add("Text",, "Alt+Ctrl+Shift+T: Windows Terminal")

    if isWorkMode {
        gui.Add("Text",, "Alt+Ctrl+Shift+O: Outlook")
        gui.Add("Text",, "Alt+Ctrl+Shift+C: Teams")
        gui.Add("Text",, "Alt+Ctrl+Shift+I: Rider")
    } else {
        gui.Add("Text",, "Alt+Ctrl+Shift+G: Steam")
        gui.Add("Text",, "Alt+Ctrl+Shift+C: Discord")
        gui.Add("Text",, "Alt+Ctrl+Shift+I: Visual Studio")
    }

    gui.Show("w400 h400", "Shortcuts Window")
}

OpenOrFocusProgram(programPath, exeName) {
    pid := ProcessExist(exeName)
    if !pid {
        Run(programPath)
    } else {
        WinActivate("ahk_exe " exeName)
    }
}
