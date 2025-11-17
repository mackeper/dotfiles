local ls = require("luasnip")
local snippet = ls.snippet
local text = ls.text_node
local insert = ls.insert_node
local func = ls.function_node
local function create_code_block_snippet(lang)
    return snippet({
        trig = lang,
        name = lang .. " code block",
    }, {
        text("```" .. lang, ""),
        insert(1),
        text({ "", "```" }),
    })
end

local function clipboard()
    return vim.fn.getreg("+")
end

return {
    create_code_block_snippet("bash"),
    create_code_block_snippet("python"),
    create_code_block_snippet("csharp"),
    create_code_block_snippet("lua"),
    create_code_block_snippet("javascript"),
    create_code_block_snippet("html"),
    create_code_block_snippet("powershell"),
    create_code_block_snippet("json"),
    create_code_block_snippet("yaml"),

    snippet({
        trig = "linkc",
        name = "Link from clipboard",
    }, {
        text("["),
        insert(1, "LINK"),
        text("]("),
        func(clipboard, {}),
        text(")"),
    }),

    snippet("date", {
        func(function()
            return os.date("%Y-%m-%d")
        end),
    }),

    snippet("note_technical", {
        text({
            "# Technical Note",
            "",
            "## Related Links",
            "",
            "- [[related-note]]",
            "",
            "## Overview",
            "",
            "Brief summary of the technical topic or issue.",
            "",
            "## Core Concepts",
            "",
            "List or explain the main principles, APIs, or algorithms involved.",
            "",
            "## Implementation Details",
            "",
            "Explain how it’s implemented in code — include module paths, functions, etc.",
            "",
            "## References",
            "",
            "- Source documentation or external references.",
        }),
    }),

    snippet("note_meeting", {
        func(function()
            return "# ... Meeting — " .. os.date("%Y-%m-%d")
        end),
        text({
            "",
            "**Attendees:** Names **Related:** [[related-note]]",
            "",
            "---",
            "",
            "## Context",
            "",
            "Why this meeting happened — what problem or feature triggered it.",
            "",
            "## Discussion Summary",
            "",
            "Key points and decisions made.",
            "",
            "## Action Items",
            "",
            "- [ ] Task 1 — owner",
            "- [ ] Task 2 — owner",
            "",
            "## Notes",
            "",
            "Free-form observations or sketches.",
        }),
    }),

    snippet("note_paper", {
        text({
            "# Full Paper/Topic Title",
            "",
            "**Source:** link or reference  **Date Added:** YYYY-MM-DD  **Tags:** #research #topic  **Related:** [[related-note]]",
            "",
            "---",
            "",
            "## Summary",
            "",
            "Concise description of what this paper is about.",
            "",
            "## Key Insights",
            "",
            "- Main ideas or findings.",
            "- Why it matters for our system or product.",
            "",
            "## Notes & Quotes",
            "",
            "> Important excerpts or paraphrases.",
            "",
            "## Application",
            "",
            "How this could influence code, design, or workflow.",
        }),
    }),

    snippet("note_reflection", {
        text({
            "# Habit & System Review — Date or Theme",
            "",
            "**Date:** YYYY-MM-DD  **Context:** What triggered this reflection?",
            "",
            "---",
            "",
            "## What’s Working",
            "",
            "Short notes on effective habits, routines, or tools.",
            "",
            "## What’s Not Working",
            "",
            "Issues, friction points, recurring problems.",
            "",
            "## Adjustments",
            "",
            "Planned improvements or experiments.",
            "",
            "## Insights",
            "",
            "Broader lessons or mental models worth keeping.",
        }),
    }),

    snippet("note", {
        text({ "> [!NOTE]", "> " }),
        insert(1, "Useful information that users should know, even when skimming content."),
    }),

    snippet("tip", {
        text({ "> [!TIP]", "> " }),
        insert(1, "Helpful advice for doing things better or more easily."),
    }),

    snippet("important", {
        text({ "> [!IMPORTANT]", "> " }),
        insert(1, "Key information users need to know to achieve their goal."),
    }),

    snippet("warning", {
        text({ "> [!WARNING]", "> " }),
        insert(1, "Urgent info that needs immediate user attention to avoid problems."),
    }),

    snippet("caution", {
        text({ "> [!CAUTION]", "> " }),
        insert(1, "Advises about risks or negative outcomes of certain actions."),
    }),

    snippet("title", {
        func(function()
            local current_file = vim.fn.expand("%:t:r")
            local current_dir = vim.fn.expand("%:p:h:t")
            local title = ""
            if current_file == "index" then
                title = current_dir
            else
                title = current_file
            end
            title = title:gsub("_", " "):gsub("-", " ")
            title = title:sub(1, 1):upper() .. title:sub(2)
            return "# " .. title
        end),
    }),

    snippet("link_up", {
        text({ "## Up", "", "" }),
        func(function()
            local current_file = vim.fn.expand("%:t:r")
            local current_dir = vim.fn.expand("%:p:h:t")
            local parent_dir = vim.fn.expand("%:p:h:h:t")
            local title = ""
            local link = ""
            if current_file == "index" then
                title = parent_dir
                link = "../index.md"
            else
                title = current_dir
                link = "./index.md"
            end
            title = title:gsub("_", " "):gsub("-", " ")
            title = title:sub(1, 1):upper() .. title:sub(2)
            return { "* [" .. title .. "](" .. link .. ")" }
        end),
    }),
}
