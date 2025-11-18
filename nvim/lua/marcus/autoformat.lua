local M = {}

M.config = {
    filetypes = {
        ["lua"] = {
            formatter = "stylua",
            args = "",
            file = "%",
        },
    },
}

M.setup = function(opts)
    opts = vim.tbl_deep_extend("force", {}, M.config, opts)
    for ft, formatter_opts in pairs(M.config.filetypes) do
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = group,
            pattern = "*." .. ft,
            callback = function()
                vim.fn.system({ formatter_opts.formatter, vim.fn.expand("%") })
                vim.cmd("edit")
            end,
        })
    end
end

M.setup({})
return M
