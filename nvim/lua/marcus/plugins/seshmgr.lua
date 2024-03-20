return {
    -- dir = "~/git/seshmgr.nvim",
    "mackeper/seshmgr.nvim",
    event = "VeryLazy",
    opts = {
        telescope = {
            enabled = true,
        },
    },
    keys = {
        { "<leader>sl", "<CMD>SessionLoadLast<CR>", desc = "Load last session" },
        { "<leader>sL", "<CMD>SessionList<CR>", desc = "List sessions" },
        { "<leader>ss", "<CMD>SessionSave<CR>", desc = "Save session" },
    },
}
