; ^ = Ctrl
; ! = Alt
; + = Shift
; # = Win

#SingleInstance
#Requires AutoHotkey v2.0

; Define prompts globally
global prompts := Map(
    "1", "Explain concept (analogy)",
    "2", "Summarize text",
    "3", "Code review",
    "4", "Refactor code",
    "5", "Generate test cases",
    "6", "Translate + preserve tone",
    "7", "Rewrite formally",
    "8", "Brainstorm ideas",
    "9", "Improve prompt",
    "10", "Generate username",
    "11", "Add feature to code",
    "12", "Create script"
)

global promptTexts := Map(
    "1", "
    (RTrim0
        I need to understand the concept of [CONCEPT].

        Explain this concept to me using an analogy from a completely different field.

        Break down the analogy, clearly mapping each key part of the concept to the corresponding part of the analogy.
    )",
    "2", "
    (RTrim0
        Summarize the following text concisely while preserving all essential details.
        Text:
        [PASTE HERE]
    )",
    "3", "
    (RTrim0
        Review the following code for correctness, readability, and efficiency. Suggest concrete improvements and potential pitfalls.
        Code:
        [PASTE HERE]
    )",
    "4", "
    (RTrim0
        Refactor the following code for clarity, maintainability, and idiomatic style without changing behavior.
        Code:
        [PASTE HERE]
    )",
    "5", "
    (RTrim0
        Generate a comprehensive set of unit tests for the following function or module, covering edge cases and failure paths.
        Code:
        [PASTE HERE]
    )",
    "6", "
    (RTrim0
        Translate the following text to [LANGUAGE], preserving tone, intent, and natural flow.
        Text:
        [PASTE HERE]
    )",
    "7", "
    (RTrim0
        Rewrite the following passage in a more formal, concise tone suitable for professional communication.
        Text:
        [PASTE HERE]
    )",
    "8", "
    (RTrim0
        Brainstorm several creative approaches or solutions for the following problem.
        Problem:
        [DESCRIBE HERE]
    )",
    "9", "
    (RTrim0
        I'm trying to get good results using the following prompt:

        `[PASTE HERE]`

        Your task is to write a better prompt that is more optimal for `[text model]` and would produce better results.

        Give me 3 variations.
    )",
    "10", "
    (RTrim0
        I'm creating a new username. I want it to be a combination of an adjective and an animal name, something catchy and memorable.
        The adjective and animal should both start with the same letter. Please provide me with 10 unique suggestions.
    )",
    "11", "
    (RTrim0
        You are a coding assistant. I have this code:
        [CODE]

        I want to add this feature:
        [FEATURE]

        Update the code to include the feature. Make it clean, efficient, and maintainable.
        Highlight what was added or modified and briefly explain why. Note any assumptions or potential issues.
    )",
    "12", "
    (RTrim0
        You are an expert in [SCRIPTING LANGUAGE]. Create a script that fulfills the following requirements precisely:
        [INSTRUCTIONS]

        Structure the code to be modular, maintainable, and easy to extend.
        Use clear, descriptive variable and function names so the code is self-explanatory without unnecessary comments.
        Follow best practices and ensure the script is robust and ready to run.
    )"
)

:*::prompts::
{
    oldClip := A_Clipboard
    global chosen := "", guiVisible := true

    guia := Gui("+AlwaysOnTop -Caption +Border", "Prompt Menu")
    guia.MarginX := 20
    guia.MarginY := 10
    guia.SetFont("s10")
    guia.BackColor := "1e1e1e"

    guia.AddText("w300 Center cWhite", "Type to filter prompts:")
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
        for key, desc in prompts {
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
