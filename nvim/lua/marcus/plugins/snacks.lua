return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        bigfile = { enabled = true },
        quickfile = { enabled = true },
        dashboard = { enabled = true },
        profiler = { enabled = true },
        gitbrowse = {
            enabled = true,
            -- Cannot get this to work on Windows
            open = function(url)
                vim.cmd("!explorer.exe '" .. url .. "'")
            end,
        },
        lazygit = { enabled = true },
        notifier = { enabled = true },
        -- statuscolumn = {
        --     enabled = true,
        --     left = { "mark", "sign" },
        --     right = { "fold", "git" },
        -- },
        terminal = { enabled = false },
        toggle = { enabled = false },
        words = { enabled = true },
    },
    -- stylua: ignore
    keys = {
        -- Profiler
        { "<leader>?", function() Snacks.toggle() end, desc = "Snacks profiler",},
        -- Gitbrowse
        { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Gitbrowse", },
        -- Lazygit
        { "<C-g>", function() Snacks.lazygit.open() end, desc = "Lazygit", },

        -- { "]]",         function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
        -- { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
    },
    config = function(_, opts)
        require("snacks").setup(opts)
    end,
}
