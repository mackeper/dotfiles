return {
	"dstein64/nvim-scrollview",
	lazy = true,
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		excluded_filetypes = { "nerdtree" },
		scrollview_base = "right",
		current_only = true,
		signs_on_startup = { "all" },
		-- diagnostics_severities = { vim.diagnostic.severity.ERROR },
	},
}
