return {
    "akinsho/toggleterm.nvim",
    event = { "BufReadPost", "BufNewFile" },
    -- version = "v2.8.*",
    config = function()
        -- Setup shell for windows
        if jit.os == "Windows" then
            vim.opt.shell = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell"
            vim.opt.shellcmdflag =
                "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
            vim.opt.shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait"
            vim.opt.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
            vim.opt.shellquote = ""
            vim.opt.shellxquote = ""
        end

        require("toggleterm").setup({
            direction = "float",
            size = 20,
            open_mapping = [[<C-\>]],
            insert_mappings = true,
            terminal_mappings = true,
            hide_numbers = true,
            float_opts = {
                border = "curved",
                winblend = 0,
            },
            auto_scroll = true,
            shell = nil,
        })

        local Terminal = require("toggleterm.terminal").Terminal
        local lazygit = Terminal:new({
            cmd = "lazygit",
            hidden = true,
            count = 2,
            direction = "float",
            terminal_mappings = false,
        })

        vim.keymap.set("n", "<C-g>", function()
            lazygit:toggle()
        end, { noremap = true, silent = true })

        vim.keymap.set("t", "<C-g>", function()
            lazygit:toggle()
        end, { noremap = true, silent = true })

        -- local python = Terminal:new({
        --     hidden = true,
        --     dir = "%:p:h",
        --     count = 3,
        -- })
    end,
}
