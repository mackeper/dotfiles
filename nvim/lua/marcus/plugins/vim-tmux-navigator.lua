return {
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
        { "<C-LEFT>", "<CMD>TmuxNavigateLeft<cr>" },
        { "<C-DOWN>", "<CMD>TmuxNavigateDown<cr>" },
        { "<C-UP>", "<CMD>TmuxNavigateUp<cr>" },
        { "<C-RIGHT>", "<CMD>TmuxNavigateRight<cr>" },
        { "<M-\\>", "<CMD>TmuxNavigatePrevious<cr>" },
    },
    config = function()
        vim.g.tmux_navigator_no_mappings = 1
    end,
}
