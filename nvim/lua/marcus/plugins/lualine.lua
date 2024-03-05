return {
	"nvim-lualine/lualine.nvim",
	lazy = true,
	event = { "BufReadPost", "BufNewFile" },
	requires = {
		"nvim-tree/nvim-web-devicons",
		opt = true,
	},
	config = function()
		local colors = {
			gray = "#373737",
			lightred = "#D16969",
			blue = "#0a7aca",
			pink = "#DDB6F2",
			black = "#262626",
			white = "#ffffff",
			green = "#85b670",
		}

		local vscode_theme = {
			normal = {
				a = { fg = colors.black, bg = colors.green, gui = "bold" },
				b = { fg = colors.green, bg = colors.black },
				c = { fg = colors.white, bg = colors.black },
			},
			visual = {
				a = { fg = colors.black, bg = colors.pink, gui = "bold" },
				b = { fg = colors.pink, bg = colors.black },
			},
			inactive = {
				a = { fg = colors.white, bg = colors.gray, gui = "bold" },
				b = { fg = colors.black, bg = colors.blue },
			},
			replace = {
				a = { fg = colors.black, bg = colors.lightred, gui = "bold" },
				b = { fg = colors.lightred, bg = colors.black },
				c = { fg = colors.white, bg = colors.black },
			},
			insert = {
				a = { fg = colors.black, bg = colors.blue, gui = "bold" },
				b = { fg = colors.blue, bg = colors.black },
				c = { fg = colors.white, bg = colors.black },
			},
		}

		local cyberdream = require("lualine.themes.cyberdream")

		local function copilot_indicator()
			local client = vim.lsp.get_active_clients({ name = "copilot" })[1]
			if client == nil then
				return ""
			end

			if vim.tbl_isempty(client.requests) then
				return ""
			end

			local spinners = {
				"◜",
				"◠",
				"◝",
				"◞",
				"◡",
				"◟",
			}
			local ms = vim.loop.hrtime() / 1000000
			local frame = math.floor(ms / 120) % #spinners

			return spinners[frame + 1]
		end

		require("lualine").setup({
			options = {
				icons_enabled = true,
				-- theme = 'codedark',
				theme = cyberdream,
				-- component_separators = { left = '', right = '' },
				-- section_separators = { left = '', right = '' },
				component_separators = "|",
				section_separators = { left = "", right = "" },
				disabled_filetypes = {
					statusline = {},
					winbar = {},
				},
				ignore_focus = {},
				always_divide_middle = true,
				globalstatus = true,
				refresh = {
					statusline = 1000,
					tabline = 1000,
					winbar = 1000,
				},
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = {
                    { 'branch', icon = '', color = { fg = colors.violet, gui = 'bold' },},
                    {
                        'diff',
                        symbols = { added = ' ', modified = '󰝤 ', removed = ' ' },
                        diff_color = {
                            added = { fg = colors.green },
                            modified = { fg = colors.orange },
                            removed = { fg = colors.red },
                        },
                    },
                    "diagnostics"
                },
				lualine_c = { "filename" },
				lualine_x = {
                    {
                        copilot_indicator,
                        color = { fg = colors.blue, gui = 'bold' },
                    },
                    {
                        'encoding',
                        fmt = string.upper,
                        color = { fg = colors.green, gui = 'bold' },
                        icons_enabled = true,
                        icon = '󰉢',
                    },
                    "fileformat",
                    "filetype"
                },
				lualine_y = { "progress" },
				lualine_z = { "location" },
            },
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			winbar = {},
			inactive_winbar = {},
			extensions = {
				"nvim-tree",
			},
		})
	end,
}
