return {
    enabled = true,
    "christoomey/vim-tmux-navigator",
    event = "BufReadPre",
    cmd = {
        "TmuxNavigateLeft",
        "TmuxNavigateDown",
        "TmuxNavigateUp",
        "TmuxNavigateRight",
        "TmuxNavigatePrevious",
    },
    keys = {
        -- Normal mode
        { "<C-LEFT>", "<CMD>TmuxNavigateLeft<cr>" },
        { "<C-DOWN>", "<CMD>TmuxNavigateDown<cr>" },
        { "<C-UP>", "<CMD>TmuxNavigateUp<cr>" },
        { "<C-RIGHT>", "<CMD>TmuxNavigateRight<cr>" },
        { "<M-\\>", "<CMD>TmuxNavigatePrevious<cr>" },

        -- Insert mode
        { "<C-LEFT>", "<CMD>TmuxNavigateLeft<cr>", mode = "i" },
        { "<C-DOWN>", "<CMD>TmuxNavigateDown<cr>", mode = "i" },
        { "<C-UP>", "<CMD>TmuxNavigateUp<cr>", mode = "i" },
        { "<C-RIGHT>", "<CMD>TmuxNavigateRight<cr>", mode = "i" },
    },
    config = function()
        vim.g.tmux_navigator_no_mappings = 1
    end,
}
