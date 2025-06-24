-- vim.keymap.set("n", "<leader>je", vim.cmd.Explore)

-- Auto clear highlights
vim.ke ymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear highlights" })

-- Toggle spell check
vim.keymap.set("n", "<leader>zs", "<CMD>setlocal spell! spelllang=en_us<CR>", { desc = "Toggle spell check" })

-- Move selected line / block up or down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line/block down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line/block up" })

-- Keep cursor in the middle
vim.keymap.set("n", "n", "nzzzv", { desc = "Move to next match" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Move to previous match" })
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up" })

-- Paste / delete without overwriting the default register
vim.keymap.set("v", "<leader>d", '"_d', { desc = "Delete without overwriting default register" })

-- Start substitute with the word under cursor
vim.keymap.set(
    "n",
    "<leader>rw",
    [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "Substitute word under cursor" }
)

-- Open, Windows specific
vim.keymap.set(
    "n",
    "<leader>oe",
    [[<CMD>!start explorer /select,"%":p<CR>]],
    { desc = "Open in explorer", silent = true }
)

-- File
vim.keymap.set("n", "<leader>cp", [[:let @+=expand("%:p")<CR>]], { desc = "Copy file path to clipboard" })
vim.keymap.set("n", "<leader>zz", ":source " .. vim.fn.stdpath("config") .. "/init.lua<CR>", { desc = "Reload config" })
vim.keymap.set("n", "<C-s>", ":w<CR>", { desc = "Save" })
vim.keymap.set("n", "<C-q>", ":wq<CR>", { desc = "Save and quit" })

-- Tabs
vim.keymap.set("n", "<leader>tn", ":tabnew<CR>", { desc = "New tab" })
vim.keymap.set("n", "<leader>tc", ":tabclose<CR>", { desc = "Close tab" })
vim.keymap.set("n", "<leader>to", ":tabonly<CR>", { desc = "Close other tabs" })
vim.keymap.set("n", "<leader>tl", ":tabnext<CR>", { desc = "Next tab" })
vim.keymap.set("n", "<leader>th", ":tabprevious<CR>", { desc = "Previous tab" })
-- vim.keymap.set("n", "<tab>", ":tabnext<CR>", { desc = "Next tab" })
-- vim.keymap.set("n", "<S-tab>", ":tabprevious<CR>", { desc = "Previous tab" })

-- Buffers
vim.keymap.set("n", "<leader>bl", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bh", ":bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })
vim.keymap.set("n", "<leader>bo", ":bufdo bd<CR>", { desc = "Delete all buffers" })
vim.keymap.set("n", "<leader>bn", ":enew<CR>", { desc = "New buffer" })
vim.keymap.set("n", "<tab>", ":bnext<CR>", { desc = "Next buffer", silent = true })
vim.keymap.set("n", "<S-tab>", ":bprevious<CR>", { desc = "Previous buffer", silent = true })

-- Window navigation
-- Disable because it's already mapped in vim-tmux-navigator
-- vim.keymap.set("n", "<C-left>", "<C-w>h", { desc = "Move to left window" })
-- vim.keymap.set("n", "<C-down>", "<C-w>j", { desc = "Move to bottom window" })
-- vim.keymap.set("n", "<C-up>", "<C-w>k", { desc = "Move to top window" })
-- vim.keymap.set("n", "<C-right>", "<C-w>l", { desc = "Move to right window" })
vim.keymap.set("n", "<leader>ws", "<C-w>s", { desc = "Split window horizontally" })
vim.keymap.set("n", "<leader>wv", "<C-w>v", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>wc", "<C-w>c", { desc = "Close window" })
vim.keymap.set("n", "<leader>wo", "<C-w>o", { desc = "Close other windows" })
vim.keymap.set("n", "<leader>wd", ":windo diffthis", { desc = "Diff windows" })
vim.keymap.set("n", "<leader>wu", ":windo diffoff", { desc = "Undo diff windows" })

-- Terminal
vim.keymap.set("t", "jk", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Run file
local function runFile()
    vim.cmd("silent w")
    if vim.bo.filetype == "python" then
        vim.cmd("!python3 %")
    elseif vim.bo.filetype == "lua" then
        vim.cmd("exec '!lua " .. vim.fn.expand("%") .. "'")
    elseif vim.bo.filetype == "cs" then
        vim.cmd("!dotnet run")
    elseif vim.bo.filetype == "sh" then
        vim.cmd("!bash %")
    elseif vim.bo.filetype == "c" then
        vim.cmd("make")
    elseif vim.bo.filetype == "ocaml" then
        vim.cmd("dune build")
    else
        print("Cannot run file of type: " .. vim.bo.filetype)
    end
end
vim.keymap.set("n", "<leader>ef", runFile, { desc = "Run file" })

-- Code
vim.api.nvim_create_user_command("GetUuid", function()
    vim.fn.setreg("+", vim.fn.systemlist("python3 -c 'import uuid; print(uuid.uuid4(), end=\"\")'"))
    vim.cmd('normal! "+p')
end, {})

vim.keymap.set("n", "<leader>ru", ":GetUuid<CR>", { desc = "Generate UUID" })
