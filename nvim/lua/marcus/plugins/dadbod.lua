return {
    -- SQL Database UI
    "kristijanhusak/vim-dadbod-ui",
    enabled = false,
    dependencies = {
        "tpope/vim-dadbod",
        "kristijanhusak/vim-dadbod-completion",
    },

    keys = {
        { "<leader>zd", "<cmd>DBUIToggle<CR>", mode = "n", desc = "Toggle DBUI" },
    },
}
