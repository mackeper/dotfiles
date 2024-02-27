return {
	"chentoast/marks.nvim",
	lazy = true,
	event = { "BufReadPost", "BufNewFile" },
	config = function()
		require("marks").setup()
	end,
}
