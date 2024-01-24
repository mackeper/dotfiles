return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.4",
	lazy = true,
	event = "VeryLazy",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local builtin = require("telescope.builtin")
		local telescope = require("telescope")
		telescope.load_extension("projects")

		telescope.setup({})

		vim.keymap.set("n", "<leader>jt", builtin.builtin, { desc = "Telescope" })
		vim.keymap.set("n", "<leader>jb", builtin.buffers, { desc = "Buffers" })
		vim.keymap.set("n", "<leader>jf", builtin.find_files, { desc = "Find files" })
		vim.keymap.set("n", "<leader>jd", function()
			builtin.find_files({ hidden = true })
		end, { desc = "Find files (include hidden)" })
		vim.keymap.set("n", "<leader>jgg", builtin.live_grep, { desc = "Live grep" })
		vim.keymap.set("n", "<leader>jgb", builtin.git_branches, { desc = "Git branches" })
		vim.keymap.set("n", "<leader>jgc", builtin.git_commits, { desc = "Git commits" })
		vim.keymap.set("n", "<leader>jgt", builtin.git_stash, { desc = "Git stash" })
		vim.keymap.set("n", "<leader>jgs", builtin.git_status, { desc = "Git status" })
		vim.keymap.set("n", "<leader>jgf", builtin.git_files, { desc = "Git files" })
		vim.keymap.set("n", "<leader>jgo", builtin.git_bcommits, { desc = "Git bcommits" })
		vim.keymap.set("n", "<leader>jh", builtin.help_tags, { desc = "Help" })
		vim.keymap.set("n", "<leader>jm", builtin.oldfiles, { desc = "Recent files" })
		vim.keymap.set("n", "<leader>jr", builtin.git_files, { desc = "Git files" })
		vim.keymap.set("n", "<leader>jp", telescope.extensions.projects.projects, { desc = "Projects" })
	end,
}
