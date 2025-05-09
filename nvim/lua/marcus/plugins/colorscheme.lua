return {
    { "folke/tokyonight.nvim" },
    { "Mofiqul/vscode.nvim" },
    { "marko-cerovac/material.nvim" },
    { "catppuccin/nvim", name = "catppuccin" },
    { "EdenEast/nightfox.nvim" },
    { "rose-pine/neovim", name = "rose-pine" },
    { "Shatur/neovim-ayu" },
    { "projekt0n/github-nvim-theme" },
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

            load_colorscheme(unpack(colorschemes.catppuccin))
        end,
    },
}
