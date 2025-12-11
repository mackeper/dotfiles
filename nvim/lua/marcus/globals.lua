P = function(v)
    print(vim.inspect(v))
    return v
end

function Prequire(...)
    local status, lib = pcall(require, ...)
    if status then
        return lib
    end
    return nil
end

vim.api.nvim_create_user_command("Scratch", function()
    vim.cmd("enew")
    vim.bo.buftype = "nofile"
    vim.bo.bufhidden = "hide"
    vim.bo.swapfile = false
end, {})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "lua",
    callback = function()
        vim.keymap.set("n", "<leader><leader>", function()
            vim.cmd("luafile " .. vim.fn.expand("%"))
            print("Reloaded " .. vim.fn.expand("%:t"))
        end, { desc = "Reload current Lua file", buffer = true })
        vim.keymap.set("v", "<leader><leader>", function()
            local lines = vim.api.nvim_buf_get_lines(0, vim.fn.line("'<") - 1, vim.fn.line("'>"), false)
            local code = table.concat(lines, "\n")
            load(code)()
        end, { silent = true })
    end,
})
