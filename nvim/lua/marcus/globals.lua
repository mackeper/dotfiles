P = function(v)
    print(vim.inspect(v))
    return v
end

function prequire(...)
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
