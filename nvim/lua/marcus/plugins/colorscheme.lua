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
            }

            load_colorscheme(unpack(colorschemes.catppuccin))
        end,
    },
}

-- Some old highlights
-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
-- vim.api.nvim_set_hl(0, "LineNr", { bg = "none", fg = "#1f1f1f" })
-- vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
-- vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#9cacff" })
