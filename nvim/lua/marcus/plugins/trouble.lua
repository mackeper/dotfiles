return {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = { use_diagnostic_signs = true },
    keys = {
        {
            "<leader>xx",
            function()
                require("trouble").toggle()
            end,
            desc = "Trouble: Toggle",
        },
        {
            "<leader>xw",
            function()
                require("trouble").toggle("workspace_diagnostics")
            end,
            desc = "Trouble: Workspace diagnostics",
        },
        {
            "<leader>xd",
            function()
                require("trouble").toggle("document_diagnostics")
            end,
            desc = "Trouble: Document diagnostics",
        },
        {
            "<leader>xq",
            function()
                require("trouble").toggle("quickfix")
            end,
            desc = "Trouble: Quickfix",
        },
        {
            "<leader>xl",
            function()
                require("trouble").toggle("loclist")
            end,
            desc = "Trouble: Location list",
        },
        {
            "gR",
            function()
                require("trouble").toggle("lsp_references")
            end,
            desc = "Trouble: LSP references",
        },
    },
}
