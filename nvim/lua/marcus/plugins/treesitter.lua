return {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
    },
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
                "diff",
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
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = "@class.inner",
                    },
                },
                move = {
                    enable = true,
                    set_jumps = true,
                    goto_next_start = {
                        ["]]"] = "@function.outer",
                    },
                    goto_previous_start = {
                        ["[["] = "@function.outer",
                    },
                },
            },
        })
    end,
}
