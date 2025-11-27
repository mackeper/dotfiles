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
    -- opts = vim.tbl_deep_extend("force", {}, M.config, opts)
    -- -- for ft, formatter_opts in pairs(M.config.filetypes) do
    -- --     local function format_func()
    -- --         -- vim.fn.system({ formatter_opts.formatter, vim.fn.expand("%") })
    -- --         -- vim.cmd("edit")
    -- --         vim.lsp.buf.format()
    -- --     end
    -- --
    -- --     vim.keymap.set("n", "<leader>rf" .. ft:sub(1, 1), format_func, {
    -- --         desc = "Format current " .. ft .. " file",
    -- --         noremap = true,
    -- --         silent = true,
    -- --     })
    -- -- end
    -- local function format_func()
    --     -- vim.fn.system({ formatter_opts.formatter, vim.fn.expand("%") })
    --     -- vim.cmd("edit")
    --     vim.lsp.buf.format()
    -- end
    -- vim.keymap.set("n", "<leader>rf", format_func, {
    --     desc = "Format current file",
    --     noremap = true,
    --     silent = true,
    -- })
    --
    -- vim.api.nvim_create_autocmd("LspAttach", {
    --     callback = function(args)
    --         local client = vim.lsp.get_client_by_id(args.data.client_id)
    --         if not client then
    --             return
    --         end
    --
    --         if client:supports_method("textDocument/formatting") then
    --             vim.api.nvim_create_autocmd("BufWritePre", {
    --                 buffer = args.buf,
    --                 callback = function()
    --                     vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
    --                 end,
    --             })
    --         end
    --     end,
    -- })
end

M.setup({})
return M
