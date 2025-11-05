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
        heading = {
            position = "inline",
            width = "block",
            min_width = 64,
            right_pad = 1,
        },
        code = {
            border = "thick",
        },
        latex = {
            enabled = true, -- Needs utftex or latex2text
        },
    },
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "echasnovski/mini.nvim",
    },
}
