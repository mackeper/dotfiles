return {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    lazy = true,
    event = 'VeryLazy',
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
        {
            'L3MON4D3/LuaSnip',
            dependencies = {
                "rafamadriz/friendly-snippets",
            }
        },

        { 'saadparwaiz1/cmp_luasnip' },

        -- Neovim lsp?
        { 'folke/neodev.nvim' },
    },
    config = function()
        local lsp = require("lsp-zero")
        local cmp = require("cmp")
        local cmp_action = require("lsp-zero").cmp_action()
        require("neodev").setup() -- Before lspconfig

        local ls = require("luasnip")
        local ls_vs_loader = require("luasnip.loaders.from_vscode")
        ls_vs_loader.lazy_load()
        ls_vs_loader.lazy_load({ paths = { './lua/marcus/snippets' } })

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
            snippet = {
                expand = function(args)
                    ls.lsp_expand(args.body)
                end
            },
            sources = {
                { name = 'nvim_lsp' },
                { name = "luasnip" },
            },
        })

        lsp.on_attach(function(client, bufnr)
            local function opts(desc)
                return { buffer = bufnr, noremap = true, desc = desc, }
            end

            local builtin = require("telescope.builtin")

            -- vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts("Definition"))
            vim.keymap.set("n", "gd", builtin.lsp_definitions, opts("Definition"))
            -- vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts("Implementation"))
            vim.keymap.set("n", "gi", builtin.lsp_implementations, opts("Implementation"))
            -- vim.keymap.set("n", "gu", function() vim.lsp.buf.references() end, opts("Usages"))
            vim.keymap.set("n", "gu", builtin.lsp_references, opts("Usages"))
            vim.keymap.set("n", "gh", function() vim.lsp.buf.hover() end, opts("Hover / Quick info"))
            -- vim.keymap.set("n", "<C-t>", function() vim.lsp.buf.workspace_symbol() end, opts("Workspace symbols"))
            vim.keymap.set("n", "<C-t>", builtin.lsp_workspace_symbols, opts("Workspace symbols"))
            vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts("Diagnostic float"))
            vim.keymap.set("n", "<leader>jd", builtin.diagnostics, opts("Diagnostic"))
            vim.keymap.set("n", "<leader>je",
                function() builtin.diagnostics({ severity = vim.diagnostic.severity.ERROR, }) end,
                opts("Diagnostic (errors)"))
            vim.keymap.set("n", "[", function() vim.diagnostic.goto_next() end, opts("Next"))
            vim.keymap.set("n", "]", function() vim.diagnostic.goto_prev() end, opts("Previous"))
            vim.keymap.set("n", "<leader>.", function() vim.lsp.buf.code_action() end, opts("Code action"))
            vim.keymap.set("n", "<leader>r", function() vim.lsp.buf.rename() end, opts("Rename"))
            vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format({ async = true, }) end, opts("Format"))
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

        local lspconfig = require("lspconfig")

        lspconfig.bashls.setup({})
        lspconfig.clangd.setup({})
        lspconfig.cssls.setup({})
        lspconfig.dockerls.setup({})
        lspconfig.elmls.setup({})
        lspconfig.eslint.setup({})
        lspconfig.fsautocomplete.setup({})
        lspconfig.hls.setup({
            settings = {
                haskell = {
                    formattingProvider = "fourmolu",
                },
            },
        })
        lspconfig.html.setup({})
        lspconfig.jsonls.setup({})
        lspconfig.lua_ls.setup({
            settings = {
                Lua = {
                    runtime = {
                        -- Tell the language server which version of Lua you're using
                        -- (most likely LuaJIT in the case of Neovim)
                        version = 'LuaJIT',
                    },
                    diagnostics = {
                        -- Get the language server to recognize the `vim` global
                        globals = {
                            'vim',
                            'require'
                        },
                    },
                    workspace = {
                        -- Make the server aware of Neovim runtime files
                        -- library = vim.api.nvim_get_runtime_file("", true),

                        checkThirdParty = false,
                        library = {
                            vim.env.VIMRUNTIME
                            -- "${3rd}/luv/library"
                            -- "${3rd}/busted/library",
                        },
                    },
                    -- Do not send telemetry data containing a randomized but unique identifier
                    telemetry = {
                        enable = false,
                    },
                },
            },
        })
        lspconfig.marksman.setup({})
        lspconfig.omnisharp.setup({
            cmd = {
                "dotnet",
                vim.fn.stdpath('data') .. '/mason/packages/omnisharp/libexec/OmniSharp.dll'
            },
            sdk_include_prereleases = true,
            enable_editorconfig_support = true,
            enable_roslyn_analyzers = true,
            organize_imports_on_format = true,
            enable_import_completion = true,
        })
        lspconfig.powershell_es.setup({
            -- bundle_path = vim.fn.stdpath('data') .. 'mason\\packages\\powershell-editor-services\\PowerShellEditorServices',
            shell = "powershell.exe",
        })
        lspconfig.pylsp.setup({
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
        lspconfig.rust_analyzer.setup({})
        lspconfig.sqlls.setup({})
        lspconfig.tsserver.setup({})
        lspconfig.yamlls.setup({})
    end
}
