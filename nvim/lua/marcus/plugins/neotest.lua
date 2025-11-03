return {
    enabled = true,
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-neotest/nvim-nio",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter",

        -- Adapter dependencies
        "rouge8/neotest-rust",
        "Issafalcon/neotest-dotnet",
    },
    cmd = { "Neotest" },
    opts = function()
        return {
            adapters = {
                -- require("neotest-rust"),
                require("neotest-dotnet"),
            },
        }
    end,
    config = function(_, opts)
        require("neotest").setup(opts)
    end,
    keys = {
        {
            "<leader>itf",
            function()
                require("neotest").run.run(vim.fn.expand("%"))
            end,
            desc = "Run current test file",
        },
        {
            "<leader>itr",
            function()
                require("neotest").run.run()
            end,
            desc = "Run current test",
        },
        {
            "<leader>ito",
            function()
                require("neotest").output.open({ enter = true, auto_close = true })
            end,
            desc = "Open test output",
        },
        {
            "<leader>its",
            function()
                require("neotest").summary.toggle()
            end,
            desc = "Open test output",
        },
    },
}
