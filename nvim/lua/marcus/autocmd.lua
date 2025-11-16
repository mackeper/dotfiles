-- https://neovim.io/doc/user/lua-guide.html#lua-guide-autocommand-create
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank({ timeout = 1000 })
    end,
    desc = "Briefly highlight yanked text",
})

-- Auto-commit and push on buffer write for allowed repositories
local allowed_repos = { "notes", "wiki" }
local function is_repo_allowed(repo_name)
    for _, name in ipairs(allowed_repos) do
        if name == repo_name then
            return true
        end
    end
    return false
end

vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*",
    callback = function()
        -- local cwd = vim.fn.getcwd()
        local cwd = vim.fn.expand("%:p:h")
        local git_root = vim.fn.systemlist({ "git", "-C", cwd, "rev-parse", "--show-toplevel" })[1]
        if not git_root then
            return
        end

        local repo_name = vim.fn.fnamemodify(git_root, ":t")
        if not is_repo_allowed(repo_name) then
            return
        end

        local filename = vim.fn.expand("%")
        local commit_msg = "auto-commit: " .. filename

        -- vim.fn.jobstart({ "git", "-C", cwd, "pull" }, {
        --     on_exit = function() end,
        -- })

        vim.fn.jobstart({ "git", "-C", cwd, "add", "." }, {
            on_exit = function()
                vim.fn.jobstart({ "git", "-C", cwd, "commit", "-m", commit_msg }, {
                    on_exit = function()
                        vim.fn.jobstart({ "git", "-C", cwd, "push" }, {
                            on_exit = function()
                                vim.schedule(function()
                                    vim.notify(
                                        "Git push completed: " .. filename .. " to " .. repo_name,
                                        vim.log.levels.INFO
                                    )
                                end)
                            end,
                        })
                    end,
                })
            end,
        })
    end,
})

-- Disable automatic end-of-line insertion for .props files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.props",
    callback = function()
        vim.opt_local.fixendofline = false
        vim.opt_local.endofline = false
    end,
})

-- Highlight cursor line only in active window
vim.api.nvim_create_autocmd("WinEnter", {
    callback = function()
        vim.opt.cursorline = true
    end,
})
vim.api.nvim_create_autocmd("WinLeave", {
    callback = function()
        vim.opt.cursorline = false
    end,
})

-- Restore cursor position when reopening files
vim.api.nvim_create_autocmd({ "BufReadPost", "BufWinEnter" }, {
    once = true,
    callback = function(args)
        local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
        local line_count = vim.api.nvim_buf_line_count(args.buf)
        if mark[1] > 0 and mark[1] <= line_count then
            vim.api.nvim_win_set_cursor(0, mark)
            vim.schedule(function()
                vim.cmd("normal! zz")
            end)
        end
    end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- no auto continue comments on new line
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("no_auto_comment", {}),
    callback = function()
        vim.opt_local.formatoptions:remove({ "c", "r", "o" })
    end,
})
