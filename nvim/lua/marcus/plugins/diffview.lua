return {
    "sindrets/diffview.nvim",
    lazy = true,
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        vim.keymap.set("n", "<leader>gd", function()
            vim.cmd(":DiffviewOpen")
        end, { desc = "Open Diff" })

        vim.keymap.set("n", "<leader>gc", function()
            vim.cmd(":DiffviewClose")
        end, { desc = "Close Diff" })
    end,
}
