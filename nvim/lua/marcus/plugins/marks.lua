return {
    "chentoast/marks.nvim",
    lazy = true,
    event = "VeryLazy",
    config = function()
        require("marks").setup()
    end,
}
