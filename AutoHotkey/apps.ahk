isWorkMode := false

; GUIs
^!+?::ShowShortcutsGUI(isWorkMode)

; App shortcuts


; Misc apps
F13::isWorkMode
    ? OpenOrFocusProgram("C:\Program Files (x86)\Google\Chrome\Application\chrome.exe", "chrome.exe")
    : OpenOrFocusProgram("C:\Users\macke\AppData\Local\Thorium\Application\thorium.exe", "thorium.exe")

F14::isWorkMode
    ? OpenOrFocusProgram("C:\Users\macke\AppData\Roaming\Spotify\Spotify.exe", "Spotify.exe")
    : OpenOrFocusProgram("D:\Documents\Software\Security\KeePass-2.50\KeePass.exe", "KeePass.exe")

F15::isWorkMode
    ? OpenOrFocusProgram("C:\Users\marost\AppData\Roaming\Spotify\Spotify.exe", "Spotify.exe")
    : OpenOrFocusProgram("C:\Users\macke\AppData\Roaming\Spotify\Spotify.exe", "Spotify.exe")

F16::isWorkMode
    ? OpenOrFocusProgram("C:\Users\marost\AppData\Roaming\Spotify\Spotify.exe", "Spotify.exe")
    : OpenOrFocusProgram("D:\Program Files (x86)\Steam\Steam.exe", "steam.exe")

; Code apps
F17::isWorkMode
    ? OpenOrFocusProgram("C:\Users\marost\AppData\Local\Microsoft\WindowsApps\wt.exe", "WindowsTerminal.exe")
    : OpenOrFocusProgram("C:\Users\macke\AppData\Local\Microsoft\WindowsApps\wt.exe", "WindowsTerminal.exe")

F18::isWorkMode
    ? OpenOrFocusProgram("C:\Program Files\Microsoft VS Code\Code.exe", "Code.exe")
    : OpenOrFocusProgram("D:\Program Files\Microsoft VS Code\Code.exe", "Code.exe")

F19::isWorkMode
    ? OpenOrFocusProgram("C:\Program Files\JetBrains\JetBrains Rider 2021.2.2\bin\rider64.exe", "rider64.exe")
    : OpenOrFocusProgram("C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.exe", "devenv.exe")

; Communication apps
F21::isWorkMode
    ? OpenOrFocusProgram("C:\Program Files\Microsoft Office\root\Office16\OUTLOOK.EXE", "OUTLOOK.EXE")

F22::isWorkMode
    ? OpenOrFocusProgram("C:\Users\marost\AppData\Local\Microsoft\Teams\current\Teams.exe", "Teams.exe")
    : OpenOrFocusProgram("C:\Users\macke\AppData\Local\Discord\app-1.0.9151\Discord.exe", "Discord.exe")


; Functions
ShowShortcutsGUI(isWorkMode) {
    Gui, Destroy
    Gui, Color, Black
    Gui, Font, cGreen s14, Verdana

    Gui, Add, Text,, Alt+Ctrl+Shift+S: Spotify
    Gui, Add, Text,, Alt+Ctrl+Shift+K: KeePass
    Gui, Add, Text,, Alt+Ctrl+Shift+B: Browser
    Gui, Add, Text,, Alt+Ctrl+Shift+T: Windows Terminal
    Gui, Add, Text,, Alt+Ctrl+Shift+C: VS Code

    if (isWorkMode) {
        Gui, Add, Text,, Alt+Ctrl+Shift+O: Outlook
        Gui, Add, Text,, Alt+Ctrl+Shift+E: Teams
        Gui, Add, Text,, Alt+Ctrl+Shift+V: Rider
    } else {
        Gui, Add, Text,, Alt+Ctrl+Shift+G: Steam
        Gui, Add, Text,, Alt+Ctrl+Shift+E: Discord
        Gui, Add, Text,, Alt+Ctrl+Shift+V: Visual Studio
    }

    Gui, Show, w400 h400, Shortcuts Window
}

OpenOrFocusProgram(programPath, exeName) {
    Process, Exist, %exeName%
    ProcessPID := ErrorLevel

    if (ProcessPID = 0) {
        Run, %programPath%
    } else {
        WinActivate, ahk_exe %exeName%
    }
}
