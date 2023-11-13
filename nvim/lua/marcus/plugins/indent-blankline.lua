return {
    "lukas-reineke/indent-blankline.nvim",
    enabled = false,
    main = "ibl",
    lazy = true,
    event = "VeryLazy",
    opts = {},
    dependencies = {
        "HiPhish/rainbow-delimiters.nvim",
    },
    config = function()
        local highlight = {
            "RainbowRed",
            "RainbowYellow",
            "RainbowBlue",
            "RainbowOrange",
            "RainbowGreen",
            "RainbowViolet",
            "RainbowCyan",
        }

        local hooks = require "ibl.hooks"
        -- create the highlight groups in the highlight setup hook, so they are reset
        -- every time the colorscheme changes
        hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
            vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
            vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
            vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
            vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
            vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
            vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
            vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
        end)

        local rainbow_delimiters = require "rainbow-delimiters"
        vim.g.rainbow_delimiters = {
            strategy = {
                [""] = rainbow_delimiters.strategy["local"],
            },
            highlight = highlight,
        }

        require('ibl').setup({
            indent = {
                char = " ",
            },
            scope = {
                highlight = highlight,
                char = "▏",
            },
        })

        hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
    end,

}
