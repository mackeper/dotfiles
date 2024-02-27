return {
	"nvim-treesitter/nvim-treesitter",
	version = false,
	build = ":TSUpdate",
	lazy = true,
	event = { "BufReadPost", "BufNewFile" },
	config = function()
		local configs = require("nvim-treesitter.configs")

		configs.setup({
			-- https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
			ensure_installed = {
				"bash",
				"c",
				"c_sharp",
				"dockerfile",
				"elm",
				"gitignore",
				"haskell",
				"html",
				"javascript",
				"json",
				"lua",
				"markdown",
				"markdown_inline",
				"python",
				"query",
				"regex",
				"rust",
				"scss",
				"vim",
				"vimdoc",
				"yaml",
			},
			sync_install = false,
			highlight = { enable = true },
			indent = { enable = true },
			additional_vim_regex_highlightning = false,
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-j>",
					node_incremental = "<C-j>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
		})
	end,
}
