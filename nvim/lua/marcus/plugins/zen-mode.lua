return {
    "folke/zen-mode.nvim",
    lazy = true,
    event = "VeryLazy",
    opts = {
        window = {
            backdrop = 1.0,             -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
            width = 120,                -- width of the Zen window
            height = 0.8,               -- height of the Zen window
            options = {
                signcolumn = "no",      -- disable signcolumn
                number = false,         -- disable number column
                relativenumber = false, -- disable relative numbers
                -- cursorline = false,     -- disable cursorline
                cursorcolumn = false,   -- disable cursor column
                foldcolumn = "0",       -- disable fold column
                list = false,           -- disable whitespace characters
            },
        },
    },
    config = function(_, opts)
        vim.keymap.set(
            "n","<leader>zm",
            function() require("zen-mode").toggle(opts) end,
            {
                noremap = true,
                silent = true,
                desc = "Toggle Zen Mode",
            })
    end
}
