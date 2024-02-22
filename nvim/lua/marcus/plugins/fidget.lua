return {
	"j-hui/fidget.nvim",
	lazy = true,
	event = "LspAttach",
	opts = {
		notification = {
			window = {
				winblend = 0,
			},
		},
	},
	config = function(_, opts)
		require("fidget").setup(opts)
		vim.api.nvim_set_hl(0, "FidgetTitle", { link = "NormalFloat" })
		vim.api.nvim_set_hl(0, "FidgetTask", { link = "NormalFloat" })
	end,
}
