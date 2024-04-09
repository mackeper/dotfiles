return {
    "phaazon/hop.nvim",
    branch = "v2", -- optional but strongly recommended
    opts = {
        keys = "qwertasdfgzxcvbyuiophjklmn",
        case_insensitive = true,
        uppercase_labels = true,
        multi_windows = true,
    },
    keys = {
        { "s", "<CMD>lua require('hop').hint_char1()<CR>", desc = "Hop to char" },
        { "s", "<CMD>lua require('hop').hint_char1()<CR>", desc = "Hop to char", mode = "v" },
    },
    config = function(_, opts)
        require("hop").setup(opts)

        local color = "#ffff00"
        vim.api.nvim_set_hl(0, "HopNextKey", { fg = color })
        vim.api.nvim_set_hl(0, "HopNextKey1", { fg = color })
        vim.api.nvim_set_hl(0, "HopNextKey2", { fg = color })
    end,
}
