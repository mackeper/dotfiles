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
            bg = "#202328",
            fg = "#bbc2cf",
            gray = "#373737",
            red = "#D16969",
            blue = "#0a7aca",
            pink = "#DDB6F2",
            black = "#262626",
            white = "#ffffff",
            green = "#85b670",
            orange = "#FF8800",
            violet = "#a9a1e1",
            magenta = "#c678dd",
            darkblue = "#081633",
            cyan = "#008080",
            yellow = "#ECBE7B",
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
                a = { fg = colors.black, bg = colors.red, gui = "bold" },
                b = { fg = colors.red, bg = colors.black },
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

        local function lsp_name()
            local msg = "No Active Lsp"
            local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
            local clients = vim.lsp.get_active_clients()
            if next(clients) == nil then
                return msg
            end
            for _, client in ipairs(clients) do
                local filetypes = client.config.filetypes
                if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                    return client.name
                end
            end
            return msg
        end

        require("lualine").setup({
            options = {
                icons_enabled = true,
                -- theme = 'codedark',
                theme = cyberdream,
                -- component_separators = { left = '', right = '' },
                -- section_separators = { left = '', right = '' },
                -- component_separators = "|",
                -- section_separators = { left = "", right = "" },
                component_separators = "",
                section_separators = { left = "", right = "" },
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
                lualine_a = {},
                lualine_b = {},
                lualine_c = {
                    {
                        "mode",
                        fmt = string.upper,
                    },
                    {
                        "filename",
                        color = { fg = colors.magenta, gui = "bold" },
                    },
                    {
                        "branch",
                        icon = "",
                        color = { fg = colors.violet, gui = "bold" },
                    },
                    {
                        "diff",
                        symbols = { added = " ", modified = "󰝤 ", removed = " " },
                        diff_color = {
                            added = { fg = colors.green },
                            modified = { fg = colors.orange },
                            removed = { fg = colors.red },
                        },
                    },
                    {
                        "diagnostics",
                        sources = { "nvim_diagnostic" },
                        symbols = { error = " ", warn = " ", info = " " },
                        diagnostics_color = {
                            color_error = { fg = colors.red },
                            color_warn = { fg = colors.yellow },
                            color_info = { fg = colors.cyan },
                        },
                    },
                    {
                        lsp_name,
                        icon = " ",
                        color = { fg = colors.cyan, gui = "bold" },
                    },
                },
                lualine_x = {
                    {
                        copilot_indicator,
                        color = { fg = colors.blue, gui = "bold" },
                    },
                    {
                        "encoding",
                        fmt = string.upper,
                        color = { fg = colors.green, gui = "bold" },
                        icons_enabled = true,
                        icon = "󰉢",
                    },
                    {
                        "fileformat",
                        fmt = string.upper,
                        symbols = {
                            unix = "",
                            dos = "",
                            mac = "",
                        },
                        icons_enabled = true,
                        color = { fg = colors.blue, gui = "bold" },
                    },
                    "filetype",
                    {
                        "filesize",
                        icons_enabled = true,
                        icon = "󰉉",
                        color = { fg = colors.orange, gui = "bold" },
                    },
                    {
                        "progress",
                        color = { fg = colors.fg, gui = "bold" },
                    },
                    {
                        "location",
                        icons_enabled = true,
                        icon = "",
                        color = { fg = colors.red, gui = "bold" },
                    },
                },
                lualine_y = {},
                lualine_z = {},
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
