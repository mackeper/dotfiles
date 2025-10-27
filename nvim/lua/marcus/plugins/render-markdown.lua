return {
    "MeanderingProgrammer/render-markdown.nvim",
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
