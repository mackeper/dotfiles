return {
	"HakonHarnes/img-clip.nvim",
	event = "BufEnter",
	lazy = true,
	keys = {
		{ "<leader>ci", "<cmd>PasteImage<cr>", desc = "Paste clipboard image" },
	},
	config = function()
		require("img-clip").setup({
			default = {
				dir_path = "./images",
				relative_to_current_file = true,
				prompt_for_file_name = false,
			},
		})
	end,
}
