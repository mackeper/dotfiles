return {
	'mbbill/undotree',
    lazy = true,
    event = "VeryLazy",
	config = function()
		vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
	end
}
