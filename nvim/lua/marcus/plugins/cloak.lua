return {
    "laytan/cloak.nvim",
    enabled = false,
    config = function()
        require("cloak").setup({
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        })
    end,
}
