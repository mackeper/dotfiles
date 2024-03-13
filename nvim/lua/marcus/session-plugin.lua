-- vim.api.nvim_create_autocmd("ExitPre", {
vim.api.nvim_create_autocmd("BufWrite", {
    desc = "Save session on exit",
    group = vim.api.nvim_create_augroup("session-plugin", { clear = true }),
    callback = function()
        local session_dir = vim.fn.stdpath("data") .. "/sessions"
        print(session_dir)
        print(vim.fn.isdirectory(session_dir))
        if vim.fn.isdirectory(session_dir) == 0 then
            print("Directory does not exist")
            vim.fn.mkdir(session_dir, "p")
        end

        local cwd_encoded = vim.fn.substitute(vim.fn.getcwd(), "/", "BLAH", "g")
        print(cwd_encoded)
        local session_file = session_dir .. "/" .. cwd_encoded .. ".vim"
        print("Saving session " .. session_file)
        vim.cmd("mksession! " .. session_file)
    end,
})
