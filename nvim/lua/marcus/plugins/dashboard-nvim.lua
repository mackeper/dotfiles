return {
    enabled = false,
    "nvimdev/dashboard-nvim",
    lazy = true,
    event = "VimEnter",
    dependencies = {
        { "nvim-tree/nvim-web-devicons" },
    },
    config = function()
        local version = vim.version()
        local nvim_version = "v" .. version.major .. "." .. version.minor .. "." .. version.patch

        require("dashboard").setup({
            theme = "hyper",
            disable_move = false,
            config = {
                week_header = {
                    enable = true,
                },
                shortcut = {
                    {
                        desc = "Lazy",
                        group = "@property",
                        action = "Lazy",
                        key = "l",
                        icon = "󰒲 ",
                    },
                    {
                        icon_hl = "@variable",
                        desc = "Files",
                        group = "Label",
                        action = "Telescope find_files",
                        key = "f",
                        icon = " ",
                    },
                    {
                        desc = "Last session",
                        group = "Label",
                        action = "SessionLoadLast",
                        key = "s",
                        icon = "♻️ ",
                    },
                    {
                        desc = "Projects",
                        group = "Label",
                        action = "Telescope projects",
                        key = "p",
                        icon = " ",
                    },
                    {
                        desc = "dotfiles",
                        group = "Number",
                        action = function()
                            vim.cmd("cd " .. vim.fn.expand("~"))
                            require("telescope.builtin").find_files({
                                cwd = vim.fn.expand("~"),
                                hidden = true,
                                no_ignore = true,
                                search_dirs = { ".ssh", ".local", ".cache", "." },
                            })
                        end,
                        key = "d",
                        icon = " ",
                    },
                    {
                        desc = "Config",
                        group = "Number",
                        action = function()
                            vim.cmd("cd " .. vim.fn.stdpath("config"))
                            require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
                        end,
                        key = "c",
                        icon = " ",
                    },
                },
                footer = {
                    "❤   " .. nvim_version .. " ❤",
                },
            },
        })
    end,
}
