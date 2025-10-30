vim.keymap.set("n", "<leader>xx", ":copen<CR>", { desc = "Open Quickfix List" })
vim.keymap.set("n", "<leader>xc", ":cclose<CR>", { desc = "Close Quickfix List" })
vim.keymap.set("n", "]q", ":cnext<CR>", { desc = "Next Quickfix Item" })
vim.keymap.set("n", "[q", ":cprev<CR>", { desc = "Previous Quickfix Item" })

vim.keymap.set("n", "<leader>xd", function()
    vim.diagnostic.setqflist({ open = true })
end, { desc = "Diagnostics to Quickfix" })

vim.keymap.set("n", "<leader>xl", ":lopen<CR>", { desc = "Open Location List" })
vim.keymap.set("n", "<leader>xc", ":lclose<CR>", { desc = "Close Location List" })

vim.keymap.set("n", "<leader>xs", ":grep <C-r><C-w><CR>:copen<CR>", { desc = "Search Word in Project" })

-- "q" to close quickfix window
vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    callback = function()
        vim.keymap.set("n", "q", ":cclose<CR>", { buffer = true, desc = "Close Quickfix List" })
    end,
})
