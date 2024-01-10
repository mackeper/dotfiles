-- Formatting
return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>rf",
			function()
				require("conform").format({
					async = true,
					lsp_fallback = true,
				})
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			csharp = { "csharpier" },
			elm = { "elm-format" },
			haskell = { "fourmolu" },
			python = { "isort" },
			javascript = { { "prettierd", "prettier" } },
			rust = { "rustfmt" },
			sh = { "shfmt" },
			markdown = { "markdownlint", "markdownlint-cli2" },

			["*"] = { "trim_whitespace" },
		},

		format_on_save = {
			timeout_ms = 500,
			lsp_fallback = true,
		},

		formatters = {
			shfmt = {
				prepend_args = { "-i", "2" },
			},
		},
	},
	init = function()
		-- If you want the formatexpr, here is the place to set it
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}
