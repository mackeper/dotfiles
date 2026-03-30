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

vim.opt.clipboard = "unnamedplus"       -- System clipboard
vim.opt.undofile = true                 -- Persistent undo

vim.opt.termguicolors = true            -- Enabled true color support
vim.opt.scrolloff = 8                   -- Keep X lines from top/bottom
vim.opt.sidescrolloff = 5               -- Keep X characters from the side
vim.opt.wrap = false                    -- Disable wrap lines

vim.opt.ignorecase = true               -- Ignore case in search patterns
vim.opt.smartcase = true                -- Override ignorecase if search pattern contains uppercase letters
vim.opt.hlsearch = true                 -- Highlight search matches
vim.opt.incsearch = true                -- Show search matches as you type
vim.opt.inccommand = "split"            -- Show search substitution in split

vim.opt.tabstop = 4                     -- Number of spaces that a <Tab> counts for
vim.opt.softtabstop = 4                 -- Number of spaces that a <Tab> counts for
vim.opt.shiftwidth = 4                  -- Number of spaces to use for each step of (auto)indent
vim.opt.expandtab = true                -- Use spaces instead of tabs
vim.opt.smartindent = true              -- Smart autoindenting when starting a new line

vim.opt.wildmenu = true                 -- Command line wild search
vim.opt.wildmode = "longest:full,full"

vim.opt.list = true                     -- Show invisible characters
vim.opt.listchars = { tab = " ", trail = "·", nbsp = "␣" }

vim.opt.signcolumn = "yes"              -- Always show signcolumn. Why?

-- =================
--     Keymaps
-- =================

local function opts(desc) return { silent = true, noremap = true, desc=desc } end
local map = vim.keymap.set

map("n", "<Esc>", "<cmd>nohlsearch<CR>", opts())
map("n", "<leader>ee", "<cmd>Explore<cr>", opts())
map("n", "<leader>zs", "<CMD>setlocal spell! spelllang=en_us<CR>", opts("Toggle spell check"))

map("n", "<C-p>", "<cmd>Pick files<cr>", opts())
map("n", "<C-f>", "<cmd>Pick grep_live<cr>", opts())
map({"n", "v"}, "<C-l>", "<cmd>CopilotChatToggle<cr>", opts())

map("v", "J", ":m '>+1<CR>gv=gv", opts("Move line/block down"))
map("v", "K", ":m '<-2<CR>gv=gv", opts("Move line/block up"))

map("n", "n", "nzzzv", opts("Move to next match") )
map("n", "N", "Nzzzv", opts("Move to previous match"))
map("n", "J", "mzJ`z", opts("Join lines"))
map("n", "<C-d>", "<C-d>zz", opts("Scroll down"))
map("n", "<C-u>", "<C-u>zz", opts("Scroll up"))

map("n", "<leader>cp", [[:let @+=expand("%:p")<CR>]], opts("Copy file path to clipboard"))
map("n", "<leader>cn", [[:let @+=expand("%:t")<CR>]], opts("Copy file name to clipboard"))
map("n", "<leader>cd", [[:let @+=expand("%:h")<CR>]], opts("Copy file directory to clipboard"))

map("n", "<tab>", ":bnext<CR>", opts("Next buffer"))
map("n", "<S-tab>", ":bprevious<CR>", opts("Previous buffer"))

-- =================
--     Plugins
-- =================

vim.pack.add({
    'https://github.com/nvim-lua/plenary.nvim',          -- Common library
    'https://github.com/nvim-mini/mini.nvim',            -- Collection of plugins
    'https://github.com/neovim/nvim-lspconfig',          -- Default LSP configurations
    'https://github.com/mason-org/mason.nvim',
    'https://github.com/mason-org/mason-lspconfig.nvim',
    'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/nvim-treesitter/nvim-treesitter-context',
    'https://github.com/saghen/blink.cmp',               -- Auto complete engine
    'https://github.com/lewis6991/gitsigns.nvim',
    'https://github.com/github/copilot.vim',             -- GitHub copilot :Copilot setup
    'https://github.com/CopilotC-Nvim/CopilotChat.nvim', -- GitHub copilot chat :CopilotChat
})

-- Mini
require("mini.statusline").setup({})    -- Fancier statusline
require("mini.pick").setup({})          -- Picker

vim.api.nvim_create_autocmd("BufReadPost", {
    once = true,
    callback = function()
        require("mini.cursorword").setup({})    -- Highlight word under cursor
        require("mini.ai").setup({})            -- Extend a/i text objects
        require("mini.surround").setup({})      -- Add/change/delete surrounding pairs. E.g. sr"' to change surrounding " to '
        require("mini.align").setup({})         -- Align text by a delimiter. E.g. gaip= to align a paragraph by = signs.
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
        { mode = 'n', keys = '[' },
        { mode = 'n', keys = ']' },
        { mode = 'i', keys = '<C-x>' },
        { mode = { 'n', 'x' }, keys = 'g' },
        { mode = { 'n', 'x' }, keys = "'" },
        { mode = { 'n', 'x' }, keys = '`' },
        { mode = { 'n', 'x' }, keys = '"' },
        { mode = { 'i', 'c' }, keys = '<C-r>' },
        { mode = 'n', keys = '<C-w>' },
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
    },
})
-- Treesitter
-- vim.api.nvim_create_autocmd('PackChanged', { callback = function(ev)
--   local name, kind = ev.data.spec.name, ev.data.kind
--   if name == 'nvim-treesitter' and kind == 'update' then
--     if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
--     vim.cmd('TSUpdate')
--   end
-- end })

-- require("nvim-treesitter.install").update("all") -- Same as :TSUpdate
-- require("nvim-treesitter.configs").setup({
--   auto_install = true, -- autoinstall languages that are not installed yet
-- })

-- Blink
vim.api.nvim_create_autocmd("InsertEnter", {
  once = true,
  callback = function()
      require("blink.cmp").setup({
          completion = {
              documentation = {
                  auto_show = true,
              },
          },
          fuzzy = {
              implementation = "lua",
          },
      })
  end,
})


-- gitsigns
vim.api.nvim_create_autocmd("BufReadPost", {
  once = true,
  callback = function()
    require('gitsigns').setup({
      current_line_blame = true,
    })
  end,
})

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

local lsp_servers = {
  lua_ls = {
    -- https://luals.github.io/wiki/settings/ | `:h nvim_get_runtime_file`
    Lua = { workspace = { library = vim.api.nvim_get_runtime_file("lua", true) }, },
  },
}

vim.api.nvim_create_user_command("MasonSetup", function()
  require("mason").setup({})
  require("mason-lspconfig").setup({})
  require("mason-tool-installer").setup({
    ensure_installed = vim.tbl_keys(lsp_servers),
  })
end, {})

for server, config in pairs(lsp_servers) do
  vim.lsp.config(server, {
    settings = config,

    -- only create the keymaps if the server attaches successfully
    on_attach = function(_, bufnr)
      vim.keymap.set("n", "grd", vim.lsp.buf.definition,
        { buffer = bufnr, desc = "vim.lsp.buf.definition()", })

      vim.keymap.set("n", "grf", vim.lsp.buf.format,
        { buffer = bufnr, desc = "vim.lsp.buf.format()", })
    end,
  })
end
