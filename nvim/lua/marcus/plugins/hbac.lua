return {
    -- Heuristic buffer auto-close
    "axkirillov/hbac.nvim",
    event = "VeryLazy",
    opts = {
        autoclose = true,
        threshold = 8,
    },
    keys = {
        { "<leader>bp", "<CMD>Hbac toggle_pin<CR>", desc = "Toggle pin" },
        { "<leader>bc", "<CMD>Hbac close_unpinned<CR>", desc = "Close unpinned" },
    },
}
