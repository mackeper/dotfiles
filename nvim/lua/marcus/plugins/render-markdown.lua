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
            icons = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎱 ", "󰎳 " },
            position = "inline",
            width = "block",
            min_width = 64,
            right_pad = 1,
        },
        link = {
            footnote = {
                icon = "",
            },
            image = "",
            email = "",
            hyperlink = "",
            url = "",
            wiki = {
                icon = "",
            },
            custom = {},
        },
    },
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "echasnovski/mini.nvim",
    },
}
