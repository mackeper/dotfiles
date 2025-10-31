-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- statusline
vim.opt.laststatus = 3
vim.opt.showtabline = 2
vim.opt.showcmd = true

-- Line numbers
vim.opt.number = false
vim.opt.relativenumber = false

-- Indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
-- JavaScript / TypeScript
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "javascript", "typescript" },
    callback = function()
        print("Setting JavaScript/TypeScript indent")
        vim.opt_local.tabstop = 2
        vim.opt_local.softtabstop = 2
        vim.opt_local.shiftwidth = 2
    end,
})

-- Wrap lines
vim.opt.wrap = false

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.inccommand = "split"
_G.basic_excludes = { ".git", "*.egg-info", "__pycache__", "wandb", "target" }
_G.ext_excludes = vim.list_extend(vim.deepcopy(_G.basic_excludes), { ".venv" })

-- Colors
vim.opt.termguicolors = true
vim.opt.showmode = false

-- UI
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 5
vim.opt.breakindent = true
-- vim.opt.winborder = "rounded" -- Does not work well with wilder

vim.opt.list = true
vim.opt.listchars = { tab = "󰅂 ", trail = "·", nbsp = "␣" }

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
if vim.fn.has("wsl") then
    vim.g.clipboard = {
        name = "WslClipboard",
        copy = {
            ["+"] = "win32yank.exe -i --crlf",
            ["*"] = "win32yank.exe -i --crlf",
        },
        paste = {
            ["+"] = "win32yank.exe -o --lf",
            ["*"] = "win32yank.exe -o --lf",
        },
        cache_enabled = 0,
    }
end

-- Spellcheck (z=) for suggestions
vim.opt.spell = false
vim.opt.spelllang = "en_us"

-- Terminal
-- vim.g.terminal_emulator = "powershell"
-- vim.opt.shell = "powershell"
if jit.os == "Windows" then
    vim.opt.shellpipe = ">"
    vim.opt.shellredir = ">"
end
vim.api.nvim_create_autocmd("TermOpen", {
    pattern = "*",
    callback = function()
        vim.cmd("startinsert")
        vim.cmd("setlocal nonumber norelativenumber")
    end,
})
