return {
    -- Formatting
    enabled = false,
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
        {
            "<leader>rf",
            function()
                require("conform").format({
                    async = true,
                    lsp_fallback = true,
                })
            end,
            mode = "",
            desc = "Format buffer",
        },
    },
    opts = {
        formatters_by_ft = {
            asm = { "asmfmt" },
            c = { "clang-format" },
            csharp = { "csharpier" },
            -- elm = { "elm-format" }, -- Just rely on elm-language-server for now
            haskell = { "fourmolu" },
            javascript = { "prettierd", "prettier" },
            lua = { "stylua" },
            markdown = { "markdownlint" },
            ocaml = { "ocamlformat" },
            python = { "isort", "black" },
            rust = { "rustfmt" },
            sh = { "shfmt" },

            ["_"] = { "trim_whitespace" },
        },

        format_on_save = {
            timeout_ms = 500,
            lsp_fallback = true,
        },

        formatters = {
            ["clang-format"] = {
                prepend_args = { "--style", "file", "--fallback-style", "webkit" },
            },
            shfmt = {
                prepend_args = { "-i", "4" },
            },
            ["markdownlint"] = {
                stdin = false,
            },
        },
    },
    init = function()
        -- If you want the formatexpr, here is the place to set it
        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
}
