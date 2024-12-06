return {
    enabled = false,
    "Zeioth/compiler.nvim",
    cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
    dependencies = {
        { "nvim-telescope/telescope.nvim" },
        {
            "stevearc/overseer.nvim",
            commit = "6271cab7ccc4ca840faa93f54440ffae3a3918bd",
            cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
            opts = {
                task_list = {
                    direction = "bottom",
                    min_height = 25,
                    max_height = 25,
                    default_detail = 1,
                },
            },
        },
    },
    opts = {},
    keys = {
        { "<leader>ico", "<cmd>CompilerOpen<cr>", desc = "Open compiler" },
        { "<leader>icr", "<cmd>CompilerRedo<cr>", desc = "Redo last compiler command" },
        { "<leader>ict", "<cmd>CompilerToggleResults<cr>", desc = "Toggle compiler results" },
    },
}
