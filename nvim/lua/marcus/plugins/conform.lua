return {
    -- Formatting
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
            csharp = { "csharpier" },
            -- elm = { "elm-format" }, -- Just rely on elm-language-server for now
            haskell = { "fourmolu" },
            javascript = { { "prettierd", "prettier" } },
            lua = { "stylua" },
            markdown = { "markdownlint", "markdownlint-cli2" },
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
            shfmt = {
                prepend_args = { "-i", "4" },
            },
        },
    },
    init = function()
        -- If you want the formatexpr, here is the place to set it
        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
}
