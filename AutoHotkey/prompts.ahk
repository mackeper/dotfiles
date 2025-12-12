; ^ = Ctrl
; ! = Alt
; + = Shift
; # = Win

#SingleInstance
#Requires AutoHotkey v2.0

; Define prompts globally
global prompts := Map()
global promptTexts := Map()
global promptCounter := 0

; --------------------------------------
; AddPrompt(label, text)
; --------------------------------------
AddPrompt(label, text) {
    global prompts, promptTexts, promptCounter
    promptCounter++
    key := String(promptCounter)
    prompts[key] := label
    promptTexts[key] := text
}

; --------------------------------------
; Add general prompts
; --------------------------------------
AddPrompt(
    "Improve prompt", "
    (RTrim0
        I'm trying to get good results using the following prompt:

        `[PASTE HERE]`

        Your task is to write a better prompt that is more optimal for `[text model]` and would produce better results.

        Give me 3 variations.
    )")

AddPrompt(
    "Generate username", "
    (RTrim0
        I'm creating a new username. I want it to be a combination of an adjective and an animal name, something catchy and memorable.
        The adjective and animal should both start with the same letter. Please provide me with 10 unique suggestions.
    )")

; --------------------------------------
; Add research prompts
; --------------------------------------
AddPrompt(
    "Explain concept (analogy)", "
    (RTrim0
        I need to understand the concept of [CONCEPT].

        Explain this concept to me using an analogy from a completely different field.

        Break down the analogy, clearly mapping each key part of the concept to the corresponding part of the analogy.
    )")

AddPrompt(
    "Brainstorm ideas", "
    (RTrim0
        Brainstorm several creative approaches or solutions for the following problem.
        Problem:
        [DESCRIBE HERE]
    )")


;--------------------------------------
; Add text related prompts
; --------------------------------------
AddPrompt(
    "Summarize text", "
    (RTrim0
        Summarize the following text concisely while preserving all essential details.
        Text:
        [PASTE HERE]
    )")

AddPrompt(
    "Translate + preserve tone", "
    (RTrim0
        Translate the following text to [LANGUAGE], preserving tone, intent, and natural flow.
        Text:
        [PASTE HERE]
    )")

AddPrompt(
    "Rewrite formally", "
    (RTrim0
        Rewrite the following passage in a more formal, concise tone suitable for professional communication.
        Text:
        [PASTE HERE]
    )")


; --------------------------------------
; Add technical prompts
; --------------------------------------
AddPrompt(
    "Code review", "
    (RTrim0
        Review the following code for correctness, readability, and efficiency. Suggest concrete improvements and potential pitfalls.
        Code:
        [PASTE HERE]
    )")

AddPrompt(
    "Refactor code", "
    (RTrim0
        Refactor the following code for clarity, maintainability, and idiomatic style without changing behavior.
        Code:
        [PASTE HERE]
    )")

AddPrompt(
    "Generate test cases", "
    (RTrim0
        Generate a comprehensive set of unit tests for the following function or module, covering edge cases and failure paths.
        Code:
        [PASTE HERE]
    )")

AddPrompt(
    "Add feature to code", "
    (RTrim0
        You are a coding assistant. I have this code:
        [CODE]

        I want to add this feature:
        [FEATURE]

        Update the code to include the feature. Make it clean, efficient, and maintainable.
        Highlight what was added or modified and briefly explain why. Note any assumptions or potential issues.
    )")

AddPrompt(
    "Create script", "
    (RTrim0
        You are an expert in [SCRIPTING LANGUAGE]. Create a script that fulfills the following requirements precisely:
        [INSTRUCTIONS]

        Structure the code to be modular, maintainable, and easy to extend.
        Use clear, descriptive variable and function names so the code is self-explanatory without unnecessary comments.
        Follow best practices and ensure the script is robust and ready to run.
    )")

AddPrompt(
    "Debug/fix code", "
    (
        You are an expert in [language].
        Your task is to debug and fix code.

        Rules:
        * Show corrected code with minimal explanations.
        * If I ask for explanations, be concise and precise.
        * Assume I'm an experienced developer — no beginner explanations.
        * Keep the original code structure intact unless a redesign is required for correctness.

        Code:

        The issue:

    )")

AddPrompt(
    "Optimize code", "
    (
        You are an expert in [language].
        Your task is to optimize code for performance, readability, and maintainability.

        Rules:
        * Show optimized code with minimal explanations.
        * Preserve functionality exactly.
        * Use idiomatic, modern, and minimal patterns for the language.
        * Remove redundancy and unnecessary abstractions.
        * If multiple optimizations exist, pick the cleanest and fastest approach.

        Code:

    )")

AddPrompt(
    "Windows question", "
    (
        You are an expert in Windows productivity and keyboard-driven workflows.
        I'm a software developer who prefers to control everything using shortcuts and avoid the mouse as much as possible.
        Explain the most efficient and modern ways to do the following in Windows 11:

    )")

AddPrompt(
    "Compare approaches", "
    (RTrim0
        Compare the following approaches for [PROBLEM/TASK]:

        Approach 1:
        [DESCRIBE OR PASTE]

        Approach 2:
        [DESCRIBE OR PASTE]

        Evaluate trade-offs considering: performance, maintainability, scalability, complexity, and edge cases.
        Recommend the better approach with clear reasoning.
    )")

AddPrompt(
    "Convert between formats", "
    (RTrim0
        Convert the following data from [SOURCE_FORMAT] to [TARGET_FORMAT]:

        Data:
        [PASTE HERE]

        Preserve structure and semantics. Handle type conversions appropriately.
    )")

AddPrompt(
    "Name things", "
    (RTrim0
        I need a name for a [variable/function/class/project/module] that does the following:
        [DESCRIBE PURPOSE]

        Context:
        [LANGUAGE/DOMAIN]

        Provide 5-10 concise, descriptive, idiomatic naming options.
        Follow naming conventions for the specified context.
    )")

AddPrompt(
    "Architecture review", "
    (RTrim0
        Review the following system architecture/design:

        [DESCRIBE OR PASTE ARCHITECTURE]

        Analyze:
        - Scalability and performance bottlenecks
        - Reliability and fault tolerance
        - Maintainability and complexity
        - Security considerations
        - Potential issues and suggested improvements

        Be direct and prioritize critical issues.
    )")

AddPrompt(
    "Security review", "
    (RTrim0
        Review the following code/configuration/architecture for security vulnerabilities:

        [PASTE HERE]

        Identify:
        - Authentication/authorization issues
        - Input validation and injection risks
        - Data exposure and encryption gaps
        - Common vulnerability patterns (OWASP Top 10)
        - Specific exploits and mitigation strategies

        Prioritize by severity.
    )")

AddPrompt(
    "Simplify complexity", "
    (RTrim0
        The following code/design is too complex:

        [PASTE HERE]

        Simplify it by:
        - Reducing cognitive load and nesting
        - Eliminating unnecessary abstractions
        - Improving readability and clarity
        - Preserving functionality exactly

        Show the simplified version with brief explanation of key changes.
    )")

; --------------------------------------
; Add language-specific prompts
; --------------------------------------
langs := ["Python", "C#/.NET", "Go", "Rust", "JavaScript",
         "Neovim and Lua", "Bash", "PowerShell", "Java",
         "C", "C++", "HTML/CSS", "SQL"]
for lang in langs {
    AddPrompt(
        lang " question",
        Format("
        (RTrim0
            You are an expert {} developer.

            Code Requirements:
            - Idiomatic and production-ready
            - Modern language features and best practices
            - No comments except inline explanations of "why" for complex logic
            - Focus on performance and readability
            - Prefer standard library over dependencies
            - Show only relevant code, not full file structure

            Response Format:
            - Code first, brief explanation only if necessary
            - Assume expert-level knowledge
            - No preamble or boilerplate

            Question:

        )", lang))
}

; ---------------------------------------
; Add tech-specific prompts
; ---------------------------------------
techs := ["Git", "Docker", "Kubernetes", "AWS", "Azure",
         "GCP", "Linux", "Windows", "AutoHotkey v2", "Regex",
         "Nginx", "Apache", "Redis", "PostgreSQL", "MySQL",
         "ZMK", "Home Assistant", "QMK"]
for tech in techs {
    AddPrompt(
        tech " question",
        Format("
        (RTrim0
            You are an expert {} system administrator.

            Command/Configuration Requirements:
            - Idiomatic and production-ready
            - Modern syntax and best practices
            - Inline comments only to explain "why" for non-obvious choices
            - Safe operations (avoid destructive commands without warnings)
            - Cross-platform considerations when relevant
            - Prefer built-in tools over third-party utilities
            - Show only relevant commands/config, not full files

            Response Format:
            - Commands/config first, brief explanation only if necessary
            - Assume expert-level knowledge
            - No preamble or boilerplate

            Question:

        )", tech))
}

; ---------------------------------------
; Add tool-specific prompts
; ---------------------------------------
tools := ["rg", "fd", "bat", "fzf", "htop", "curl",
          "wget", "jq", "awk", "sed", "tmux", "ssh",
          "rsync", "ffmpeg", "systemd", "nftables",
          "dotnet", "systemctl", "choco", "winget"]
for tool in tools {
    AddPrompt(
        tool " question",
        Format("
        (RTrim0
            You are an expert {} CLI Linux and Windows user.

            Command Requirements:
            - Idiomatic and production-ready syntax
            - Modern flags and features over legacy alternatives
            - Inline comments only to explain "why" for complex pipelines
            - Safe operations (show --dry-run or confirmation flags when destructive)
            - POSIX-compliant when possible for portability
            - Composable commands (proper piping and chaining)
            - Show only exact commands needed, not full scripts

            Response Format:
            - Commands first, brief explanation only if necessary
            - Assume expert-level knowledge
            - No preamble or boilerplate

            Question:

        )", tool))
}


; ---------------------------------------
; Hotkey to open prompt menu
; ---------------------------------------
:*::prompts::
{
    oldClip := A_Clipboard
    global chosen := "", guiVisible := true

    guia := Gui("+AlwaysOnTop -Caption +Border", "Prompt Menu")
    guia.MarginX := 20
    guia.MarginY := 10
    guia.SetFont("s10")
    guia.BackColor := "1e1e1e"

    guia.AddText("w500 Center cWhite", "Type to filter prompts:")
    filterEdit := guia.AddEdit("w500")

    guia.SetFont("s12 Bold")
    headerText := guia.AddText("w500 Background2d2d2d cWhite", "Key    Prompt")
    guia.SetFont("s10")
    promptList := guia.AddListView("w500 h400 -Multi -Hdr Background252525 cWhite", ["Key", "Prompt"])

    promptList.ModifyCol(1, 60)
    promptList.ModifyCol(2, 430)
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
