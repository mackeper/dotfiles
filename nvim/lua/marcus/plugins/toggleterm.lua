return {
    'akinsho/toggleterm.nvim',
    enabled = true,
    lazy = true,
    event = "VeryLazy",
    -- version = "v2.8.*",
    config = function()
        -- Setup shell for windows
        vim.opt.shell = vim.fn.executable "pwsh" == 1 and "pwsh" or "powershell"
        vim.opt.shellcmdflag =
        "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
        vim.opt.shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait"
        vim.opt.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
        vim.opt.shellquote = ""
        vim.opt.shellxquote = ""

        local toggleterm = require("toggleterm")
        toggleterm.setup({
            direction = 'float',
            open_mapping = [[<C-\>]],
            insert_mappings = true,
            terminal_mappings = true,
            hide_numbers = true,
            float_opts = {
                border = 'curved',
                winblend = 0,
            },
        })

        -- vim.keymap.set("n", "<C-z>", toggleterm.toggleterm, { noremap = true, silent = true })
        -- vim.keymap.set("i", "<C-z>", toggleterm.toggleterm, { noremap = true, silent = true })
    end,
}
