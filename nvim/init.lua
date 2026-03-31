-- Marcus try on a minimal init.lua
--
-- Philosophy:
--   - Use defaults for as much as possible
--   - One file
--   -
--
-- require("marcus")

-- =================
--     Options
-- =================
vim.cmd.colorscheme('catppuccin')
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.clipboard = "unnamedplus" -- System clipboard
vim.opt.undofile = true           -- Persistent undo

vim.opt.termguicolors = true      -- Enabled true color support
vim.opt.scrolloff = 8             -- Keep X lines from top/bottom
vim.opt.sidescrolloff = 5         -- Keep X characters from the side
vim.opt.wrap = false              -- Disable wrap lines

vim.opt.ignorecase = true         -- Ignore case in search patterns
vim.opt.smartcase = true          -- Override ignorecase if search pattern contains uppercase letters
vim.opt.hlsearch = true           -- Highlight search matches
vim.opt.incsearch = true          -- Show search matches as you type
vim.opt.inccommand = "split"      -- Show search substitution in split

vim.opt.tabstop = 4               -- Number of spaces that a <Tab> counts for
vim.opt.softtabstop = 4           -- Number of spaces that a <Tab> counts for
vim.opt.shiftwidth = 4            -- Number of spaces to use for each step of (auto)indent
vim.opt.expandtab = true          -- Use spaces instead of tabs
vim.opt.smartindent = true        -- Smart autoindenting when starting a new line

vim.opt.wildmenu = true           -- Command line wild search
vim.opt.wildmode = "longest:full,full"

vim.opt.autocomplete = true       -- Enable autocompletion
vim.opt.completeopt = "fuzzy,menu,menuone,preview"
vim.opt.completetimeout = 100

vim.opt.list = true               -- Show invisible characters
vim.opt.listchars = { tab = " ", trail = "·", nbsp = "␣" }

vim.opt.signcolumn = "yes"        -- Always show signcolumn. Why?

-- =================
--     Keymaps
-- =================
local function opts(desc) return { silent = true, noremap = true, desc = desc } end
local map = vim.keymap.set

map("n", "<Esc>", "<cmd>nohlsearch<CR>", opts())
map("n", "<leader>ee", "<cmd>Explore<cr>", opts("Open file explorer"))
map("n", "<leader>ec", "<cmd>edit $MYVIMRC<cr>", opts("Edit init.lua"))

map("n", "<leader>es", "<cmd>lua MiniFiles.open()<cr>", opts("Open file explorer"))
map("n", "<C-p>", "<cmd>Pick files<cr>", opts())
map("n", "<C-f>", "<cmd>Pick grep_live<cr>", opts())
map("n", "<C-b>", "<cmd>Pick buffers<cr>", opts())
map("n", "<C-g>", "<cmd>Pick git_hunks<cr>", opts())
map({ "n", "v" }, "<C-l>", "<cmd>CopilotChatToggle<cr>", opts())

map("n", "<leader>gd", "<cmd>lua MiniDiff.toggle_overlay()<cr>", opts("Toggle git diff overlay"))

map("n", "n", "nzzzv", opts("Move to next match"))
map("n", "N", "Nzzzv", opts("Move to previous match"))
map("n", "<C-d>", "<C-d>zz", opts("Scroll down"))
map("n", "<C-u>", "<C-u>zz", opts("Scroll up"))

map("n", "<leader>cp", [[:let @+=expand("%:p")<CR>]], opts("Copy file path to clipboard"))
map("n", "<leader>cn", [[:let @+=expand("%:t")<CR>]], opts("Copy file name to clipboard"))
map("n", "<leader>cd", [[:let @+=expand("%:h")<CR>]], opts("Copy file directory to clipboard"))

map("n", "<tab>", ":bnext<CR>", opts("Next buffer"))
map("n", "<S-tab>", ":bprevious<CR>", opts("Previous buffer"))

map("n", "grd", vim.lsp.buf.definition, opts("vim.lsp.buf.definition()"))
map("n", "grf", vim.lsp.buf.format, opts("vim.lsp.buf.format()"))

map("n", "<leader>zs", "<CMD>setlocal spell! spelllang=en_us<CR>", opts("Toggle spell check"))

-- =================
--     Plugins
-- =================
vim.pack.add({
    'https://github.com/nvim-lua/plenary.nvim',                     -- Common library
    'https://github.com/nvim-mini/mini.nvim',                       -- Collection of plugins
    'https://github.com/neovim/nvim-lspconfig',                     -- Default LSP configurations
    'https://github.com/mason-org/mason.nvim',                      -- LSP/DAP/Linter/Formatter installer
    'https://github.com/mason-org/mason-lspconfig.nvim',            -- Auto enable plugins installed by mason.nvim
    'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim', -- Auto install tools installed by mason.nvim
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
    'https://github.com/nvim-treesitter/nvim-treesitter-context',   -- Show code context at time of buffer
    'https://github.com/github/copilot.vim',                        -- GitHub copilot :Copilot setup
    'https://github.com/CopilotC-Nvim/CopilotChat.nvim',            -- GitHub copilot chat :CopilotChat
})

-- Mini - A collection of plugins
require("mini.statusline").setup({}) -- Fancier statusline
require("mini.pick").setup({})       -- Picker, e.g. :Pick files, :Pick grep_live
require("mini.files").setup({        -- File explorer. :MiniFiles.open() g? to show info
    windows = {
        preview = true,
    },
})
require("mini.extra").setup({})      -- Extra functionality. E.g. :Pick git_hunks

vim.api.nvim_create_autocmd("BufReadPost", {
    once = true,
    callback = function()
        require("mini.cursorword").setup({}) -- Highlight word under cursor
        require("mini.diff").setup({})       -- Show git diff in signcolumn and MiniDiff.toggle_overlay()
        require('mini.splitjoin').setup({})  -- Split and join code blocks. gS to toggle
        require("mini.ai").setup({})         -- Extend a/i text objects
        require("mini.surround").setup({})   -- Add/change/delete surrounding pairs. E.g. sr"' to change surrounding " to '
        require("mini.align").setup({})      -- Align text by a delimiter. E.g. gaip= to align a paragraph by = signs.
        local hipatterns = require("mini.hipatterns")
        hipatterns.setup({
            highlighters = {
                hex_color = hipatterns.gen_highlighter.hex_color(),
            },
        })
    end,
})

local miniclue = require('mini.clue')
miniclue.setup({
    triggers = {
        { mode = { 'n', 'x' }, keys = '<Leader>' },
        { mode = 'n',          keys = '[' },
        { mode = 'n',          keys = ']' },
        { mode = 'i',          keys = '<C-x>' },
        { mode = { 'n', 'x' }, keys = 'g' },
        { mode = { 'n', 'x' }, keys = "'" },
        { mode = { 'n', 'x' }, keys = '`' },
        { mode = { 'n', 'x' }, keys = '"' },
        { mode = { 'i', 'c' }, keys = '<C-r>' },
        { mode = 'n',          keys = '<C-w>' },
        { mode = { 'n', 'x' }, keys = 'z' },
    },
    clues = {
        miniclue.gen_clues.square_brackets(),
        miniclue.gen_clues.builtin_completion(),
        miniclue.gen_clues.g(),
        miniclue.gen_clues.marks(),
        miniclue.gen_clues.registers(),
        miniclue.gen_clues.windows(),
        miniclue.gen_clues.z(),
        { mode = 'n', keys = '<Leader>g', desc = '+Git' },
        { mode = 'n', keys = '<Leader>e', desc = '+Explorer/Edit' },
        { mode = 'n', keys = '<Leader>c', desc = '+Copy' },
    },
})

-- Treesitter
require("nvim-treesitter").setup({}) -- :TSUpdate to update parsers

-- =================
--       LSP
-- =================
-- Find LSPs: https://microsoft.github.io/language-server-protocol/implementors/servers/

-- - "gra" (Normal and Visual mode) is mapped to |vim.lsp.buf.code_action()|
-- - "gri" is mapped to |vim.lsp.buf.implementation()|
-- - "grn" is mapped to |vim.lsp.buf.rename()|
-- - "grr" is mapped to |vim.lsp.buf.references()|
-- - "grt" is mapped to |vim.lsp.buf.type_definition()|
-- - "grx" is mapped to |vim.lsp.codelens.run()|
-- - "gO" is mapped to |vim.lsp.buf.document_symbol()|
-- - CTRL-S (Insert mode) is mapped to |vim.lsp.buf.signature_help()|

require("mason").setup({})
require("mason-lspconfig").setup({})
require("mason-tool-installer").setup({
    ensure_installed = {
        "lua-language-server",
        "pylsp",
        "clangd",
    },
})

-- =================
--     Autocmds
-- =================
-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank({ timeout = 1000 })
    end,
    desc = "Briefly highlight yanked text",
})

-- Restore cursor position when reopening files
vim.api.nvim_create_autocmd({ "BufReadPost", "BufWinEnter" }, {
    once = true,
    callback = function(args)
        local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
        local line_count = vim.api.nvim_buf_line_count(args.buf)
        if mark[1] > 0 and mark[1] <= line_count then
            vim.api.nvim_win_set_cursor(0, mark)
            vim.schedule(function()
                vim.cmd("normal! zz")
            end)
        end
    end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})
