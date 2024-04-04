return {
    "christoomey/vim-tmux-navigator",
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
    },
}
