-- Marcus try on a minimal init.lua
--
-- Philosophy:
--   - Use defaults for as much as possible.
--   - Try to reduce dependencies on plugins.
--   - One file.
--
-- TODO:
--  - Terminal use
--  - Replace blink.cmp with mini.completion if I can get it to work
--  - More snippets, especially for markdown
--  - mini.git?
--  - Replace mini.sessions with native

-- ================================================
--                   Options
-- ================================================

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- UI
-- [bufnr] filepath [flags] | | [ft] (row,col-Vcol) tLines percentage%
vim.opt.statusline = "[%n] %<%f %h%w%m%r%q%=%=%y %-14.(%l,%c%V%) %L %P"
vim.opt.list = true -- Show invisible characters
vim.opt.listchars = { tab = " ", trail = "·", nbsp = "␣" }
vim.opt.signcolumn = "yes" -- Always show signcolumn.
vim.cmd.colorscheme("catppuccin")

-- Editing
vim.opt.clipboard = "unnamedplus" -- System clipboard
vim.opt.wrap = false -- Disable wrap lines
vim.opt.scrolloff = 8 -- Keep X lines from top/bottom
vim.opt.sidescrolloff = 8 -- Keep X characters from the side
vim.opt.undofile = true -- Persistent undo
vim.opt.spelllang = { "en_us", "sv" }
vim.opt.fixendofline = false -- Don't automatically add newline at end of file

-- Search
vim.opt.ignorecase = true -- Ignore case in search patterns
vim.opt.smartcase = true -- Override ignorecase if search pattern contains uppercase letters
vim.opt.hlsearch = true -- Highlight search matches
vim.opt.incsearch = true -- Show search matches as you type
vim.opt.inccommand = "split" -- Show search substitution in split

vim.opt.grepprg = "rg --vimgrep --smart-case"

-- Indentation
vim.opt.tabstop = 4 -- Number of spaces that a <Tab> counts for
vim.opt.softtabstop = 4 -- Number of spaces that a <Tab> counts for
vim.opt.shiftwidth = 4 -- Number of spaces to use for each step of (auto)indent
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.smartindent = true -- Smart autoindenting when starting a new line

-- Command
vim.opt.wildmenu = true -- Command line wild search
vim.opt.wildmode = "longest:full,full"

-- Completion (using blink.cmp)
-- vim.opt.autocomplete = true -- Enable autocompletion
-- vim.opt.completeopt = "fuzzy,menu,menuone,preview"

-- ================================================
--                   Keymaps
-- ================================================
local function opts(desc, extra)
    return vim.tbl_extend("force", { silent = true, noremap = true, desc = desc }, extra or {})
end
local map = vim.keymap.set

-- Explorer
map("n", "<leader>ee", "<cmd>Explore<cr>", opts("Open file explorer"))
map("n", "<leader>ec", "<cmd>edit $MYVIMRC<cr>", opts("Edit init.lua"))
map("n", "<leader>eu", "<cmd>lua require('undotree').open()<cr>", opts("Toggle undotree"))
map("n", "<leader>er", "<cmd>lua MiniSessions.restart()<CR>", opts("Restart nvim"))

-- Editing
map("n", "<leader>ew",
    [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    opts("Substitute word under cursor", { silent = false }))

-- Search
map("n", "<Esc>", "<cmd>nohlsearch<CR>", opts())
map("n", "<leader>es", "<cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0), false)<cr>", opts("Open file explorer"))
map("n", "<C-p>", "<cmd>Pick files<cr>", opts())
map("n", "<C-f>", "<cmd>Pick grep_live<cr>", opts())
map("n", "<C-b>", "<cmd>Pick buffers<cr>", opts())
map("n", "<C-g>", "<cmd>Pick git_hunks<cr>", opts())
map("n", "<M-r>", "<cmd>Pick visit_paths<cr>", opts())
map("n", "<leader>fh", "<cmd>Pick help<cr>", opts("Search help"))
map("n", "<leader>fw", "<cmd>Pick grep pattern='<cword>'<cr>", opts("Grep word"))
map("n", "<leader>fW", "<cmd>Pick grep pattern=[[(([^n][^e][^w])\\s+<cword>\\s*\\\\\\(|class.*<cword>\\s|<cword>\\s\\{)]]<cr>", opts("Grep C function"))
map("n", "<leader>ff", "<cmd>Pick resume<cr>", opts("Resume last picker"))

-- AI
map({ "n", "v" }, "<C-l>", "<cmd>CopilotChatToggle<cr>", opts())
vim.keymap.set("i", "<M-l>", 'copilot#Accept("\\<CR>")', {
    expr = true,
    replace_keycodes = false,
})
vim.g.copilot_no_tab_map = true

-- Git
map("n", "<leader>gd", "<cmd>lua MiniDiff.toggle_overlay()<cr>", opts("Toggle git diff overlay"))

-- Navigation
map("n", "n", "nzzzv", opts("Move to next match"))
map("n", "N", "Nzzzv", opts("Move to previous match"))
map("n", "<C-d>", "<C-d>zz", opts("Scroll down"))
map("n", "<C-u>", "<C-u>zz", opts("Scroll up"))

map("n", "<C-Left>", "<C-w>h", opts("Window left"))
map("n", "<C-Down>", "<C-w>j", opts("Window down"))
map("n", "<C-Up>", "<C-w>k", opts("Window up"))
map("n", "<C-Right>", "<C-w>l", opts("Window right"))

map("n", "<tab>", ":bnext<CR>", opts("Next buffer"))
map("n", "<S-tab>", ":bprevious<CR>", opts("Previous buffer"))

vim.api.nvim_create_autocmd("FileType", {
    pattern = "cs",
    callback = function()
        local scope_pattern = [[\(public\|private\|protected\|class\|interface\|struct\|enum\)]]
        map("n", "[[", "?^\\s*" .. scope_pattern .. "<CR>:nohl<CR>", { buffer = true })
        map("n", "]]", "/^\\s*" .. scope_pattern .. "<CR>:nohl<CR>", { buffer = true })
    end,
})

-- Terminal
map("n", "<C-space>", "<cmd>terminal<CR>", opts("Open terminal"))
map("t", "<Esc><Esc>", "<C-\\><C-n>", opts("Exit terminal mode"))
map("t", "<C-Left>", "<C-\\><C-O><C-w>h<esc>", opts("Window left"))
map("t", "<C-Down>", "<C-\\><C-O><C-w>j<esc>", opts("Window down"))
map("t", "<C-Up>", "<C-\\><C-O><C-w>k<esc>", opts("Window up"))
map("t", "<C-Right>", "<C-\\><C-O><C-w>l<esc>", opts("Window right"))

-- Copying
map("n", "<leader>cp", [[:let @+=expand("%:p")<CR>]], opts("Copy file path to clipboard"))
map("n", "<leader>cn", [[:let @+=expand("%:t")<CR>]], opts("Copy file name to clipboard"))
map("n", "<leader>cd", [[:let @+=expand("%:h")<CR>]], opts("Copy file directory to clipboard"))

-- Pasting
map( "n", "<leader>p",
    function()
        local text = vim.fn.getreg("+"):gsub("[ :]", "_")
        vim.api.nvim_put({text}, "c", true, true)
    end,
    opts("Paste replacing spaces with _"))

-- LSP
map("n", "grd", vim.lsp.buf.definition, opts("vim.lsp.buf.definition()"))
map("n", "grf", vim.lsp.buf.format, opts("vim.lsp.buf.format()"))

-- Spell check
map("n", "<leader>zs", "<CMD>setlocal spell!<CR>", opts("Toggle spell check"))

-- Sessions
map("n", "<leader>sl", "<CMD>lua MiniSessions.read(MiniSessions.get_latest())<CR>", opts("Load last session"))
map("n", "<leader>ss", "<CMD>lua MiniSessions.select()<CR>", opts("Select session"))

-- Quickfix list
map("n", "<leader>qq", "<cmd>copen<CR>", opts("Open quickfix"))
vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    callback = function(e)
        map("n", "q", "<cmd>cclose<CR>", opts("Close quickfix", { buffer = e.buf }))
        map("n", "dd", function()
            local row = vim.fn.line(".")
            local qf = vim.fn.getqflist()
            table.remove(qf, row)
            vim.fn.setqflist(qf, "r")
            vim.cmd("copen")
            local new_row = math.min(row, #qf)
            if new_row > 0 then
                vim.api.nvim_win_set_cursor(0, { new_row, 0 })
            end
        end, opts("Delete qf entry", { buffer = e.buf }))
    end,
})

-- wiki
local wiki = vim.fn.expand("~/git/wiki")
if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
    wiki = "C:\\git\\wiki"
end
map("n", "<leader>ww", "<cmd>edit " .. wiki .. "/index.md<CR>:lcd %:p:h<CR>", opts("Open wiki index"))
map(
    "n",
    "<leader>wj",
    "<cmd>edit " .. wiki .. "/98_Journal/" .. os.date("%Y-%m-%d") .. ".md<CR>:lcd %:p:h<CR>",
    opts("Open wiki journal")
)
map("n", "<leader>wc", "<cmd>edit " .. wiki .. "/01_Work/current.md<CR>:lcd %:p:h<CR>", opts("Open wiki current work"))
map("n", "<M-t>", function()
    vim.cmd([[s/\v[-*] \[\zs[ x]\ze\]/\=submatch(0) ==# 'x' ? ' ' : 'x'/]])
end, opts("Toggle checkbox"))

-- Harpoon
map("n", "<leader>a", "<cmd>$argadd %<cr><cmd>argdedup<cr>", opts("Harpoon add current file"))
map("n", "<leader>h", "<cmd>silent! 1argument<cr>", opts("Harpoon 1"))
map("n", "<leader>j", "<cmd>silent! 2argument<cr>", opts("Harpoon 2"))
map("n", "<leader>k", "<cmd>silent! 3argument<cr>", opts("Harpoon 3"))
map("n", "<leader>l", "<cmd>silent! 4argument<cr>", opts("Harpoon 4"))
map("n", "<leader>;", "<cmd>silent! 5argument<cr>", opts("Harpoon 5"))

-- ================================================
--                   Plugins
-- ================================================
vim.pack.add({
    "https://github.com/nvim-lua/plenary.nvim", -- Common library
    "https://github.com/nvim-mini/mini.nvim", -- Collection of plugins
    "https://github.com/neovim/nvim-lspconfig", -- Default LSP configurations
    "https://github.com/mason-org/mason.nvim", -- LSP/DAP/Linter/Formatter installer
    "https://github.com/mason-org/mason-lspconfig.nvim", -- Auto enable plugins installed by mason.nvim
    "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim", -- Auto install tools installed by mason.nvim
    "https://github.com/github/copilot.vim", -- GitHub copilot :Copilot setup
    "https://github.com/CopilotC-Nvim/CopilotChat.nvim", -- GitHub copilot chat :CopilotChat
    "https://github.com/saghen/blink.cmp", -- Completion (cannot get mini.completion to work)
})
vim.cmd.packadd("cfilter") -- filder quickfix list.
vim.cmd.packadd("nvim.undotree") -- UI to navigate undo tree.
vim.cmd.packadd("nvim.difftool") -- not sure

vim.api.nvim_create_user_command("VimPackList", function()
    for _, value in ipairs(vim.pack.get()) do
        print(value.spec.name)
    end
end, { desc = "List plugins" })


-- Blink
if not vim.g.vscode then -- Unfortunately, vscode at work
    vim.api.nvim_create_autocmd("BufReadPost", {
        once = true,
        callback = function()
            require("blink.cmp").setup({
                completion = {
                    documentation = { auto_show = true, },
                },
                snippets = {
                    expand = function(snippet)
                        MiniSnippets.default_insert({ body = snippet })
                    end,
                },
                signature = { enabled = true },
                fuzzy = {
                    implementation = "lua",
                },
            })
        end,
    })
end

-- Mini - A collection of plugins
require("mini.pick").setup({
    window = { config = { width = 100, height = 30 } },
    mappings = {
        choose_marked = '<C-q>',  -- send marked to quickfix
    },
}) -- Picker, e.g. :Pick files, :Pick grep_live
require("mini.files").setup({ -- File explorer. :MiniFiles.open() g? to show info
    windows = {
        preview = true,
        width_preview = 80,
    },
    mappings = {
        go_in_plus = "<CR>",
        go_out = "-",
    },
})
require("mini.visits").setup({})   -- Track file visits and jump to them. E.g. :Visit
require("mini.extra").setup({})    -- Extra functionality. E.g. :Pick git_hunks
require("mini.sessions").setup({}) -- Session management.

vim.api.nvim_create_autocmd({"BufReadPost", "BufNewFile"}, {
    once = true,
    callback = function()
        require("mini.cursorword").setup({}) -- Highlight word under cursor
        require("mini.diff").setup({})       -- Show git diff in signcolumn and MiniDiff.toggle_overlay()
        require("mini.splitjoin").setup({})  -- Split and join code blocks. gS to toggle
        require("mini.ai").setup({})         -- Extend a/i text objects
        require("mini.surround").setup({})   -- Add/change/delete surrounding pairs. E.g. sr"' to change surrounding " to '
        require("mini.align").setup({})      -- Align text by a delimiter. E.g. gaip= to align a paragraph by = signs.
        local hipatterns = require("mini.hipatterns")
        hipatterns.setup({
            highlighters = {
                hex_color = hipatterns.gen_highlighter.hex_color(),
            },
        })
        local gen_loader = require("mini.snippets").gen_loader
        require("mini.snippets").setup({
            snippets = {
                gen_loader.from_file(vim.fn.stdpath("config") .. "/snippets/global.json"),
                gen_loader.from_lang(),
            },
        })
        MiniSnippets.start_lsp_server()
    end,
})

local miniclue = require("mini.clue")
miniclue.setup({
    triggers = {
        { mode = { "n", "x" }, keys = "<Leader>" },
        { mode = "n", keys = "[" },
        { mode = "n", keys = "]" },
        { mode = "i", keys = "<C-x>" },
        { mode = { "n", "x" }, keys = "g" },
        { mode = { "n", "x" }, keys = "'" },
        { mode = { "n", "x" }, keys = "`" },
        { mode = { "n", "x" }, keys = '"' },
        { mode = { "i", "c" }, keys = "<C-r>" },
        { mode = "n", keys = "<C-w>" },
        { mode = { "n", "x" }, keys = "z" },
    },
    clues = {
        miniclue.gen_clues.square_brackets(),
        miniclue.gen_clues.builtin_completion(),
        miniclue.gen_clues.g(),
        miniclue.gen_clues.marks(),
        miniclue.gen_clues.registers(),
        miniclue.gen_clues.windows(),
        miniclue.gen_clues.z(),
        { mode = "n", keys = "<Leader>g", desc = "+Git" },
        { mode = "n", keys = "<Leader>e", desc = "+Explorer/Edit" },
        { mode = "n", keys = "<Leader>c", desc = "+Copy" },
        { mode = "n", keys = "<Leader>w", desc = "+Wiki" },
        { mode = "n", keys = "<Leader>q", desc = "+Quickfix" },
        { mode = "n", keys = "<Leader>z", desc = "+Spell check" },
        { mode = "n", keys = "<Leader>f", desc = "+Find" },
        { mode = "n", keys = "<Leader>s", desc = "+Session" },
    },
})

-- ================================================
--                     LSP
-- ================================================
require("mason").setup({})
require("mason-lspconfig").setup({})
require("mason-tool-installer").setup({
    ensure_installed = {
        "bashls",
        "clangd",
        "lua-language-server",
        "powershell_es",
        "pylsp",
        "stylua",
        "tinymist",
        "prettierd",
        "shfmt",
    },
})

-- vim.api.nvim_create_autocmd("LspAttach", {
--     callback = function(args)
--         local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
--         if client:supports_method("textDocument/completion") then
--             vim.lsp.completion.enable(true, client.id, args.buf)
--         end
--     end,
-- })

-- ================================================
--                 Autocmds
-- ================================================
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank({ timeout = 1000 })
    end,
})

-- Restore cursor position when reopening files
vim.opt.viewoptions = "folds,cursor" -- what gets saved in the session
vim.api.nvim_create_autocmd("BufWinLeave", { command = "silent! mkview" })
vim.api.nvim_create_autocmd("BufWinEnter", { command = "silent! loadview" })

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "markdown", "text", "gitcommit" },
    command = "setlocal spell",
})

vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
        MiniSessions.write(vim.fn.fnamemodify(vim.fn.getcwd(), ":t") .. ".vim")
    end,
})

--- =============================================
---                ui2
--- =============================================
-- Experimental UI2: floating cmdline and messages
-- https://www.reddit.com/r/neovim/comments/1sfmgkb/comment/oeyrgua/?context=3
vim.o.cmdheight = 1
require("vim._core.ui2").enable({
    enable = true,
    msg = {
        targets = {
            [""] = "msg",
            empty = "cmd",
            bufwrite = "msg",
            confirm = "cmd",
            emsg = "pager",
            echo = "msg",
            echomsg = "msg",
            echoerr = "pager",
            completion = "cmd",
            list_cmd = "pager",
            lua_error = "pager",
            lua_print = "msg",
            progress = "pager",
            rpc_error = "pager",
            quickfix = "msg",
            search_cmd = "cmd",
            search_count = "cmd",
            shell_cmd = "pager",
            shell_err = "pager",
            shell_out = "pager",
            shell_ret = "msg",
            undo = "msg",
            verbose = "pager",
            wildlist = "cmd",
            wmsg = "msg",
            typed_cmd = "cmd",
        },
        cmd = {
            height = 0.5,
        },
        dialog = {
            height = 0.5,
        },
        msg = {
            height = 0.3,
            timeout = 5000,
        },
        pager = {
            height = 0.5,
        },
    },
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "msg",
    callback = function()
        local ui2 = require("vim._core.ui2")
        local win = ui2.wins and ui2.wins.msg
        if win and vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_set_option_value(
                "winhighlight",
                "Normal:NormalFloat,FloatBorder:FloatBorder",
                { scope = "local", win = win }
            )
        end
    end,
})

local ui2 = require("vim._core.ui2")
local msgs = require("vim._core.ui2.messages")
local orig_set_pos = msgs.set_pos
msgs.set_pos = function(tgt)
    orig_set_pos(tgt)
    if (tgt == "msg" or tgt == nil) and vim.api.nvim_win_is_valid(ui2.wins.msg) then
        pcall(vim.api.nvim_win_set_config, ui2.wins.msg, {
            relative = "editor",
            anchor = "NE",
            row = 1,
            col = vim.o.columns - 1,
            border = "rounded",
        })
    end
end
