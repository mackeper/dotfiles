return {
    "echasnovski/mini.nvim",
    version = "*",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        require("mini.comment").setup({
            mappings = {
                comment = "<C-_>",
                comment_line = "<C-_>",
                comment_visual = "<C-_>",
                textobject = "",
            },
        })

        -- Show buffers as tabs, bufferline looks better
        -- require("mini.tabline").setup()

        -- Auto highlight text under cursor
        require("mini.cursorword").setup({})

        -- Generate help files from Lua docstrings
        -- :lua MiniDoc.generate()
        require("mini.doc").setup({})

        require("mini.surround").setup({
            mappings = {
                add = "<leader>sa",            -- Add surrounding in Normal and Visual modes
                delete = "<leader>sd",         -- Delete surrounding
                replace = "<leader>sr",        -- Replace surrounding
                update_n_lines = "<leader>sn", -- Update `n_lines`
            },
        })

        require("mini.indentscope").setup({
            symbol = "▏",
            options = { try_as_border = true },
        })

        local hipatterns = require("mini.hipatterns")
        hipatterns.setup({
            highlighters = {
                fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
                bug = { pattern = "%f[%w]()BUG()%f[%W]", group = "MiniHipatternsFixme" },
                hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
                todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
                note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

                hex_color = hipatterns.gen_highlighter.hex_color(),
            },
        })

        require("mini.align").setup({
            mappings = {
                start = "<leader>ra",
                start_with_preview = "<leader>rA",
            },
        })

        require("mini.pick").setup({})
        vim.keymap.set("n", "<leader>f", ":Pick files<CR>", { noremap = true, silent = true })

        -- Extend a/i text objects
        require("mini.ai").setup({})
    end,
    init = function()
        vim.api.nvim_create_autocmd("FileType", {
            pattern = {
                "NvimTree",
                "help",
                "lazy",
                "lazyterm",
                "mason",
                "notify",
                "snacks_dashboard",
                "toggleterm",
            },
            callback = function()
                vim.b.miniindentscope_disable = true
            end,
        })
    end,
}
