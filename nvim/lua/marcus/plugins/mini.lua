return {
    "echasnovski/mini.nvim",
    version = "*",
    lazy = true,
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

        require("mini.cursorword").setup()

        require("mini.surround").setup({
            mappings = {
                add = "<leader>sa", -- Add surrounding in Normal and Visual modes
                delete = "<leader>sd", -- Delete surrounding
                find = "<leader>sf", -- Find surrounding (to the right)
                find_left = "<leader>sF", -- Find surrounding (to the left)
                highlight = "<leader>sh", -- Highlight surrounding
                replace = "<leader>sr", -- Replace surrounding
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

        require("mini.ai").setup()
    end,
    init = function()
        vim.api.nvim_create_autocmd("FileType", {
            pattern = {
                "help",
                "alpha",
                "dashboard",
                "neo-tree",
                "NvimTree",
                "Trouble",
                "trouble",
                "lazy",
                "mason",
                "notify",
                "toggleterm",
                "lazyterm",
            },
            callback = function()
                vim.b.miniindentscope_disable = true
            end,
        })
    end,
}
