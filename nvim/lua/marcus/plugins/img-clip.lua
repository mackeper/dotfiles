return {
    "HakonHarnes/img-clip.nvim",
    event = { "BufReadPost", "BufNewFile" },
    ft = { "markdown" },
    keys = {
        { "<leader>mpi", "<cmd>PasteImage<cr>", desc = "Paste clipboard image" },
    },
    opts = {
        default = {
            dir_path = "./assets",
            relative_to_current_file = true,
            prompt_for_file_name = true,
        },
    },
}
