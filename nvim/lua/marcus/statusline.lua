-- Define custom highlight groups
vim.api.nvim_set_hl(0, "StatusLineWhiteBold", { fg = vim.api.nvim_get_hl(0, { name = "White" }).fg, bold = true })

-- Settings
local divider = "  "

-- Helper functions
local function hl(group, text)
    -- %%#GroupName#fext%*
    return string.format("%%#%s#%s%%*", group, text)
end

local function copilot_indicator()
    local client = vim.lsp.get_active_clients({ name = "copilot" })[1]
    if client == nil then
        return ""
    end

    if vim.tbl_isempty(client.requests) then
        return ""
    end

    local spinners = {
        "◜",
        "◠",
        "◝",
        "◞",
        "◡",
        "◟",
    }
    local ms = vim.loop.hrtime() / 1000000
    local frame = math.floor(ms / 120) % #spinners

    return spinners[frame + 1]
end

local function lsp_name()
    local msg = "No Active Lsp"
    local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
    local clients = vim.lsp.get_active_clients()
    if next(clients) == nil then
        return msg
    end
    for _, client in ipairs(clients) do
        local filetypes = client.config.filetypes
        if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
            return client.name
        end
    end
    return msg
end

-- Statusline sections
local function left()
    local mode_color = {
        n = "Green",
        i = "White",
        v = "Blue",
        V = "Blue",
        [""] = "Blue",
    }
    local mode = hl(mode_color[vim.api.nvim_get_mode().mode], vim.api.nvim_get_mode().mode:upper())
    local filename = vim.fn.expand("%:t")
    local git_branch = vim.b.gitsigns_head or "" -- Requires gitsigns.nvim

    local components = {
        " ",
        mode,
        hl("StatusLineWhiteBold", filename ~= "" and filename or "[No Name]"),
        vim.bo.modified and hl("White", "[+]") or "",
        vim.bo.readonly and hl("Red", "[RO]") or "",
        hl("Blue", vim.bo.filetype ~= "" and vim.bo.filetype or "no ft"),
        hl("Yellow", git_branch ~= "" and " " .. git_branch or ""),
        hl("Cyan", " " .. lsp_name()),
    }

    local cleaned_components = {}
    for _, comp in ipairs(components) do
        if comp ~= "" then
            table.insert(cleaned_components, comp)
        end
    end

    return table.concat(cleaned_components, divider)
end

local function center()
    local components = {
        vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })[1]
                and hl("Red", " " .. #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR }))
            or "",
        vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })[1]
                and hl("Yellow", " " .. #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN }))
            or "",
        vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })[1]
                and hl("Blue", " " .. #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO }))
            or "",
    }
    return table.concat(components, divider)
end

local function right()
    local line = vim.fn.line(".")
    local col = vim.fn.col(".")
    local total_lines = vim.fn.line("$")
    local components = {
        hl("Cyan", copilot_indicator()),
        hl("Blue", string.format("Ln %d, Col %d", line, col)),
        hl("Yellow", string.format("%d", total_lines)),
    }
    return table.concat(components, divider)
end

-- Assemble statusline
function _G.statusline()
    return left() .. "%=" .. center() .. "%=" .. right()
end

vim.opt.statusline = "%!v:lua.statusline()"
