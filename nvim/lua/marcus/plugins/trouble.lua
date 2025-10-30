return {
    "folke/trouble.nvim",
    enabled = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = { use_diagnostic_signs = true },
    keys = {
        {
            "<leader>xx",
            "<cmd>Trouble diagnostics open focus=true<cr>",
            desc = "Diagnostics (Trouble)",
        },
        {
            "<leader>xX",
            "<cmd>Trouble diagnostics open focus=true filter.buf=0<cr>",
            desc = "Buffer Diagnostics (Trouble)",
        },
        {
            "<leader>xs",
            "<cmd>Trouble symbols open focus=true<cr>",
            desc = "Symbols (Trouble)",
        },
        {
            "<leader>xr",
            "<cmd>Trouble lsp open focus=true<cr>",
            desc = "LSP Definitions / references / ... (Trouble)",
        },
        {
            "<leader>xl",
            "<cmd>Trouble loclist open focus=true<cr>",
            desc = "Location List (Trouble)",
        },
        {
            "<leader>xq",
            "<cmd>Trouble qflist open focus=true<cr>",
            desc = "Quickfix List (Trouble)",
        },
        {
            "[q",
            function()
                require("trouble").previous({ skip_groups = true, jump = true })
            end,
            desc = "Trouble: Previous",
        },
        {
            "]q",
            function()
                require("trouble").next({ skip_groups = true, jump = true })
            end,
            desc = "Trouble: Next",
        },
    },
}
