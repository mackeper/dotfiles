return {
    "iabdelkareem/csharp.nvim",
    dependencies = {
        "williamboman/mason.nvim", -- Required, automatically installs omnisharp
        "mfussenegger/nvim-dap",
        "Tastyep/structlog.nvim", -- Optional, but highly recommended for debugging
    },
    ft = "cs",
    config = function()
        local exe =
            vim.fs.joinpath(vim.fn.stdpath("data"), "csharp", "roslyn-lsp", "Microsoft.CodeAnalysis.LanguageServer.dll")

        require("mason").setup() -- Mason setup must run before csharp, only if you want to use omnisharp
        local csharp = require("csharp")
        csharp.setup({
            lsp = {
                omnisharp = {
                    enable = true,
                },

                roslyn = {
                    enable = false,
                    cmd_path = exe,
                },
            },
        })

        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "cs" },
            callback = function(args)
                local bufnr = args.buf

                local get_keymap_options = function(buffer, desc)
                    return { buffer = buffer, silent = true, nowait = true, desc = desc }
                end

                -- Also added in lsp.lua
                vim.keymap.set("n", "gd", csharp.go_to_definition, get_keymap_options(bufnr, "Go to Definition"))
                vim.keymap.set("n", "<leader>cF", csharp.fix_all, get_keymap_options(bufnr, "Fix All"))
                vim.keymap.set("n", "<F5>", csharp.debug_project, get_keymap_options(bufnr, "Debug Project"))
                vim.keymap.set("n", "<c-f5>", csharp.run_project, get_keymap_options(bufnr, "Run Project"))
            end,
        })
    end,
}
