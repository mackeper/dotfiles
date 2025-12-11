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

vim.keymap.set("n", "<leader>xg", function()
    local staged = vim.fn.systemlist("git diff --cached --name-only")
    local unstaged = vim.fn.systemlist("git diff --name-only")
    local untracked = vim.fn.systemlist("git ls-files --others --exclude-standard")
    local files = vim.tbl_extend("force", staged, unstaged, untracked)
    vim.fn.setqflist({}, "r", {
        title = "Git Changes",
        items = vim.tbl_map(function(file)
            return { filename = file }
        end, files),
    })
    vim.cmd("copen")
end, { desc = "Git Changes to Quickfix" })

local function remove_qf_entry()
    local idx = vim.fn.line(".")
    local qflist = vim.fn.getqflist()
    table.remove(qflist, idx)
    vim.fn.setqflist({}, " ", { title = vim.fn.getqflist({ title = 0 }).title, items = qflist })
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    callback = function()
        vim.keymap.set("n", "dd", remove_qf_entry, { buffer = true, silent = true })
    end,
})

-- Style
vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    callback = function()
        vim.opt_local.number = true
        vim.opt_local.signcolumn = "yes"
    end,
})
