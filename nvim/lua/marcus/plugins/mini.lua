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

        -- Jump to character
        require("mini.jump2d").setup({
            mappings = {
                start_jumping = "",
            },
        })
        vim.keymap.set({ "n", "v" }, "s", "<CMD>lua MiniJump2d.start(MiniJump2d.builtin_opts.single_character)<CR>", { desc = "Jump to char" })

        -- Show key clues
        local miniclue = require("mini.clue")
        miniclue.setup({
            triggers = {
                { mode = "n", keys = "<Leader>" },
                { mode = "x", keys = "<Leader>" },
                { mode = "n", keys = "g" },
                { mode = "x", keys = "g" },
            },
            clues = {
                { mode = "n", keys = "<Leader>a", desc = "+Autolist" },
                { mode = "n", keys = "<Leader>b", desc = "+Buffers" },
                { mode = "n", keys = "<Leader>c", desc = "+Copy" },
                { mode = "n", keys = "<Leader>d", desc = "+Debug" },
                { mode = "n", keys = "<Leader>e", desc = "+Explorer" },
                { mode = "n", keys = "<Leader>g", desc = "+Git" },
                { mode = "n", keys = "<Leader>gc", desc = "+Git Conflict" },
                { mode = "n", keys = "<Leader>h", desc = "+Harpoon" },
                { mode = "n", keys = "<Leader>i", desc = "+IDE" },
                { mode = "n", keys = "<Leader>ib", desc = "+Build" },
                { mode = "n", keys = "<Leader>ic", desc = "+Compile" },
                { mode = "n", keys = "<Leader>it", desc = "+Test" },
                { mode = "n", keys = "<Leader>j", desc = "+Telescope" },
                { mode = "n", keys = "<Leader>jg", desc = "Git" },
                { mode = "n", keys = "<Leader>l", desc = "+LSP" },
                { mode = "n", keys = "<Leader>lt", desc = "Tools" },
                { mode = "n", keys = "<Leader>o", desc = "+Open" },
                { mode = "n", keys = "<Leader>p", desc = "+Copilot" },
                { mode = "n", keys = "<Leader>r", desc = "+Refactor" },
                { mode = "n", keys = "<Leader>s", desc = "+Surround / Session" },
                { mode = "n", keys = "<Leader>t", desc = "+Tabs" },
                { mode = "n", keys = "<Leader>w", desc = "+Window" },
                { mode = "n", keys = "<Leader>x", desc = "+Quickfix List" },
                { mode = "n", keys = "<Leader>z", desc = "+Mode" },
                { mode = "n", keys = "<Leader>zc", desc = "Cloak" },
                { mode = "n", keys = "gi", desc = "Go to implementation" },
                miniclue.gen_clues.builtin_completion(),
                miniclue.gen_clues.g(),
                miniclue.gen_clues.marks(),
                miniclue.gen_clues.registers(),
                miniclue.gen_clues.windows(),
                miniclue.gen_clues.z(),
            },
            window = {
                delay = 100,
            },
        })
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
