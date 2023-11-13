return {
    "numToStr/Comment.nvim",
    enabled = false,
    lazy = false,
    opts = {
        mappings = {
            basic = false,
            extra = false,
        },
    },
    config = function()
        local comment = require("Comment")
        local api = require("Comment.api")
        comment.setup()

        -- <C-_> is really <C-/>
        -- vim.keymap.set("n", "<C-_>", api.call("toggle.linewise", "g@"), { expr = true, desc = "Toggle comment", })
        vim.keymap.set('n', '<C-_>',
            function()
                if vim.v.count > 0 then
                    api.toggle.linewise.count_repeat()
                else
                    api.toggle.linewise.current()
                end
            end,
            { desc = 'Comment toggle linewise' })
        vim.keymap.set("x", "<C-_>",
            function()
                -- vim.api.nvim_feedkeys("<ESC>", "nx", false)
                api.toggle.linewise(vim.fn.visualmode())
            end, { desc = "Toggle comment", })
    end
}
