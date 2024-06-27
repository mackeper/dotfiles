return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.4",
    event = "VeryLazy",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        local builtin = require("telescope.builtin")
        local telescope = require("telescope")
        telescope.load_extension("projects")

        -- stylua: ignore
        telescope.setup({
            pickers = {
                find_files = { hidden = true, },
                live_grep = { hidden = true, },
                git_files = { hidden = true, },
                git_bcommits = { hidden = true, },
                git_commits = { hidden = true, },
                git_status = { hidden = true, },
                git_branches = { hidden = true, },
                git_stash = { hidden = true, },
                help_tags = { hidden = true, },
                oldfiles = { hidden = true, },
                projects = { hidden = true, },
            },
        })

        -- Setup trouble.nvim integration
        local actions = require("telescope.actions")
        telescope.setup({
            defaults = {
                mappings = {
                    i = {
                        ["<c-t>"] = require("trouble.sources.telescope").open,
                        ["<C-q>"] = function(prompt_bufnr)
                            actions.send_to_qflist(prompt_bufnr)
                            require("trouble").open("quickfix")
                        end,
                    },
                    n = {
                        ["<c-t>"] = require("trouble.sources.telescope").open,
                        ["<C-q>"] = function(prompt_bufnr)
                            actions.send_to_qflist(prompt_bufnr)
                            require("trouble").open("quickfix")
                        end,
                    },
                },
            },
        })

        -- stylua: ignore start
        -- Keymaps
        vim.keymap.set("n", "<leader>jt", builtin.builtin, { desc = "Telescope" })
        vim.keymap.set("n", "<leader>jb", builtin.buffers, { desc = "Buffers" })
        vim.keymap.set("n", "<leader>jf", builtin.find_files, { desc = "Find files" })
        vim.keymap.set("n", "<leader>jgg", builtin.live_grep, { desc = "Live grep" })
        vim.keymap.set("n", "<leader>jgb", builtin.git_branches, { desc = "Git branches" })
        vim.keymap.set("n", "<leader>jgc", builtin.git_commits, { desc = "Git commits" })
        vim.keymap.set("n", "<leader>jgt", builtin.git_stash, { desc = "Git stash" })
        vim.keymap.set("n", "<leader>jgs", builtin.git_status, { desc = "Git status" })
        vim.keymap.set("n", "<leader>jgf", builtin.git_files, { desc = "Git files" })
        vim.keymap.set("n", "<leader>jgo", builtin.git_bcommits, { desc = "Git bcommits" })
        vim.keymap.set("n", "<leader>jh", builtin.help_tags, { desc = "Help" })
        vim.keymap.set("n", "<leader>jm", builtin.oldfiles, { desc = "Recent files" })
        vim.keymap.set("n", "<leader>jr", builtin.git_files, { desc = "Git files" })
        vim.keymap.set("n", "<leader>jc", function() builtin.colorscheme({ enable_preview = true }) end, { desc = "Colorschemes" })
        vim.keymap.set("n", "<leader>jp", telescope.extensions.projects.projects, { desc = "Projects" })
        vim.keymap.set("n", "<leader>jn", function() builtin.find_files({ cwd = vim.fn.stdpath("config") }) end, { desc = "Neovim files" })
        -- stylua: ignore end
    end,
}
