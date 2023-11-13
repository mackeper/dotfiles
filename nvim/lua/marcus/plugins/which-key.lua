-- Show keybindings when typing commands
return {
    "folke/which-key.nvim",
    enabled = true,
    lazy = true,
    event = "VeryLazy",
    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
    end,
    opts = {
        window = {
            border = "single",
        },
    },
    config = function(_, opts)
        local wk = require("which-key")
        wk.setup(opts)

        wk.register({
            ["<leader>g"] = { name = "+goto / git", },
            ["<leader>j"] = { name = "+telescope", },
            ["<leader>w"] = { name = "+window", },
            ["<leader>o"] = { name = "+open", },
        })
    end,
}
