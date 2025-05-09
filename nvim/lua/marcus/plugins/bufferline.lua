return {
    enabled = false,
    -- Like tabs but for buffers
    "akinsho/bufferline.nvim",
    version = "*",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        options = {
            separator_style = "thin",
            always_show_bufferline = true,
            diagnostics = "nvim_lsp",
            numbers = "none",
            show_buffer_close_icons = false,
            show_close_icon = false,
            buffer_close_icon = "󰅖",
            modified_icon = "●",
            close_icon = "",
            left_trunc_marker = "",
            right_trunc_marker = "",
            offsets = {
                {
                    filetype = "NvimTree",
                    text = "File Explorer",
                    highlight = "Directory",
                    text_align = "center",
                },
            },
        },
    },
    config = function(_, opts)
        require("bufferline").setup(opts)

        -- vim.api.nvim_set_hl(0, 'BufferLineSeparator', { fg = '#252526', bg = '#1e1e1e'} )
        -- vim.api.nvim_set_hl(0, 'BufferLineBuffer', { fg = '#bb856e', bg = '#1e1e1e', } )
        -- vim.api.nvim_set_hl(0, 'BufferLineTab', { fg = '#bb856e', bg = '#1e1e1e', } )
        -- vim.api.nvim_set_hl(0, 'BufferLineSeparatorSelected', { fg = '#252526', bg = '#1e1e1e', } )
        -- vim.api.nvim_set_hl(0, 'BufferLineBufferSelected', { fg = '#84b8d3', bg = '#1e1e1e', } )
    end,
}
