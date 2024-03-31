return {
    "ahmedkhalf/project.nvim",
    event = "VeryLazy",
    opts = {
        patterns = {
            ".git",
            "_darcs",
            ".hg",
            ".bzr",
            ".svn",
            "Makefile",
            "package.json",
            "Cargo.toml",
            "Stack.yaml",
            ".cabal",
            "*.sln",
        },
    },
    config = function(_, opts)
        require("project_nvim").setup(opts)
    end,
}
