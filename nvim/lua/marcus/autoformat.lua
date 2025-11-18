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
        local function format_func()
            vim.fn.system({ formatter_opts.formatter, vim.fn.expand("%") })
            vim.cmd("edit")
        end

        vim.keymap.set("n", "<leader>rf" .. ft:sub(1, 1), format_func, {
            desc = "Format current " .. ft .. " file",
            noremap = true,
            silent = true,
        })

        -- local group = vim.api.nvim_create_augroup("AutoFormat_" .. ft, { clear = true })
        -- vim.api.nvim_create_autocmd("BufWritePre", {
        --     group = group,
        --     pattern = "*." .. ft,
        --     callback = format_func,
        -- })
    end
end

M.setup({})
return M
