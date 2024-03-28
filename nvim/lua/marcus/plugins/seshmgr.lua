return {
    -- dir = "~/git/SeshMgr.nvim",
    "mackeper/SeshMgr.nvim",
    event = "VeryLazy",
    opts = {
        telescope = {
            enabled = true,
        },
    },
    keys = {
        { "<leader>sl", "<CMD>SessionLoadLast<CR>", desc = "Load last session" },
        { "<leader>sc", "<CMD>SessionLoadCurrent<CR>", desc = "Load current session" },
        { "<leader>sL", "<CMD>SessionList<CR>", desc = "List sessions" },
        { "<leader>ss", "<CMD>SessionSave<CR>", desc = "Save session" },
    },
}
