return {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    -- event = { "BufReadPost", "BufNewFile" },
    config = function()
        local configs = require("nvim-treesitter.configs")

        ---@diagnostic disable-next-line: missing-fields
        configs.setup({
            -- https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
            ensure_installed = {
                "bash",
                "c",
                "c_sharp",
                "css",
                "cpp",
                "dockerfile",
                "elm",
                "gitignore",
                "go",
                "haskell",
                "html",
                "javascript",
                "json",
                "ledger",
                "lua",
                "markdown",
                "markdown_inline",
                "ocaml",
                "python",
                "query",
                "regex",
                "rust",
                "scss",
                "toml",
                "vim",
                "vimdoc",
                "yaml",
            },
            sync_install = false,
            highlight = { enable = true },
            indent = { enable = true },
            additional_vim_regex_highlightning = false,
            incremental_selection = {
                enable = true,
                keymaps = {
                    node_incremental = "v",
                    node_decremental = "V",
                },
            },
        })
    end,
}
