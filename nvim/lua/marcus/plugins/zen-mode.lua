return {
    "folke/zen-mode.nvim",
    keys = {
        { "<leader>zm", "<CMD>ZenMode<CR>", desc = "Toggle Zen Mode" },
    },
    opts = {
        window = {
            backdrop = 1.0, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
            width = 120, -- width of the Zen window
            height = 0.8, -- height of the Zen window
            options = {
                signcolumn = "no", -- disable signcolumn
                number = false, -- disable number column
                relativenumber = false, -- disable relative numbers
                -- cursorline = false,     -- disable cursorline
                cursorcolumn = false, -- disable cursor column
                foldcolumn = "0", -- disable fold column
                list = false, -- disable whitespace characters
            },
        },
        plugins = {
            options = {
                enabled = true,
                ruler = false,
                showcmd = false,
                laststatus = 0,
            },
        },
    },
}
