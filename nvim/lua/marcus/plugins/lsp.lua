return {
    "neovim/nvim-lspconfig",
    -- event = { "BufReadPost", "BufNewFile" },
    dependencies = {
        { "williamboman/mason.nvim" },
        { "williamboman/mason-lspconfig.nvim" },
        { "hrsh7th/nvim-cmp" },
        { "onsails/lspkind.nvim" }, -- Icons

        { "hrsh7th/cmp-nvim-lsp" },
        { "hrsh7th/cmp-buffer" },
        { "hrsh7th/cmp-path" },
        { "hrsh7th/cmp-cmdline" },
        { "saadparwaiz1/cmp_luasnip" },
        {
            "L3MON4D3/LuaSnip",
            dependencies = {
                "rafamadriz/friendly-snippets",
            },
        },
        { "kirasok/cmp-hledger" },
        { "folke/neodev.nvim" },
        { "WhoIsSethDaniel/mason-tool-installer.nvim" },
        { "csharp.nvim" },
    },
    config = function()
        local cmp = require("cmp")
        local cmp_lsp = require("cmp_nvim_lsp")
        ---@diagnostic disable-next-line: missing-fields
        require("neodev").setup({ -- Before lspconfig
            override = function(_, library)
                library.enabled = true
                library.plugins = true
            end,
        })

        local ls = require("luasnip")
        local ls_vs_loader = require("luasnip.loaders.from_vscode")
        ls_vs_loader.lazy_load()
        ls_vs_loader.lazy_load({ paths = { "./lua/marcus/snippets" } })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }
        cmp.setup({
            mapping = cmp.mapping.preset.insert({
                ["<S-Tab>"] = cmp.mapping.select_prev_item(cmp_select),
                ["<Tab>"] = cmp.mapping.select_next_item(cmp_select),
                ["<C-y>"] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            ---@diagnostic disable-next-line: missing-fields
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
                { name = "hledger" },
            },
        })

        -- Setup keybindings
        vim.keymap.set("n", "<leader>lq", "<Cmd>LspInfo<CR>", { noremap = true, desc = "LSP info" })
        vim.keymap.set("n", "<leader>lr", "<Cmd>LspRestart<CR>", { noremap = true, desc = "LSP restart" })
        vim.keymap.set("n", "<leader>ls", "<Cmd>LspStop<CR>", { noremap = true, desc = "LSP stop" })
        vim.keymap.set("n", "<leader>ll", "<Cmd>LspLog<CR>", { noremap = true, desc = "LSP log" })
        vim.keymap.set("n", "<leader>li", "<Cmd>LspInstall<CR>", { noremap = true, desc = "LSP install" })
        vim.keymap.set("n", "<leader>lU", "<Cmd>LspUninstall<CR>", { noremap = true, desc = "LSP uninstall" })
        vim.keymap.set("n", "<leader>lti", "<Cmd>MasonToolsInstall<CR>", { noremap = true, desc = "LSP install" })
        vim.keymap.set("n", "<leader>ltc", "<Cmd>MasonToolsClean<CR>", { noremap = true, desc = "LSP clean" })
        vim.keymap.set("n", "<leader>ltu", "<Cmd>MasonToolsUpdate<CR>", { noremap = true, desc = "LSP update" })

        vim.keymap.set("n", "ge", vim.diagnostic.open_float, { noremap = true, desc = "Diagnostic float" })
        vim.keymap.set("n", "[e", vim.diagnostic.goto_next, { noremap = true, desc = "Next" })
        vim.keymap.set("n", "]e", vim.diagnostic.goto_prev, { noremap = true, desc = "Previous" })

        vim.api.nvim_create_autocmd("LspAttach", {
            desc = "LSP keybindings",
            callback = function(event)
                local client = vim.lsp.get_client_by_id(event.data.client_id)
                local builtin = require("telescope.builtin")

                local function opts(desc)
                    return { buffer = event.buf, silent = true, nowait = true, noremap = true, desc = desc }
                end

                -- Enable completion triggered by <c-x><c-o>
                -- vim.api.nvim_buf_set_option(event.buf, "omnifunc", "v:lua.vim.lsp.omnifunc")

                -- omnisharp loaded from csharp.lua
                if client ~= nil and client.name == "omnisharp" then
                    local csharp = prequire("csharp")
                    if csharp then
                        print("C# LSP loaded")
                        vim.keymap.set("n", "gd", csharp.go_to_definition, opts("Go to Definition"))
                        vim.keymap.set("n", "<leader>cF", csharp.fix_all, opts("Fix All"))
                        vim.keymap.set("n", "<F5>", csharp.debug_project, opts("Debug Project"))
                        vim.keymap.set("n", "<c-f5>", csharp.run_project, opts("Run Project"))
                    end
                else
                    vim.keymap.set("n", "gd", builtin.lsp_definitions, opts("Definition"))
                end
                vim.keymap.set("n", "gi", builtin.lsp_implementations, opts("Implementation"))
                vim.keymap.set("n", "gr", builtin.lsp_references, opts("References"))
                vim.keymap.set("n", "gh", vim.lsp.buf.hover, opts("Hover / Quick info"))
                vim.keymap.set("n", "gH", vim.lsp.buf.signature_help, opts("Signature help"))
                vim.keymap.set("n", "gs", builtin.lsp_workspace_symbols, opts("Workspace symbols"))
                vim.keymap.set("n", "<leader>jd", builtin.diagnostics, opts("Diagnostic"))
                vim.keymap.set("n", "<leader>je", function()
                    builtin.diagnostics({ severity = vim.diagnostic.severity.ERROR })
                end, opts("Diagnostic (errors)"))
                vim.keymap.set("n", "<leader>.", vim.lsp.buf.code_action, opts("Code action"))
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts("Rename"))
            end,
        })

        -- :MasonInstall roslyn
        require("mason").setup({
            registries = {
                "github:mason-org/mason-registry",
                "github:Crashdummyy/mason-registry",
            },
        })

        -- Setup defaults
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities()
        )

        local default_setup = function(server)
            require("lspconfig")[server].setup({
                capabilities = capabilities,
            })
        end

        -- Add border to lsp handlers
        local border = "rounded"
        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
            border = border,
        })
        vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
            border = border,
        })
        vim.diagnostic.config({
            float = { border = border },
        })

        -- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
        local ensure_installed = {
            "asm_lsp",  -- Assembly
            "bashls",   -- bash
            "clangd",   -- c
            "cssls",    -- css
            "dockerls", -- docker
            "elmls",    -- elm, npm install -g elm elm-test elm-format @elm-tooling/elm-language-server
            "eslint",
            -- "fsautocomplete", -- F#
            "gopls",         -- Go
            "hls",           -- Haskell
            "html",          -- HTML
            "jsonls",        -- Json
            "lua_ls",        -- Lua
            "marksman",      -- Markdown
            "ocamllsp",      -- OCaml
            -- "omnisharp", -- C#
            "pylsp",         -- Python
            -- "pyright", -- Python
            "roslyn",        -- C#
            "rust_analyzer", -- Rust
            "sqlls",         -- SQL
            "svelte",        -- Svelte
            "ts_ls",         -- JavaScript / TypeScript
            "yamlls",        -- yaml
        }

        local ensure_installed_tools = {
            "elm-format",        -- elm
            "stylua",            -- lua
            "csharpier",         -- csharp
            "fourmolu",          -- Haskell
            "isort",             -- Python
            "black",             -- Python
            "prettierd",         -- JavaScript / TypeScript
            "prettier",          -- JavaScript / TypeScript
            "shfmt",             -- bash
            "markdownlint",      -- Markdown
            "markdownlint-cli2", -- Markdown
            "ocamlformat",       -- OCaml
        }

        if jit.os == "Windows" then
            table.insert(ensure_installed, "powershell_es")
        end

        local setup_mason_lspconfig = function(lsps)
            ---@diagnostic disable-next-line: missing-fields
            require("mason-lspconfig").setup({
                ensure_installed = lsps,
                handlers = {
                    default_setup,
                },
            })
        end

        vim.api.nvim_create_user_command("MasonInstallAll", function()
            setup_mason_lspconfig(ensure_installed)
        end, {
            desc = "Install all LSP servers",
        })

        setup_mason_lspconfig({})

        local setup_mason_tool_installer = function(lsps)
            require("mason-tool-installer").setup({
                ensure_installed = lsps,
                auto_update = true,
                run_on_start = true,
                run_on_config = true,
            })
        end

        vim.api.nvim_create_user_command("MasonToolsInstallAll", function()
            setup_mason_lspconfig(ensure_installed_tools)
        end, {
            desc = "Install all LSP servers",
        })

        require("mason-tool-installer").setup({})

        require("lspconfig").hls.setup({
            settings = {
                haskell = {
                    formattingProvider = "fourmolu",
                },
            },
        })

        require("lspconfig").lua_ls.setup({
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

        if jit.os == "Windows" then
            require("lspconfig").powershell_es.setup({
                bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services",
                -- shell = "powershell.exe",
                -- cmd = { "pwsh", "-NoLogo", "-NoProfile", "-Command", "c:/PSES/Start-EditorServices.ps1 ..." },
            })
        end

        require("lspconfig").pylsp.setup({
            settings = {
                pylsp = {
                    plugins = {
                        pycodestyle = {
                            enabled = true,
                            maxLineLength = 100,
                        },
                    },
                },
            },
        })

        require("lspconfig").rust_analyzer.setup({
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
