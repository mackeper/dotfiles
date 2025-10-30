return {
    { "folke/tokyonight.nvim", enabled = false },
    { "catppuccin/nvim", enabled = false, name = "catppuccin" },
    { "rose-pine/neovim", enabled = false, name = "rose-pine" },
    { "Shatur/neovim-ayu", enabled = false },
    { "projekt0n/github-nvim-theme", enabled = false },
    { "marko-cerovac/material.nvim", enabled = true },
    {
        "scottmckendry/cyberdream.nvim",
        priority = 1000,
        opts = {},
        config = function()
            local function load_colorscheme(name, callback)
                if callback then
                    callback()
                end
                vim.cmd("colorscheme " .. name)
            end

            local colorschemes = {
                cyberdream = {
                    "cyberdream",
                    function()
                        require("cyberdream").setup({
                            transparent = true,
                            italic_comments = true,
                            hide_fillchars = false,
                            borderless_telescope = false,
                        })
                    end,
                },
                catppuccin = { "catppuccin", nil },
                catppuccin_latte = { "catppuccin-latte", nil },
                tokyonight = { "tokyonight", nil },
                material = {
                    "material",
                    function()
                        vim.g.material_style = "darker"
                    end,
                },
                vscode = { "vscode", nil },
                nightfox = { "nightfox", nil },
                rose_pine = { "rose-pine", nil },
                github_dark = { "github_dark", nil },
                github_light = { "github_light_colorblind", nil },
                material_deep_ocean = {
                    "material",
                    function()
                        vim.g.material_style = "deep ocean"
                    end,
                },
            }

            -- local light_mode = 0
            -- light_mode = vim.fn.system(
            --     [[powershell.exe -NoProfile -Command "& { (Get-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name AppsUseLightTheme).AppsUseLightTheme }"]]
            -- )
            --
            -- print("light_mode: " .. light_mode)
            --
            -- if light_mode:match("1") then
            --     load_colorscheme(unpack(colorschemes.github_light))
            -- else
            --     load_colorscheme(unpack(colorschemes.catppuccin))
            -- end

            load_colorscheme(unpack(colorschemes.material_deep_ocean))
        end,
    },
}
