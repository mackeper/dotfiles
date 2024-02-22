return {
	"nvim-tree/nvim-tree.lua",
	lazy = true,
	event = "BufRead",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		local function my_on_attach(bufnr)
			local api = require("nvim-tree.api")

			local function opts(desc)
				return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
			end

			-- default mappings
			api.config.mappings.default_on_attach(bufnr)

			-- custom mappings
			vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
		end

		require("nvim-tree").setup({
			open_on_tab = false,
			sync_root_with_cwd = true,
			on_attach = my_on_attach,
			view = {
				width = {
					min = 30,
					max = -1, -- dynamic width
				},
				side = "left",
			},
			update_focused_file = {
				enable = true,
				update_root = false,
			},
			diagnostics = {
				enable = true,
			},
			filters = {
				custom = {
					"^.git$",
				},
				git_ignored = false,
			},
		})

		local api = require("nvim-tree.api")
		vim.keymap.set("n", "<leader>es", function()
			api.tree.open({ find_file = true, focus = true })
		end, { desc = "Open nvim tree" })

		-- auto open
		-- vim.api.nvim_create_autocmd("VimEnter", {
		-- 	callback = function()
		-- 		api.tree.toggle({ find_file = true, focus = false })
		-- 	end,
		-- })

		-- auto close
		vim.api.nvim_create_autocmd("BufEnter", {
			nested = true,
			callback = function()
				if #vim.api.nvim_list_wins() == 1 and require("nvim-tree.utils").is_nvim_tree_buf() then
					vim.cmd("quit")
				end
			end,
		})
	end,
}
