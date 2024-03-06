return {
    "neovim/nvim-lspconfig",
    lazy = true,
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
        { "williamboman/mason.nvim" },
        { "williamboman/mason-lspconfig.nvim" },
        { "hrsh7th/nvim-cmp" },
        { "onsails/lspkind.nvim" }, -- Icons
        { "hrsh7th/cmp-nvim-lsp" },
        { "hrsh7th/cmp-buffer", },
        { "hrsh7th/cmp-path", },
        { "hrsh7th/cmp-cmdline", },
        { "saadparwaiz1/cmp_luasnip" },
        {
            "L3MON4D3/LuaSnip",
            dependencies = {
                "rafamadriz/friendly-snippets",
            },
        },
        { "folke/neodev.nvim" },
        { "WhoIsSethDaniel/mason-tool-installer.nvim" },
        { "Hoffs/omnisharp-extended-lsp.nvim" },
    },
    config = function()
        local cmp = require("cmp")
        local cmp_lsp = require("cmp_nvim_lsp")
        require("neodev").setup() -- Before lspconfig

        local ls = require("luasnip")
        local ls_vs_loader = require("luasnip.loaders.from_vscode")
        ls_vs_loader.lazy_load()
        ls_vs_loader.lazy_load({ paths = { "./lua/marcus/snippets" } })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }
        cmp.setup({
            mapping = cmp.mapping.preset.insert({
                ['<S-Tab>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<Tab>'] = cmp.mapping.select_next_item(cmp_select),
                ["<CR>"] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            formatting = {
                format = require("lspkind").cmp_format({ with_text = true, maxwidth = 50 }),
            },
            window = {
                completion = cmp.config.window.bordered(),
            },
            snippet = {
                expand = function(args)
                    ls.lsp_expand(args.body)
                end,
            },
            sources = {
                { name = "nvim_lsp" },
                { name = "luasnip" },
                { name = "path" },
                { name = "buffer" },
            },
        })

        -- Setup keybindings
        vim.api.nvim_create_autocmd('LspAttach', {
            desc = "LSP keybindings",
            callback = function(event)
                local function opts(desc)
                    return { buffer = event.buf, noremap = true, desc = desc }
                end

                local builtin = require("telescope.builtin")

                vim.keymap.set("n", "gd", builtin.lsp_definitions, opts("Definition"))
                vim.keymap.set("n", "gi", builtin.lsp_implementations, opts("Implementation"))
                vim.keymap.set("n", "gr", builtin.lsp_references, opts("References"))
                vim.keymap.set("n", "gh", vim.lsp.buf.hover, opts("Hover / Quick info"))
                vim.keymap.set("n", "<C-t>", builtin.lsp_workspace_symbols, opts("Workspace symbols"))
                vim.keymap.set("n", "<leader>jd", builtin.diagnostics, opts("Diagnostic"))
                vim.keymap.set("n", "<leader>je", function()
                    builtin.diagnostics({ severity = vim.diagnostic.severity.ERROR })
                end, opts("Diagnostic (errors)"))
                vim.keymap.set("n", "[e", vim.diagnostic.goto_next, opts("Next"))
                vim.keymap.set("n", "]e", vim.diagnostic.goto_prev, opts("Previous"))
                vim.keymap.set("n", "<leader>.", vim.lsp.buf.code_action, opts("Code action"))
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts("Rename"))
                -- vim.keymap.set("n", "<C-h>", vim.lsp.signature_help, opts("Signature help"))
            end
        })

        require("mason").setup({})

        -- Setup defaults
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        local default_setup = function(server)
            require('lspconfig')[server].setup({
                capabilities = capabilities,
            })
        end

        -- Add border to lsp handlers
        local border = "rounded"
        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
            border = border
        })
        vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
            border = border
        })
        vim.diagnostic.config{
            float = { border = border }
        }

        -- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
        require("mason-lspconfig").setup({
            ensure_installed = {
                "bashls", -- bash
                "clangd", -- c
                "cssls", -- css
                "dockerls", -- docker
                "elmls", -- elm, npm install -g elm elm-test elm-format @elm-tooling/elm-language-server
                "eslint",
                -- "fsautocomplete", -- F#
                "gopls", -- Go
                -- "hls", -- Haskell
                "html", -- HTML
                "jsonls", -- Json
                "lua_ls", -- Lua
                "marksman", -- Markdown
                "omnisharp", -- C# change to csharp_ls?
                -- "powershell_es", -- PowerShell
                "pylsp", -- Python
                -- "pyright", -- Python
                "rust_analyzer", -- Rust
                "sqlls", -- SQL
                "svelte", -- Svelte
                "tsserver", -- JavaScript / TypeScript
                "yamlls", -- yaml
            },
            handlers = {
                default_setup,
            },
        })

        require("mason-tool-installer").setup({
            ensure_installed = {
                "elm-format", -- elm
                "stylua", -- lua
            },
        })

        require('lspconfig').hls.setup({
            settings = {
                haskell = {
                    formattingProvider = "fourmolu",
                },
            },
        })

        require('lspconfig').lua_ls.setup({
            settings = {
                Lua = {
                    runtime = {
                        version = "LuaJIT",
                    },
                    diagnostics = {
                        globals = {
                            "vim",
                            "require",
                        },
                    },
                    workspace = {
                        checkThirdParty = false,
                        library = {
                            vim.env.VIMRUNTIME,
                        },
                    },
                    telemetry = {
                        enable = false,
                    },
                },
            },
        })

        require('lspconfig').omnisharp.setup({
            cmd = {
                "dotnet",
                vim.fn.stdpath("data") .. "/mason/packages/omnisharp/libexec/OmniSharp.dll",
            },
            sdk_include_prereleases = true,
            enable_editorconfig_support = true,
            enable_roslyn_analyzers = true,
            organize_imports_on_format = true,
            enable_import_completion = true,
            handlers = {
                ["textDocument/definition"] = require("omnisharp_extended").handler,
            },
        })

        -- require('lspconfig').powershell_es.setup({
        -- 	bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services",
        -- 	-- shell = "powershell.exe",
        -- 	-- cmd = { "pwsh", "-NoLogo", "-NoProfile", "-Command", "c:/PSES/Start-EditorServices.ps1 ..." },
        -- })

        require('lspconfig').pylsp.setup({
            settings = {
                pylsp = {
                    plugins = {
                        pycodestyle = {
                            enabled = true,
                            maxLineLength = 100
                        },
                    },
                },
            },
        })

        vim.api.nvim_create_autocmd('BufWritePre', {
            desc = 'Format python on write using black',
            pattern = '*.py',
            group = vim.api.nvim_create_augroup('black_on_save', { clear = true }),
            callback = function()
                local format_command = { "black", vim.api.nvim_buf_get_name(0) }
                vim.fn.jobstart(format_command, {
                    on_exit = function(_, code, _)
                        if code == 0 then
                            vim.api.nvim_command('e!')
                        end
                    end,
                })
            end,
        })

        require('lspconfig').rust_analyzer.setup({
            settings = {
                ["rust-analyzer"] = {
                    diagnostics = {
                        enable = false,
                    },
                },
            },
        })
    end,
}
