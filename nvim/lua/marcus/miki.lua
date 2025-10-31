--------------------------------------------------------------
---------------------- Config --------------------------------
--------------------------------------------------------------
vim.g.miki_root = "~/git/wiki"
if jit.os == "Windows" then
    vim.g.miki_root = "C:/git/wiki"
end

vim.g.miki_journal_root = vim.g.miki_root .. "/" .. "98_Journal"

--- @class Miki
--- @field config table Configuration options for Miki
---
--- Depends on:
---  rg (ripgrep) for tag searching
---  telescope.nvim or mini.pick for file picking
local Miki = {}

Miki._file_pickers = {
    telescope = "telescope",
    minipick = "minipick",
}

Miki.config = {
    wiki_root = vim.g.miki_root,
    journal_root = vim.g.miki_journal_root,
    keymaps = {
        index = "<leader>mi",
        current = "<leader>mc",

        find_page = "<leader>mf",
        find_tag = "<leader>mt",

        journal_today = "<leader>mjj",
        journal_previous_day = "<leader>mjp",
        journal_next_day = "<leader>mjn",

        toggle_checkbox = "<M-t>",
    },
    autolist = {
        enabled = true,
    },
    spellcheck = {
        enabled = false,
    },
    file_picker = Miki._file_pickers.minipick,
}

local default_opts = { noremap = true, silent = true }

--------------------------------------------------------------
---------------------- Functions -----------------------------
--------------------------------------------------------------
Miki._map = function(mode, key, result, opts)
    vim.keymap.set(mode, key, result, vim.tbl_extend("force", default_opts, opts or {}))
end

Miki._normalize_path = function(path)
    return path:gsub("\\", "/")
end

Miki._get_tags = function()
    local command = 'rg --no-heading --no-filename -o ":\\w+:" "' .. Miki.config.wiki_root .. '"'
    local handle = io.popen(command, "r")
    if not handle then
        return
    end

    local tags = {}
    local seen = {}
    for line in handle:lines() do
        line = line:gsub("%s+", "")
        if line ~= "" and not seen[line] then
            table.insert(tags, line)
            seen[line] = true
        end
    end
    handle:close()

    if #tags == 0 then
        vim.notify("No tags found", vim.log.levels.WARN)
        return
    end

    table.sort(tags)
    return tags
end

Miki._find_pages = function()
    if Miki.config.file_picker == "telescope" then
        require("telescope.builtin").find_files({
            cwd = Miki.config.wiki_root,
            hidden = false,
        })
    elseif Miki.config.file_picker == "minipick" then
        require("mini.pick").builtin.files({}, {
            source = {
                cwd = Miki.config.wiki_root,
            },
        })
    else
        vim.notify("Invalid file picker: " .. Miki.config.file_picker, vim.log.levels.ERROR)
    end
end

Miki._find_tags_telescope = function()
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local builtin = require("telescope.builtin")

    local tags = Miki._get_tags()
    pickers
        .new({}, {
            prompt_title = "Tags",
            finder = finders.new_table({ results = tags }),
            sorter = conf.generic_sorter({}),
            attach_mappings = function(prompt_bufnr)
                local actions = require("telescope.actions")
                local action_state = require("telescope.actions.state")

                actions.select_default:replace(function()
                    local selection = action_state.get_selected_entry()
                    actions.close(prompt_bufnr)
                    builtin.grep_string({
                        search = selection[1],
                        cwd = vim.g.miki_root,
                        word_match = false,
                    })
                end)

                return true
            end,
        })
        :find()
end

Miki._find_tags_minipick = function()
    local mini_pick = require("mini.pick")
    local tags = Miki._get_tags()
    if not tags then
        return
    end

    mini_pick.start({
        source = {
            items = tags,
            choose = function(item)
                vim.notify("Searching for tag: " .. item, vim.log.levels.INFO)
                mini_pick.stop()
                mini_pick.builtin.grep({
                    tool = "rg",
                    pattern = item,
                }, {
                    source = {
                        cwd = vim.g.miki_root,
                    },
                })
            end,
        },
    })
end

Miki._find_tags = function()
    if Miki.config.file_picker == "telescope" then
        Miki._find_tags_telescope()
    elseif Miki.config.file_picker == "minipick" then
        Miki._find_tags_minipick()
    else
        vim.notify("Invalid file picker: " .. Miki.config.file_picker, vim.log.levels.ERROR)
    end
end

Miki._open_page = function(page)
    local path = vim.g.miki_root .. "/" .. page .. ".md"
    vim.cmd("edit " .. path)
end

-- Journal functions
Miki._open_journal_entry = function(date)
    local path = Miki.config.journal_root .. "/" .. date .. ".md"
    vim.notify("Opening journal entry: " .. path, vim.log.levels.INFO)
    vim.cmd("edit " .. path)
end

Miki._open_journal = function()
    local date = os.date("%Y-%m-%d")
    Miki._open_journal_entry(date)
end


Miki._navigate_journal = function(direction)
    local files = vim.fn.globpath(Miki.config.journal_root, "*.md", false, true)
    table.sort(files)
    local current_file = Miki._normalize_path(vim.fn.expand("%:p"))

    for i, file in ipairs(files) do
        files[i] = Miki._normalize_path(file)
    end

    local current_idx = vim.fn.index(files, current_file)
    local target_idx = current_idx + direction

    if target_idx >= 0 and target_idx < #files then
        vim.cmd.edit(files[target_idx + 1])
    else
        local msg = direction > 0 and "next" or "previous"
        vim.notify("No " .. msg .. " journal entry found", vim.log.levels.WARN)
    end
end

Miki._open_journal_next = function()
    Miki._navigate_journal(1)
end

Miki._open_journal_previous = function()
    Miki._navigate_journal(-1)
end

Miki._add_page_link = function()
    require("mini.pick").builtin.files({}, {
        source = {
            cwd = Miki.config.wiki_root,
            choose = function(item)
                item = Miki._normalize_path(item)
                local title = item:match("([^/]+)%.md$")
                local link = "[" .. title .. "](" .. item .. ")"
                require("mini.pick").stop()
                vim.schedule(function()
                    vim.api.nvim_put({ link }, "c", true, true)
                end)
            end,
        },
    })
end

--------------------------------------------------------------
---------------------- Commands ------------------------------
--------------------------------------------------------------
vim.api.nvim_create_user_command("MikiCurrent", function()
    Miki._open_page("01_Work/current")
end, {})

vim.api.nvim_create_user_command("MikiIndex", function()
    Miki._open_page("index")
end, {})

vim.api.nvim_create_user_command("MikiJournal", Miki._open_journal, {})
vim.api.nvim_create_user_command("MikiJournalPrevious", Miki._open_journal_previous, {})
vim.api.nvim_create_user_command("MikiJournalNext", Miki._open_journal_next, {})

vim.api.nvim_create_user_command("MikiAddLink", Miki._add_page_link, {})


--------------------------------------------------------------
---------------------- Keymaps -------------------------------
--------------------------------------------------------------
-- stylua: ignore start
Miki._map("n", Miki.config.keymaps.index, ":MikiIndex<CR>", { desc = "Miki: Open Index" })
Miki._map("n", Miki.config.keymaps.current, ":MikiCurrent<CR>", { desc = "Miki: Open Current" })

Miki._map("n", Miki.config.keymaps.journal_today, ":MikiJournal<CR>", { desc = "Miki: Open Journal" })
Miki._map("n", Miki.config.keymaps.journal_previous_day, ":MikiJournalPrevious<CR>",
    { desc = "Miki: Open Previous Journal Entry" })
Miki._map("n", Miki.config.keymaps.journal_next_day, ":MikiJournalNext<CR>", { desc = "Miki: Open Next Journal Entry" })

Miki._map("n", Miki.config.keymaps.find_page, Miki._find_pages, { desc = "Miki: Find Page" })
Miki._map("n", Miki.config.keymaps.find_tag, Miki._find_tags, { desc = "Miki: Find Tag" })
Miki._map("n", "<leader>mpp", [[:let @+=expand("%:p")<CR>]], { desc = "Miki: Copy page path to clipboard" })

Miki._map("n", "<leader>mla", ":MikiAddLink<CR>", { desc = "Miki: Add Page Link" })

Miki._add_autolist_keymaps = function()
    Miki.autolist = {}
    Miki.autolist.toggle_checkbox = function()
        local line = vim.api.nvim_get_current_line()
        if line:match("%- %[ %]") then
            local toggled = line:gsub("%- %[ %]", "- [x]")
            vim.api.nvim_set_current_line(toggled)
        elseif line:match("%- %[x%]") then
            local toggled = line:gsub("%- %[x%]", "- [ ]")
            vim.api.nvim_set_current_line(toggled)
        end
    end

    Miki._map("n", "<leader>msc", function()
        vim.api.nvim_put({ "- [ ] " }, "c", true, true)
        vim.cmd("startinsert")
    end, { desc = "Create checkbox" })

    Miki._map("n", Miki.config.keymaps.toggle_checkbox, Miki.autolist.toggle_checkbox, { desc = "Miki: Toggle checkbox" })
end
-- stylua: ignore end

Miki._map("n", "<leader>mu", function()
    local ps1_path = vim.g.miki_root .. "/parse_url.ps1"
    local handle = io.popen('pwsh -NoProfile -NoLogo -File "' .. ps1_path .. '"')
    if not handle then
        vim.notify("Failed to run parse_url.ps1", vim.log.levels.ERROR)
        return
    end
    local result = handle:read("*a")
    handle:close()
    local text = result or ""
    text = tostring(text):gsub("\r?\n$", "")
    vim.api.nvim_put({ text }, "c", true, true)
end, { desc = "Miki: paste TFS url" })

--------------------------------------------------------------
----------------------- Features -----------------------------
--------------------------------------------------------------
if Miki.config.autolist.enabled then
    Miki._add_autolist_keymaps()
end

if Miki.config.spellcheck.enabled then
    --autocmd for markdown files
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
            vim.cmd("setlocal spell")
            vim.cmd("setlocal spelllang=en_us,sv")
        end,
    })
end

----------------------------------------------------------------
--------------------Should not be here -------------------------
----------------------------------------------------------------
--- Just because I have not confiured the formatting yet
vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        vim.cmd("setlocal tabstop=2")
        vim.cmd("setlocal shiftwidth=2")
        vim.cmd("setlocal softtabstop=2")
    end,
})

vim.notify("miki.lua loaded", vim.log.levels.INFO)
