return {
    "folke/which-key.nvim",
    enabled = true,
    lazy = true,
    event = "VeryLazy",
    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 100
    end,
    opts = {
        window = {
            border = "single",
        },
    },
    config = function(_, opts)
        local wk = require("which-key")
        wk.setup(opts)

        wk.register({
            ["<leader>a"] = { name = "+ Autolist" },
            ["<leader>b"] = { name = "+ Buffers" },
            ["<leader>c"] = { name = "+ Copy" },
            ["<leader>e"] = { name = "+ Explorer" },
            ["<leader>g"] = { name = "+ Git" },
            ["<leader>j"] = { name = "+ Telescope" },
            ["<leader>jg"] = { name = "+ Git" },
            ["<leader>l"] = { name = "+ LSP" },
            ["<leader>lt"] = { name = "+ Tools" },
            ["<leader>o"] = { name = "+ Open" },
            ["<leader>r"] = { name = "+ Refactor" },
            ["<leader>s"] = { name = "+ Surround" },
            ["<leader>t"] = { name = "+ Tabs" },
            ["<leader>w"] = { name = "+ Window" },
            ["<leader>x"] = { name = "+ Trouble" },
            ["<leader>z"] = { name = "+ Mode" },
        })

        wk.register({
            ["gi"] = { name = "Implementation" },
        })

        local motions = {
            a = { name = "around" },
            i = { name = "inside" },
            ['a"'] = [[double quoted string]],
            ["a'"] = [[single quoted string]],
            ["a("] = [[same as ab]],
            ["a)"] = [[same as ab]],
            ["a<lt>"] = [[a <> from '<' to the matching '>']],
            ["a>"] = [[same as a<]],
            ["aB"] = [[a Block from [{ to ]} (with brackets)]],
            ["aW"] = [[a WORD (with white space)]],
            ["a["] = [[a [] from '[' to the matching ']']],
            ["a]"] = [[same as a[]],
            ["a`"] = [[string in backticks]],
            ["ab"] = [[a block from [( to ]) (with braces)]],
            ["ap"] = [[a paragraph (with white space)]],
            ["as"] = [[a sentence (with white space)]],
            ["at"] = [[a tag block (with white space)]],
            ["aw"] = [[a word (with white space)]],
            ["a{"] = [[same as aB]],
            ["a}"] = [[same as aB]],
            ['i"'] = [[double quoted string without the quotes]],
            ["i'"] = [[single quoted string without the quotes]],
            ["i("] = [[same as ib]],
            ["i)"] = [[same as ib]],
            ["i<lt>"] = [[inner <> from '<' to the matching '>']],
            ["i>"] = [[same as i<]],
            ["iB"] = [[inner Block from [{ and ]}]],
            ["iW"] = [[inner WORD]],
            ["i["] = [[inner [] from '[' to the matching ']']],
            ["i]"] = [[same as i[]],
            ["i`"] = [[string in backticks without the backticks]],
            ["ib"] = [[inner block from [( to ])]],
            ["ip"] = [[inner paragraph]],
            ["is"] = [[inner sentence]],
            ["it"] = [[inner tag block]],
            ["iw"] = [[inner word]],
            ["i{"] = [[same as iB]],
            ["i}"] = [[same as iB]],
        }

        wk.register(motions, { prefix = "<leader>sa" })
    end,
}
