return {
	"stevearc/dressing.nvim",
	lazy = true,
	event = "VeryLazy",
	enabled = true,
	config = function()
		require("dressing").setup({})
	end,
}
