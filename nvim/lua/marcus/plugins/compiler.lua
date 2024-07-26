return {
    "Zeioth/compiler.nvim",
    lazy = true,
    cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
    dependencies = {
        {
            "stevearc/overseer.nvim",
            commit = "68a2d344cea4a2e11acfb5690dc8ecd1a1ec0ce0",
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
        { "<leader>cco", "<cmd>CompilerOpen<cr>", desc = "Open compiler" },
        { "<leader>ccr", "<cmd>CompilerRedo<cr>", desc = "Redo last compiler command" },
        { "<leader>cct", "<cmd>CompilerToggleResults<cr>", desc = "Toggle compiler results" },
    },
}
