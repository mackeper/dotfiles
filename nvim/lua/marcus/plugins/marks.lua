return {
	"chentoast/marks.nvim",
	lazy = true,
	event = "BufRead",
	config = function()
		require("marks").setup()
	end,
}
