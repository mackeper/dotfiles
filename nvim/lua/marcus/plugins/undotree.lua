return {
	"mbbill/undotree",
	lazy = true,
	event = "VeryLazy",
	config = function()
		vim.keymap.set("n", "<leader>eu", vim.cmd.UndotreeToggle, { desc = "Toggle undotree" })
	end,
}
