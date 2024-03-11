return {
    "dstein64/nvim-scrollview",
    lazy = true,
    event = { "BufReadPost", "BufNewFile" },
    opts = {
        excluded_filetypes = { "nerdtree", "NvimTree" },
        scrollview_always_show = true,
        scrollview_base = "right",
        current_only = true,
        signs_on_startup = { "all" },
        -- diagnostics_severities = { vim.diagnostic.severity.ERROR },
    },
    config = function(_, opts)
        require("scrollview").setup(opts)
        require("scrollview.contrib.gitsigns").setup({})
    end,
}
