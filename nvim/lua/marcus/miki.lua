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
---   rg (ripgrep) for tag searching
---   fd (fd-find) for file searching (https://github.com/sharkdp/fd)
---     - `apt install fd-find` on Debian-based systems
---     - `pacman -S fd` on Arch-based systems
---     - `choco install fd` on Windows with Chocolatey
--- Available file pickers:
---   - telescope.nvim
---   - mini.pick
---
---  I have disabled Copilot for markdown files.
---  It tend to be more distracting than helpful when writing
---  down my own thoughts.
local Miki = {}

Miki._file_pickers = {
    telescope = "telescope",
    minipick = "minipick",
    -- TODO: Implement snacks picker
    snacks = "snacks",
}

Miki.config = {
    wiki_root = vim.g.miki_root,
    journal_root = vim.g.miki_journal_root,
    keymaps = {
        index = "<leader>mw",
        current = "<leader>mc",

        find_page = "<leader>mf",
        find_tag = "<leader>mt",

        journal_today = "<leader>mjj",
        journal_previous_day = "[j",
        journal_next_day = "]j",
        journal_week = "<leader>mjw",
        journal_month = "<leader>mjm",

        toggle_checkbox = "<M-t>",

        add_page_link = "<leader>ml",
        add_page = "<leader>ma",
        move_page = "<leader>mm",
        follow_link = "<CR>",
    },
    journal = {
        date_format = "%Y-%m-%d",
        today_template = {
            "# {date} - {weekday} - w{week}",
            "",
            "## ✨ Highlights (Things that went well today)",
            "",
            "- ",
            "",
            "## 🌑 Lowlights (Challenges or negatives from today)",
            "",
            "- ",
            "",
            "## 📈 Improvements (How I could do better tomorrow)",
            "",
            "- ",
            "",
            "## ✅ Tasks",
            "",
            "- [ ] ",
            "",
            "## 💭 Random thoughts, ideas, or observations",
            "",
            "- ",
        },
    },
    page = {
        add_page_template = {
            "# {current_file_name_pretty}",
            "",
        },
    },
    template_replacements = {
        ["{current_file_path}"] = function()
            return vim.fn.expand("%:p")
        end,
        ["{current_file_name}"] = function()
            return vim.fn.expand("%:t")
        end,
        ["{current_file_name_no_ext}"] = function()
            return vim.fn.expand("%:t:r")
        end,
        ["{current_file_name_pretty}"] = function()
            local name = vim.fn.expand("%:t:r")
            local result = name:gsub("(%a)([%w]*)", function(first, rest)
                    return first:upper() .. rest:lower()
                end)
                :gsub("_", " ")
                :gsub("-", " ")
            return result
        end,
        ["{date}"] = function()
            return os.date("%Y-%m-%d")
        end,
        ["{time}"] = function()
            return os.date("%H:%M")
        end,
        ["{weekday}"] = function()
            return os.date("%A")
        end,
        ["{week}"] = function()
            return os.date("%W")
        end, -- Week number
        ["{day}"] = function()
            return os.date("%d")
        end,
        ["{month}"] = function()
            return os.date("%B")
        end,
        ["{year}"] = function()
            return os.date("%Y")
        end,
        ["{dayofyear}"] = function()
            return os.date("%j")
        end,
        ["{timestamp}"] = function()
            return os.date("%Y-%m-%d %H:%M:%S")
        end,
    },
    autolist = {
        enabled = true,
    },
    spellcheck = {
        enabled = false,
    },
    writing_settings = {
        enabled = true,
        textwidth = 80,
        wrapmargin = 10,
    },
    copilot = {
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
    path = path:sub(1, 1):upper() .. path:sub(2)
    return path:gsub("\\", "/")
end

-- Compute the relative path from base to target
-- by finding the common ancestor directory
Miki._relative_path = function(base, target)
    local norm_base = Miki._normalize_path(vim.fn.fnamemodify(base, ":p:h"))
    local norm_target = Miki._normalize_path(vim.fn.fnamemodify(target, ":p:h"))

    local function is_subpath(sub, path)
        return path:sub(1, #sub) == sub
    end

    local sub_path = norm_base
    local relative_path = ""
    local found_common = false
    for _ = 1, 10 do
        if is_subpath(sub_path, norm_target) then
            found_common = true
            break
        end
        sub_path = vim.fn.fnamemodify(sub_path, ":h")
        relative_path = relative_path .. "../"
    end

    if not found_common then
        vim.notify("Could not find common path between " .. base .. " and " .. target, vim.log.levels.ERROR)
        return target
    end

    local final_path = Miki._normalize_path(vim.fn.fnamemodify(target, ":p"))
    final_path = final_path:sub(#sub_path + 2) -- +2 to remove the trailing slash
    final_path = relative_path .. final_path
    return final_path
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
    elseif Miki.config.file_picker == "snacks" then
        require("snacks").picker.files({
            dirs = { Miki.config.wiki_root, },
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

    local custom_mappings = {
        add_tag = {
            char = "<C-a>",
            func = function()
                local current_item = mini_pick.get_picker_matches().current
                mini_pick.stop()
                vim.schedule(function()
                    vim.api.nvim_put({ current_item }, "c", true, true)
                end)
            end,
        },
    }

    mini_pick.start({
        mappings = custom_mappings,
        source = {
            items = tags,
            choose = function(item)
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
    vim.cmd.edit(path)
end

Miki._add_page_with_template = function(path, template_lines)
    local file_exists = vim.fn.filereadable(path) == 1

    if not file_exists then
        vim.opt.swapfile = false
    end

    vim.cmd.edit(path)

    if not file_exists then
        local processed_template = {}
        for _, line in ipairs(template_lines) do
            local processed = line
            for placeholder, func in pairs(Miki.config.template_replacements) do
                processed = processed:gsub(placeholder, func())
            end
            table.insert(processed_template, processed)
        end
        vim.api.nvim_buf_set_lines(0, 0, -1, false, processed_template)
        vim.bo.modified = false
    end

    vim.opt.swapfile = true
end

-- Journal functions
Miki._open_journal_entry = function(date)
    local path = Miki.config.journal_root .. "/" .. date .. ".md"
    Miki._add_page_with_template(path, Miki.config.journal.today_template)
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

Miki._open_journal_week = function()
    local current_week = os.date("%W")
    local files = vim.fn.globpath(Miki.config.journal_root, "*.md", false, true)
    table.sort(files)
    for _, file in ipairs(files) do
        local file_week = vim.fn.strftime("%W", vim.fn.getftime(file))
        if file_week == current_week then
            vim.cmd.edit(file)
            return
        end
    end
end
Miki._open_journal_month = function() end

Miki._add_page_link = function()
    local current_file = Miki._normalize_path(vim.fn.expand("%:p"))
    vim.notify("Current file: " .. current_file, vim.log.levels.DEBUG)
    require("mini.pick").builtin.files({}, {
        source = {
            cwd = Miki.config.wiki_root,
            choose = function(item)
                item = Miki._normalize_path(item):gsub("^/", ""):gsub("^", "./")
                vim.notify("Current file: " .. current_file, vim.log.levels.DEBUG)
                vim.notify("Target file: " .. item, vim.log.levels.DEBUG)
                local relative_path = Miki._relative_path(current_file, item)
                local title = item:match("([^/]+)%.md$")
                if title == "index" then
                    title = vim.fn.fnamemodify(vim.fn.fnamemodify(item, ":h"), ":t")
                end
                title = title:gsub("_", " "):gsub("-", " ")
                local link = "[" .. title .. "](<" .. relative_path .. ">)"
                require("mini.pick").stop()
                vim.schedule(function()
                    vim.api.nvim_put({ link }, "c", true, true)
                end)
            end,
        },
    })
end

Miki._follow_markdown_link = function()
    local line = vim.api.nvim_get_current_line()
    local link = line:match('%[.-%]%((.-)%)')
    if link then
        if link:match('^/') or link:match('^%a:') then
            vim.cmd('edit ' .. link)
        else
            local current_file = vim.api.nvim_buf_get_name(0)
            local current_dir = vim.fn.fnamemodify(current_file, ':h')
            link = link:gsub("^<", ""):gsub(">$", "")
            local full_path = current_dir .. '/' .. link
            vim.cmd('edit ' .. full_path)
        end
    else
        vim.cmd('normal! gf')
    end
end

Miki._add_page = function()
    local directories = vim.fn.systemlist("fd --type d --base-directory " .. Miki.config.wiki_root)
    for i, dir in ipairs(directories) do
        directories[i] = Miki._normalize_path(dir):gsub("^/", "")
    end
    require("mini.pick").start({
        source = {
            items = directories,
            cwd = Miki.config.wiki_root,
            choose = function(item)
                item = Miki.config.wiki_root .. "/" .. item:gsub("/$", "")
                require("mini.pick").stop()
                vim.ui.input({ prompt = "New page name (without .md): " }, function(input)
                    local path = item .. "/" .. input .. ".md"
                    vim.notify("Creating new page: " .. path, vim.log.levels.INFO)
                    vim.schedule(function()
                        Miki._add_page_with_template(path, Miki.config.page.add_page_template)
                    end)
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
vim.api.nvim_create_user_command("MikiJournalWeek", Miki._open_journal_week, {})
vim.api.nvim_create_user_command("MikiJournalMonth", Miki._open_journal_month, {})

vim.api.nvim_create_user_command("MikiAddLink", Miki._add_page_link, {})
vim.api.nvim_create_user_command("MikiFollowLink", Miki._follow_markdown_link, {})
vim.api.nvim_create_user_command("MikiAddPage", Miki._add_page, {})


--------------------------------------------------------------
---------------------- Keymaps -------------------------------
--------------------------------------------------------------
-- stylua: ignore start
Miki._map("n", Miki.config.keymaps.index, ":MikiIndex<CR>", { desc = "Miki: Open Index" })
Miki._map("n", Miki.config.keymaps.current, ":MikiCurrent<CR>", { desc = "Miki: Open Current" })

-- Journal
Miki._map("n", Miki.config.keymaps.journal_today, ":MikiJournal<CR>", { desc = "Miki: Open Journal" })
Miki._map("n", Miki.config.keymaps.journal_previous_day, ":MikiJournalPrevious<CR>",
    { desc = "Miki: Open Previous Journal Entry" })
Miki._map("n", Miki.config.keymaps.journal_next_day, ":MikiJournalNext<CR>", { desc = "Miki: Open Next Journal Entry" })
Miki._map("n", Miki.config.keymaps.journal_week, ":MikiJournalWeek<CR>", { desc = "Miki: Open Week Journal" })
Miki._map("n", Miki.config.keymaps.journal_month, ":MikiJournalMonth<CR>", { desc = "Miki: Open Month Journal" })

-- Find
Miki._map("n", Miki.config.keymaps.find_page, Miki._find_pages, { desc = "Miki: Find Page" })
Miki._map("n", Miki.config.keymaps.find_tag, Miki._find_tags, { desc = "Miki: Find Tag" })
Miki._map("n", "<leader>mpp", [[:let @+=expand("%:p")<CR>]], { desc = "Miki: Copy page path to clipboard" })

-- Page
Miki._map("n", Miki.config.keymaps.add_page_link, ":MikiAddLink<CR>", { desc = "Miki: Add Page Link" })
Miki._map("n", Miki.config.keymaps.add_page, ":MikiAddPage<CR>", { desc = "Miki: Add New Page" })

-- Link
Miki._map("n", Miki.config.keymaps.follow_link, Miki._follow_markdown_link, { desc = "Miki: Follow Link" })

-- Autolist
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
        else
            vim.api.nvim_put({ "- [ ] " }, "c", true, true)
            vim.cmd.startinsert()
        end
    end

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
    vim.api.nvim_put({ " " .. text }, "c", true, true)
end, { desc = "Miki: paste TFS url" })

--------------------------------------------------------------
----------------------- Features -----------------------------
--------------------------------------------------------------
if Miki.config.autolist.enabled then
    Miki._add_autolist_keymaps()
end

if Miki.config.spellcheck.enabled then
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
            vim.cmd("setlocal spell")
            vim.cmd("setlocal spelllang=en_us,sv")
        end,
    })
end

if Miki.config.writing_settings.enabled then
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
            vim.bo.wrapmargin = Miki.config.writing_settings.wrapmargin
            vim.bo.formatoptions = vim.bo.formatoptions .. "t"
            vim.wo.linebreak = true
            vim.bo.textwidth = Miki.config.writing_settings.textwidth
        end,
    })
end
if not Miki.config.copilot.enabled then
    vim.api.nvim_create_autocmd("BufReadPre", {
        pattern = "*",
        callback = function(args)
            if string.find(args.file, Miki.config.wiki_root) then
                local ok, copilot = pcall(require, "copilot.command")
                if ok then
                    copilot.disable()
                end
            end
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
        vim.bo.tabstop = 2
        vim.bo.shiftwidth = 2
        vim.bo.softtabstop = 2
    end,
})

return Miki
