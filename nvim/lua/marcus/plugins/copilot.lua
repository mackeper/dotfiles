-- return {
--     -- :Copilot setup
--     "github/copilot.vim",
--     lazy = true,
--     event = "VeryLazy",
-- }

return {
	"zbirenbaum/copilot.lua",
	lazy = true,
	event = "InsertEnter",
	cmd = "Copilot",
	build = ":Copilot auth",
	opts = {
		enabled = true,
		auto_refresh = true,
		suggestion = {
			enabled = true,
			auto_trigger = true,
		},
		panel = {
			enabled = false,
		},
		filetypes = {
			markdown = true,
			help = true,
			yaml = true,
		},
	},
	config = function(_, opts)
		require("copilot").setup(opts)
	end,
}
