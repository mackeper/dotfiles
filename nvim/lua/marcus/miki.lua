--------------------------------------------------------------
---------------------- Config --------------------------------
--------------------------------------------------------------
vim.g.miki_root = "~/git/wiki"
if jit.os == "Windows" then
    vim.g.miki_root = "C:/git/wiki"
end

vim.g.miki_journal_root = vim.g.miki_root .. "98_Journal"

local config = {
    wiki_root = vim.g.miki_root,
    journal_root = vim.g.miki_journal_root,
    autolist = {
        enabled = true,
    },
    spellcheck = {
        enabled = true,
    },
}

--------------------------------------------------------------
---------------------- Functions -----------------------------
--------------------------------------------------------------
local function _miki_get_tags()
    local command = 'rg --no-heading --no-filename -o ":\\w+:" "' .. config.wiki_root .. '"'
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

local function _miki_find_pages()
    require("telescope.builtin").find_files({
        cwd = config.wiki_root,
        hidden = false,
    })
end

local function _miki_find_tags()
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local builtin = require("telescope.builtin")

    local tags = _miki_get_tags()
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

local function _miki_open_page(page)
    local path = vim.g.miki_root .. "/" .. page .. ".md"
    vim.cmd("edit " .. path)
end

--------------------------------------------------------------
---------------------- Commands ------------------------------
--------------------------------------------------------------
vim.api.nvim_create_user_command("MikiCurrent", function()
    _miki_open_page("01_Work/current")
end, {})

vim.api.nvim_create_user_command("MikiIndex", function()
    _miki_open_page("index")
end, {})

vim.api.nvim_create_user_command("MikiJournal", function()
    -- TODO make this open today's journal entry
    vim.cmd("edit " .. vim.g.miki_root .. vim.g.miki_journal_root .. "/index.md")
end, {})

vim.api.nvim_create_user_command("MikiAddLink", function() end, {})


--------------------------------------------------------------
---------------------- Keymaps -------------------------------
--------------------------------------------------------------
-- stylua: ignore start
vim.keymap.set("n", "<leader>mi", ":MikiIndex<CR>", { desc = "Miki: Open Index", noremap = true, silent = true })
vim.keymap.set("n", "<leader>mc", ":MikiCurrent<CR>", { desc = "Miki: Open Current", noremap = true, silent = true })
vim.keymap.set("n", "<leader>mj", ":MikiJournal<CR>", { desc = "Miki: Open Journal", noremap = true, silent = true })
vim.keymap.set("n", "<leader>mf", _miki_find_pages, { desc = "Miki: Find Page", noremap = true, silent = true, buffer = false })
vim.keymap.set("n", "<leader>mt", _miki_find_tags, { desc = "Miki: Find Tag", noremap = true, silent = true })
vim.keymap.set("n", "<leader>mpp", [[:let @+=expand("%:p")<CR>]], { desc = "Miki: Copy page path to clipboard" })

local function add_autolist_keymaps()
    vim.keymap.set("n", "<leader>msc", function()
        vim.api.nvim_put({ "- [ ] " }, "c", true, true) 
        vim.cmd("startinsert") -- Enter insert mode
    end, { desc = "Create checkbox", noremap = true, silent = true })
    vim.keymap.set("n", "<leader>mst", function()
        local line = vim.api.nvim_get_current_line()
        if line:match("%- %[ %]") then
            local toggled = line:gsub("%- %[ %]", "- [x]")
            vim.api.nvim_set_current_line(toggled)
        elseif line:match("%- %[x%]") then
            local toggled = line:gsub("%- %[x%]", "- [ ]")
            vim.api.nvim_set_current_line(toggled)
        end
    end, { desc = "Miki: Toggle checkbox", noremap = true, silent = true })
end
-- stylua: ignore end

vim.keymap.set("n", "<leader>mu", function()
    local ps1_path = vim.g.miki_root .. "/parse_url.ps1"
    local handle = io.popen('pwsh -NoProfile -NoLogo -File "' .. ps1_path .. '"')
    local result = handle:read("*a")
    handle:close()
    local text = result or ""
    text = tostring(text):gsub("\r?\n$", "")
    vim.api.nvim_put({ text }, "c", true, true)
end, { desc = "Miki: paste TFS url" })

--------------------------------------------------------------
----------------------- Features -----------------------------
--------------------------------------------------------------
if config.autolist.enabled then
    add_autolist_keymaps()
end

if config.spellcheck.enabled then
    vim.cmd("setlocal spell")
    vim.cmd("setlocal spelllang=en_us,sv")
end

vim.notify("miki.lua loaded", vim.log.levels.INFO)
