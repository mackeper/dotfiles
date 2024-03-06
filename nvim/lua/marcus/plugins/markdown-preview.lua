return {
    "iamcco/markdown-preview.nvim",
    lazy = true,
    ft = { "markdown" },
    cmd = {
        "MarkdownPreviewToggle",
        "MarkdownPreview",
        "MarkdownPreviewStop",
    },
    build = function()
        vim.fn["mkdp#util#install"]()
        -- cd $env:localappdata\nvim-data\lazy\markdown-preview.nvim && npm install tslib
    end,
    config = function()
        vim.cmd([[do FileType]])
        vim.keymap.set("n", "<leader>om", function()
            vim.cmd([[MarkdownPreview]])
        end, { noremap = true, silent = true, desc = "Open markdown preview" })
    end,
}
