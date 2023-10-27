return {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    dependencies = {
        -- LSP
        { 'williamboman/mason.nvim' },
        { 'williamboman/mason-lspconfig.nvim' },

        -- LSP Support
        { 'neovim/nvim-lspconfig' },

        -- Autocompletion
        { 'hrsh7th/nvim-cmp' },
        { 'onsails/lspkind.nvim' }, -- Icons
        { 'hrsh7th/cmp-nvim-lsp' },
        { 'L3MON4D3/LuaSnip' },
    },
    config = function()
        local lsp = require("lsp-zero")
        local cmp = require("cmp")
        local cmp_action = require("lsp-zero").cmp_action()

        cmp.setup({
            mapping = {
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
                ['<C-Space>'] = cmp.mapping.complete(),
            },
            formatting = {
                format = require("lspkind").cmp_format({ with_text = true, maxwidth = 50 }),
            },
            window = {
                completion = cmp.config.window.bordered(),
            },
        })

        lsp.on_attach(function(client, bufnr)
            local opts = { buffer = bufnr, remap = false, }

            vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
            vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
            vim.keymap.set("n", "gu", function() vim.lsp.buf.references() end, opts)
            vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
            vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
            vim.keymap.set("n", "[", function() vim.diagnostic.goto_next() end, opts)
            vim.keymap.set("n", "]", function() vim.diagnostic.goto_prev() end, opts)
            vim.keymap.set("n", "<leader>.", function() vim.lsp.buf.code_action() end, opts)
            vim.keymap.set("n", "<leader>r", function() vim.lsp.buf.rename() end, opts)
            vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format({ async = true, }) end, opts)
        end)

        require("mason").setup({})

        -- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
        require("mason-lspconfig").setup({
            ensure_installed = {
                "bashls",         -- bash
                "clangd",         -- c
                "cssls",          -- css
                "dockerls",       -- docker
                "elmls",          -- elm
                "eslint",
                "fsautocomplete", -- F#
                "hls",            -- Haskell
                "html",           -- HTML
                "jsonls",         -- Json
                "lua_ls",         -- Lua
                "marksman",       -- Markdown
                "omnisharp",      -- C# change to csharp_ls?
                "powershell_es",  -- PowerShell
                "pylsp",          -- Python
                "rust_analyzer",  -- Rust
                "sqlls",          -- SQL
                "tsserver",       -- JavaScript / TypeScript
                "yamlls",         -- yaml
            },
            handlers = {
                lsp.default_setup,
            },
        })

        require("lspconfig").lua_ls.setup({})
        require("lspconfig").pylsp.setup({
            settings = {
                pylsp = {
                    plugins = {
                        pycodestyle = {
                            maxLineLength = 120,
                        }
                    }
                }
            }
        })
    end
}
