-- Set leader key
vim.g.mapleader = " "

-- statusline
vim.opt.laststatus = 3

-- Line numbers
vim.opt.nu = true
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
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Colors
vim.opt.termguicolors = true
vim.opt.showmode = false

-- UI
vim.opt.scrolloff = 8

vim.api.nvim_create_autocmd("WinEnter", {
    callback = function() vim.opt.cursorline = true end
})
vim.api.nvim_create_autocmd("WinLeave", {
    callback = function() vim.opt.cursorline = false end
})

-- Misc
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

-- Clipboard
vim.opt.clipboard = "unnamedplus"


-- Spellcheck (z=) for suggestions
vim.opt.spell = false
vim.opt.spelllang = "en_us"

-- Terminal
vim.g.terminal_emulator = "powershell"
vim.opt.shell = "powershell"
