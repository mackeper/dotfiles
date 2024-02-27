return {
	"akinsho/toggleterm.nvim",
	enabled = true,
	lazy = true,
	event = { "BufReadPost", "BufNewFile" },
	-- version = "v2.8.*",
	config = function()
		-- Setup shell for windows
		-- vim.opt.shell = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell"
		-- vim.opt.shellcmdflag =
			-- "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
		-- vim.opt.shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait"
		-- vim.opt.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
		-- vim.opt.shellquote = ""
		-- vim.opt.shellxquote = ""

		require("toggleterm").setup({
			direction = "float",
			open_mapping = [[<C-\>]],
			insert_mappings = true,
			terminal_mappings = true,
			hide_numbers = true,
			float_opts = {
				border = "curved",
				winblend = 0,
			},
		})

		-- vim.keymap.set("n", "<C-z>", toggleterm.toggleterm, { noremap = true, silent = true })
		-- vim.keymap.set("i", "<C-z>", toggleterm.toggleterm, { noremap = true, silent = true })
		--
		local Terminal = require("toggleterm.terminal").Terminal
		local lazygit = Terminal:new({
			cmd = "lazygit",
			hidden = true,
			count = 2,
		})

		vim.keymap.set("n", "<C-g>", function()
			lazygit:toggle()
		end, { noremap = true, silent = true })

		vim.keymap.set("t", "<C-g>", function()
			lazygit:toggle()
		end, { noremap = true, silent = true })

        local python = Terminal:new({
            hidden = true,
            dir = "%:p:h",
            count = 3,
        })

        vim.keymap.set("n", "<leader>ep", function()
            require("toggleterm").exec_command(
                "cmd='python3 " .. vim.fn.expand("%") .. "'", python.count)
        end, { noremap = true, silent = true })

        vim.keymap.set("t", "<leader>ep", function()
            python:close()
        end, { noremap = true, silent = true })
	end,
}
