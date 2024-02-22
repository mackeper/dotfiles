return {
	"phaazon/hop.nvim",
	branch = "v2", -- optional but strongly recommended
	lazy = true,
	event = "BufRead",
	config = function()
		local hop = require("hop")
		hop.setup({
			keys = "qwertasdfgzxcvbyuiophjklmn",
			case_insensitive = true,
			uppercase_labels = true,
			multi_windows = true,
		})

		vim.keymap.set("n", "s", hop.hint_char1, {})

		local color = "#ffff00"
		vim.api.nvim_set_hl(0, "HopNextKey", { fg = color })
		vim.api.nvim_set_hl(0, "HopNextKey1", { fg = color })
		vim.api.nvim_set_hl(0, "HopNextKey2", { fg = color })
	end,
}
