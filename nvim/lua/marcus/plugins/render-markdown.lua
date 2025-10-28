return {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "copilot-chat" },
    event = "BufReadPost",
    opts = {
        file_types = {
            "markdown",
            "copilot-chat",
        },
        anti_conceal = {
            enabled = false,
        },
    },
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "echasnovski/mini.nvim",
    },
}
