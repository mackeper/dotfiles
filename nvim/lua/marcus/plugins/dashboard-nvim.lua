return {
	"nvimdev/dashboard-nvim",
	lazy = true,
	event = "VimEnter",
	dependencies = {
		{ "nvim-tree/nvim-web-devicons" },
	},
	config = function()
		require("dashboard").setup({
			theme = "hyper",
			disable_move = false,
			config = {
				week_header = {
					enable = true,
				},
				shortcut = {
					{
						desc = "Lazy",
						group = "@property",
						action = "Lazy",
						key = "l",
						icon = "󰒲 ",
					},
					{
						icon_hl = "@variable",
						desc = "Files",
						group = "Label",
						action = "Telescope find_files",
						key = "f",
						icon = " ",
					},
					{
						desc = "Projects",
						group = "DiagnosticHint",
						action = "Telescope projects",
						key = "p",
						icon = " ",
					},
					{
						desc = "dotfiles",
						group = "Number",
						action = function()
							vim.cmd("cd " .. vim.fn.expand("~"))
							require("telescope.builtin").find_files({
								cwd = vim.fn.expand("~"),
								hidden = true,
								no_ignore = true,
								search_dirs = { ".ssh", ".local", ".cache", "." },
							})
						end,
						key = "d",
						icon = " ",
					},
					{
						desc = "Config",
						group = "Number",
						action = function()
							vim.cmd("cd " .. vim.fn.stdpath("config"))
							require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
						end,
						key = "c",
						icon = " ",
					},
				},
				footer = {
					"❤",
				},
			},
		})
	end,
}
