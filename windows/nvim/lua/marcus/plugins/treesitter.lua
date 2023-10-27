return {
    'nvim-treesitter/nvim-treesitter',
    build = ":TSUpdate",
    config = function()
        local configs = require("nvim-treesitter.configs")

        configs.setup({
            -- https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
            ensure_installed = {
                "bash",
                "c",
                "c_sharp",
                "dockerfile",
                "elm",
                "gitignore",
                "haskell",
                "html",
                "javascript",
                "json",
                "lua",
                "python",
                "query",
                "rust",
                "scss",
                "vim",
                "vimdoc",
                "yaml",
            },
            sync_install = false,
            highlight = { enable = true },
            indent = { enable = true },
            additional_vim_regex_highlightning = false,
        })
    end
}

