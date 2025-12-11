return {
    enabled = true,
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
        signs = {
            add = { text = "▎" },
            change = { text = "▎" },
            delete = { text = "" },
            topdelete = { text = "" },
            changedelete = { text = "▎" },
            untracked = { text = "▎" },
        },
        current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts = {
            virt_text = true,
            virt_text_pos = "right_align", -- 'eol' | 'overlay' | 'right_align'
            delay = 1000,
            ignore_whitespace = false,
            virt_text_priority = 100,
        },
        preview_config = {
            border = "rounded",
        },
        current_line_blame_formatter = "<author>, <author_time:%R> <abbrev_sha>",
        on_attach = function(_)
            local gs = package.loaded.gitsigns
            local function opts(desc)
                return { noremap = true, silent = true, desc = desc }
            end
            vim.keymap.set("n", "<leader>gp", gs.preview_hunk, opts("Preview hunk"))
            vim.keymap.set("n", "<leader>gr", gs.reset_hunk, opts("Reset hunk"))
            vim.keymap.set("n", "<leader>gs", gs.stage_hunk, opts("Stage hunk"))
            vim.keymap.set("n", "<leader>gb", function()
                gs.blame_line({ full = true })
            end, opts("Blame line"))
            vim.keymap.set("n", "<leader>gu", gs.undo_stage_hunk, opts("Undo stage hunk"))
            vim.keymap.set("n", "<leader>gD", gs.toggle_deleted, opts("Toggle deleted"))
            vim.keymap.set("n", "<leader>gC", function()
                gs.blame_line({ full = false }, function()
                    gs.blame_line({}, function()
                        local sha = vim.fn.getline(1):match("^(%x+)")
                        vim.notify("Copied commit SHA: " .. sha, vim.log.levels.INFO)
                        vim.cmd("quit")
                        if sha then
                            vim.fn.setreg('"', sha)
                        end
                    end)
                end)
            end, opts("Blame line and copy SHA"))
            vim.keymap.set("n", "<leader>go", function()
                local row = vim.fn.line(".")
                local file = vim.fn.expand("%:p")
                local git_blame_command = "git blame --porcelain -L " .. row .. "," .. row .. " " .. file
                local out = vim.fn.systemlist(git_blame_command)

                local sha = out[1] and out[1]:match("^(%x+)")
                if not sha then
                    vim.notify("Could not find commit SHA", vim.log.levels.ERROR)
                    return
                end

                local remote = vim.fn.systemlist("git config --get remote.origin.url")[1]
                if remote:match("^git@") then
                    remote = remote:gsub("^git@", "https://"):gsub(":", "/")
                end
                remote = remote:gsub("%.git$", "")

                vim.ui.open(remote .. "/commit/" .. sha)
            end, opts("Open commit in browser"))
        end,
    },
}
