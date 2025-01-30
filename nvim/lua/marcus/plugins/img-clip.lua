return {
    "HakonHarnes/img-clip.nvim",
    event = { "BufReadPost", "BufNewFile" },
    keys = {
        { "<leader>ci", "<cmd>PasteImage<cr>", desc = "Paste clipboard image" },
    },
    opts = {
        default = {
            dir_path = "./images",
            relative_to_current_file = true,
            prompt_for_file_name = true,
        },
    },
}
