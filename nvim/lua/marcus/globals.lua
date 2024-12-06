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
