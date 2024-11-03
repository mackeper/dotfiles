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
            lua = { "stylua" },
            csharp = { "csharpier" },
            -- elm = { "elm-format" }, -- Just rely on elm-language-server for now
            haskell = { "fourmolu" },
            python = { "isort", "black" },
            javascript = { { "prettierd", "prettier" } },
            rust = { "rustfmt" },
            sh = { "shfmt" },
            markdown = { "markdownlint", "markdownlint-cli2" },
            ocaml = { "ocamlformat" },

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
