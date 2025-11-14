return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        bigfile = { enabled = true },
        quickfile = { enabled = true },
        dashboard = { enabled = true },
        profiler = { enabled = true },
        gitbrowse = {
            enabled = true,
            -- Cannot get this to work on Windows
            open = function(url)
                vim.cmd("!explorer.exe '" .. url .. "'")
            end,
        },
        lazygit = { enabled = true },
        notifier = { enabled = true, timeout = 10000 },
        -- statuscolumn = {
        --     enabled = true,
        --     left = { "mark", "sign" },
        --     right = { "fold", "git" },
        -- },
        terminal = { enabled = true },
        toggle = { enabled = true },
        words = { enabled = true },
        styles = {
            notification = {
                wo = {
                    wrap = true,
                },
            },
        },
        zen = {},
        picker = {
            enabled = true,
            layout = "dropdown",
        },
    },
    -- stylua: ignore start
    keys = {
        { "<leader>gB", function() Snacks.gitbrowse() end,    desc = "Gitbrowse", },
        { "<C-g>",      function() Snacks.lazygit.open() end, desc = "Lazygit", },
        -- { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
        -- { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
        { "<leader>tt", function() Snacks.terminal() end,     desc = "Toggle Terminal" },
        { "<leader>zm", function() Snacks.zen() end,          desc = "Toggle Zen Mode" },
    },
    -- stylua: ignore end
    config = function(_, opts)
        require("snacks").setup(opts)

        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
                local function map_opts(desc)
                    return { buffer = args.buf, silent = true, nowait = true, noremap = true, desc = desc }
                end

                -- stylua: ignore start
                vim.keymap.set("n", "gr", require("snacks.picker").lsp_references , map_opts("LSP References"))
                vim.keymap.set("n", "gd", require("snacks.picker").lsp_definitions, map_opts("LSP Definitions"))
                vim.keymap.set("n", "gi", require("snacks.picker").lsp_implementations, map_opts("LSP Implementations"))
                vim.keymap.set("n", "<leader>jd", require("snacks.picker").diagnostics, map_opts("LSP Diagnostics"))
                -- stylua: ignore end
            end,
        })

        local function map(mode, key, func, description)
            vim.keymap.set(mode, key, func, { desc = description, noremap = true, silent = true })
        end

        if opts.picker.enabled then
            local function config_picker()
                return Snacks.picker.files({
                    dir = vim.fn.stdpath("config"),
                })
            end
            -- stylua: ignore start
            map("n", "<leader>jf", Snacks.picker.smart, "Smart Find Files" )
            map("n", "<leader>jg", Snacks.picker.git_grep, "Git Grep" )
            map("n", "<leader>jh", Snacks.picker.help, "Find help" )
            map("n", "<leader>jm", Snacks.picker.man, "Find man pages" )
            map("n", "<leader>jp", Snacks.picker.pickers, "Find picker" )
            map("n", "<leader>jr", Snacks.picker.recent, "Find recent files" )
            map("n", "<leader>jj", Snacks.picker.resume, "Resume last picker" )
            map("n", "<leader>jb", Snacks.picker.buffers, "Find buffers" )
            map("n", "<leader>jc", config_picker, "Find files" )
            -- stylua: ignore end
        end
    end,
}
