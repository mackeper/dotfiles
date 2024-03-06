return {
    --"folke/tokyonight.nvim",
    -- "Mofiqul/vscode.nvim",
    -- "marko-cerovac/material.nvim",
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
        -- vim.cmd([[colorscheme tokyonight]])
        -- vim.cmd([[colorscheme vscode]])
        -- vim.cmd.colorscheme("vscode")

        -- vim.g.material_style = "darker"
        -- vim.cmd.colorscheme("material")

        require("cyberdream").setup({
            -- Recommended - see "Configuring" below for more config options
            transparent = true,
            italic_comments = true,
            hide_fillchars = false,
            borderless_telescope = false,
        })
        vim.cmd("colorscheme cyberdream")

        -- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
        -- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
        -- vim.api.nvim_set_hl(0, "LineNr", { bg = "none", fg = "#1f1f1f" })
        -- vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
        -- vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#9cacff" })
    end,
}
