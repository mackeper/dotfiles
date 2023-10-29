return {
	--"folke/tokyonight.nvim",
    "Mofiqul/vscode.nvim",
    lazy = false,
	priority = 1000,
    opts = {},
	config = function()
		-- vim.cmd([[colorscheme tokyonight]])
		vim.cmd([[colorscheme vscode]])
		vim.api.nvim_set_hl(0, "Normal", { bg = "none"})
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none"})
        vim.cmd([[highlight clear LineNr]])
        vim.cmd([[highlight clear SignColumn]])
	end,
}
