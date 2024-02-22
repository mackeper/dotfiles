return {
	"m4xshen/hardtime.nvim",
	dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
	lazy = true,
	event = "BufRead",
	opts = {},
	config = function()
		require("hardtime").setup({
			disabled_filetypes = { "qf", "netrw", "NvimTree", "lazy", "mason", "oil" },
			disabled_keys = {
				["<Up>"] = {},
				["<Down>"] = {},
				["<Left>"] = {},
				["<Right>"] = {},
			},
		})
	end,
}
