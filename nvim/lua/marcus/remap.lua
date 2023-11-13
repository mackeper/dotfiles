-- vim.keymap.set("n", "<leader>je", vim.cmd.Explore)

vim.keymap.set("n", "<C-s>", ":w<CR>", { desc = "Save" })
vim.keymap.set("n", "<C-q>", ":wq<CR>", { desc = "Save and quit" })

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
vim.keymap.set("x", "<leader>p", "\"_dP", { desc = "Paste without overwriting default register" })
vim.keymap.set("n", "<leader>d", "\"_d", { desc = "Delete without overwriting default register" })
vim.keymap.set("v", "<leader>d", "\"_d", { desc = "Delete without overwriting default register" })

-- Start substitute with the word under cursor
vim.keymap.set("n", "<leader>rw", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Substitute word under cursor" })

-- Open, Windows specific
vim.keymap.set("n", "<leader>oe", [[<CMD>!start explorer /select,"%":p<CR>]], { desc = "Open in explorer", silent = true })

-- Window navigation
vim.keymap.set("n", "<C-left>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-down>", "<C-w>j", { desc = "Move to bottom window" })
vim.keymap.set("n", "<C-up>", "<C-w>k", { desc = "Move to top window" })
vim.keymap.set("n", "<C-right>", "<C-w>l", { desc = "Move to right window" })

-- Terminal
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
