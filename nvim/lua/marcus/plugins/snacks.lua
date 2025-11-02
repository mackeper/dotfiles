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
        notifier = { enabled = true, timeout = 10000 },
        -- statuscolumn = {
        --     enabled = true,
        --     left = { "mark", "sign" },
        --     right = { "fold", "git" },
        -- },
        terminal = { enabled = true },
        toggle = { enabled = true },
        words = { enabled = true },
        styles = {
            notification = {
                wo = {
                    wrap = true,
                },
            },
        },
        zen = {},
    },
    -- stylua: ignore start
    keys = {
        { "<leader>gB", function() Snacks.gitbrowse() end,    desc = "Gitbrowse", },
        { "<C-g>",      function() Snacks.lazygit.open() end, desc = "Lazygit", },
        -- { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
        -- { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
        { "<leader>tt", function() Snacks.terminal() end,     desc = "Toggle Terminal" },
        { "<leader>zm", function() Snacks.zen() end,          desc = "Toggle Zen Mode" },
    },
    -- stylua: ignore end
    config = function(_, opts)
        require("snacks").setup(opts)
    end,
}
