-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- statusline
vim.opt.laststatus = 3
vim.opt.showtabline = 2
vim.opt.showcmd = true

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Wrap lines
vim.opt.wrap = false

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.inccommand = 'split'

-- Colors
vim.opt.termguicolors = true
vim.opt.showmode = false

-- UI
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 5
vim.opt.breakindent = true

vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.api.nvim_create_autocmd("WinEnter", {
    callback = function()
        vim.opt.cursorline = true
    end,
})
vim.api.nvim_create_autocmd("WinLeave", {
    callback = function()
        vim.opt.cursorline = false
    end,
})

-- https://neovim.io/doc/user/lua-guide.html#lua-guide-autocommand-create
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank({ timeout = 1000 })
    end,
    desc = "Briefly highlight yanked text",
})

-- Windows
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Vertical split help
vim.api.nvim_create_autocmd("FileType", {
    pattern = "help",
    callback = function()
        vim.cmd("wincmd L")
        vim.cmd("vert resize 100")
    end,
})

-- Misc
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.undofile = true

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Spellcheck (z=) for suggestions
vim.opt.spell = false
vim.opt.spelllang = "en_us"

-- Terminal
-- vim.g.terminal_emulator = "powershell"
-- vim.opt.shell = "powershell"
