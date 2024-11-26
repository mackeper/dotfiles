return {
    "stevearc/oil.nvim",
    opts = {
        view_options = {
            show_hidden = true,
        },
    },
    -- Optional dependencies
    dependencies = { "echasnovski/mini.icons" },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
    keys = {
        { "<leader>ee", "<cmd>Oil<CR>", mode = "n", desc = "Open Oil" },
    },
}
