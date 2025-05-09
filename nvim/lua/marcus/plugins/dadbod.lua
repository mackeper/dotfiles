return {
    "kristijanhusak/vim-dadbod-ui",

    dependencies = {
        "tpope/vim-dadbod",
        "kristijanhusak/vim-dadbod-completion",
    },

    keys = {
        { "<leader>zd", "<cmd>DBUIToggle<CR>", mode = "n", desc = "Toggle DBUI" },
    },
}
