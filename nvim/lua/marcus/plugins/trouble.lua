return {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = { use_diagnostic_signs = true },
    keys = {
        {
            "<leader>xx",
            function()
                require("trouble").open()
            end,
            desc = "Trouble: open",
        },
        {
            "<leader>xw",
            function()
                require("trouble").open("workspace_diagnostics")
            end,
            desc = "Trouble: Workspace diagnostics",
        },
        {
            "<leader>xd",
            function()
                require("trouble").open("document_diagnostics")
            end,
            desc = "Trouble: Document diagnostics",
        },
        {
            "<leader>xq",
            function()
                require("trouble").open("quickfix")
            end,
            desc = "Trouble: Quickfix",
        },
        {
            "<leader>xl",
            function()
                require("trouble").open("loclist")
            end,
            desc = "Trouble: Location list",
        },
        {
            "gR",
            function()
                require("trouble").open("lsp_references")
            end,
            desc = "Trouble: LSP references",
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
