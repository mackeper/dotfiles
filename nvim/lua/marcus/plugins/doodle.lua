return {
    enabled = false,
    "apdot/doodle", --  Your second brain, inside Neovim.
    -- dir = "/home/marcus/git/doodle",
    dependencies = {
        "kkharji/sqlite.lua",
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
    },
    config = function()
        require("doodle").setup({
            settings = {
                git_repo = "/home/marcus/git/doodle_db",
                sync = true,
                auto_save = true,
            }
        })
    end,
    keys = {
        {
            "<space>df",
            function() require("doodle"):toggle_finder() end,
            desc = "Doodle Finder"
        },
        {
            "<space>ds",
            function() require("doodle"):sync() end,
            desc = "Doodle Sync"
        },
        {
            "<space>dl",
            function() require("doodle"):toggle_links() end,
            desc = "Doodle Links"
        },
    },
}
