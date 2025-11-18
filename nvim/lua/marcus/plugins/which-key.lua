return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 100
    end,
    opts = {
        win = {
            border = "single",
        },
        notify = false, -- Show warnings for keymaps
    },
    config = function(_, opts)
        local wk = require("which-key")
        wk.setup(opts)

        wk.add({
            { "<leader>a", group = "Autolist" },
            { "<leader>b", group = "Buffers" },
            { "<leader>c", group = "Copy" },
            { "<leader>d", group = "Debug" },
            { "<leader>e", group = "Explorer" },
            { "<leader>g", group = "Git" },
            { "<leader>gc", group = "Git Conflict" },
            { "<leader>h", group = "Harpoon" },
            { "<leader>i", group = "IDE" },
            { "<leader>ic", group = "Compile" },
            { "<leader>it", group = "Test" },
            { "<leader>j", group = "Telescope" },
            { "<leader>jg", desc = "Git" },
            { "<leader>l", group = "LSP" },
            { "<leader>lt", desc = "Tools" },
            { "<leader>o", group = "Open" },
            { "<leader>p", group = "Copilot" },
            { "<leader>r", group = "Refactor" },
            { "<leader>s", group = "Surround / Session" },
            { "<leader>t", group = "Tabs" },
            { "<leader>w", group = "Window" },
            { "<leader>x", group = "Quickfix List" },
            { "<leader>z", group = "Mode" },
            { "<leader>zc", desc = "Cloak" },
            { "gi", desc = "Go to implementation" },
        })

        -- local motions = {
        --     a = { name = "around" },
        --     i = { name = "inside" },
        --     ['a"'] = [[double quoted string]],
        --     ["a'"] = [[single quoted string]],
        --     ["a("] = [[same as ab]],
        --     ["a)"] = [[same as ab]],
        --     ["a<lt>"] = [[a <> from '<' to the matching '>']],
        --     ["a>"] = [[same as a<]],
        --     ["aB"] = [[a Block from [{ to ]} (with brackets)]],
        --     ["aW"] = [[a WORD (with white space)]],
        --     ["a["] = [[a [] from '[' to the matching ']']],
        --     ["a]"] = [[same as a[]],
        --     ["a`"] = [[string in backticks]],
        --     ["ab"] = [[a block from [( to ]) (with braces)]],
        --     ["ap"] = [[a paragraph (with white space)]],
        --     ["as"] = [[a sentence (with white space)]],
        --     ["at"] = [[a tag block (with white space)]],
        --     ["aw"] = [[a word (with white space)]],
        --     ["a{"] = [[same as aB]],
        --     ["a}"] = [[same as aB]],
        --     ['i"'] = [[double quoted string without the quotes]],
        --     ["i'"] = [[single quoted string without the quotes]],
        --     ["i("] = [[same as ib]],
        --     ["i)"] = [[same as ib]],
        --     ["i<lt>"] = [[inner <> from '<' to the matching '>']],
        --     ["i>"] = [[same as i<]],
        --     ["iB"] = [[inner Block from [{ and ]}]],
        --     ["iW"] = [[inner WORD]],
        --     ["i["] = [[inner [] from '[' to the matching ']']],
        --     ["i]"] = [[same as i[]],
        --     ["i`"] = [[string in backticks without the backticks]],
        --     ["ib"] = [[inner block from [( to ])]],
        --     ["ip"] = [[inner paragraph]],
        --     ["is"] = [[inner sentence]],
        --     ["it"] = [[inner tag block]],
        --     ["iw"] = [[inner word]],
        --     ["i{"] = [[same as iB]],
        --     ["i}"] = [[same as iB]],
        -- }
        --
        -- wk.register(motions, { prefix = "<leader>sa" })
    end,
}
