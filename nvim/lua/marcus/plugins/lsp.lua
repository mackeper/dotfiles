return {
    "neovim/nvim-lspconfig",
    enabled = true,
    -- event = { "BufReadPost", "BufNewFile" },
    event = { "VeryLazy" },
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
        { "L3MON4D3/LuaSnip" },
        { "folke/neodev.nvim" },
        { "WhoIsSethDaniel/mason-tool-installer.nvim" },
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

        ---- Setup nvim-cmp ----
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
            performance = {
                max_view_entries = 10,
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
        -- <C-w>d to show lsp diagnostics
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
        vim.keymap.set("n", "[e", function()
            vim.diagnostic.jump({ count = 1, float = true })
        end, { noremap = true, desc = "Next" })
        vim.keymap.set("n", "]e", function()
            vim.diagnostic.jump({ count = -1, float = true })
        end, { noremap = true, desc = "Previous" })

        vim.api.nvim_create_autocmd("LspAttach", {
            desc = "LSP keybindings",
            callback = function(event)
                -- local client = vim.lsp.get_client_by_id(event.data.client_id)

                local function opts(desc)
                    return { buffer = event.buf, silent = true, nowait = true, noremap = true, desc = desc }
                end

                -- Move to telescope
                local telescope_enabled, telescope = pcall(require, "telescope.builtin")
                if telescope_enabled then
                    vim.keymap.set("n", "gd", telescope.lsp_definitions, opts("Definition"))
                    vim.keymap.set("n", "gi", telescope.lsp_implementations, opts("Implementation"))
                    vim.keymap.set("n", "gr", telescope.lsp_references, opts("References"))
                    vim.keymap.set("n", "gs", telescope.lsp_workspace_symbols, opts("Workspace symbols"))
                    vim.keymap.set("n", "<leader>jd", telescope.diagnostics, opts("Diagnostic"))
                    vim.keymap.set("n", "<leader>je", function()
                        telescope.diagnostics({ severity = vim.diagnostic.severity.ERROR })
                    end, opts("Diagnostic (errors)"))
                end

                -- vim.api.nvim_buf_set_option(event.buf, "omnifunc", "v:lua.vim.lsp.omnifunc")

                -- <C-x><C-o> to show completion
                -- <C-w>d to show lsp diagnostics
                vim.keymap.set("n", "gh", vim.lsp.buf.hover, opts("Hover / Quick info"))
                vim.keymap.set("n", "gH", vim.lsp.buf.signature_help, opts("Signature help"))
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
            vim.lsp.config(server, {
                settings = {
                    [server] = {
                        capabilities = capabilities,
                    },
                },
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
            "asm_lsp", -- Assembly
            "bashls", -- bash
            "clangd", -- c
            "cssls", -- css
            "dockerls", -- docker
            "elmls", -- elm, npm install -g elm elm-test elm-format @elm-tooling/elm-language-server
            "eslint",
            -- "fsautocomplete", -- F#
            "gopls", -- Go
            "hls", -- Haskell
            "html", -- HTML
            "jsonls", -- Json
            "lua_ls", -- Lua
            "marksman", -- Markdown
            "ocamllsp", -- OCaml
            -- "omnisharp", -- C#
            "pylsp", -- Python
            -- "pyright", -- Python
            "roslyn", -- C#
            "rust_analyzer", -- Rust
            "sqlls", -- SQL
            "svelte", -- Svelte
            "ts_ls", -- JavaScript / TypeScript
            "yamlls", -- yaml
        }

        local ensure_installed_tools = {
            "elm-format", -- elm
            "stylua", -- lua
            "csharpier", -- csharp
            "fourmolu", -- Haskell
            "isort", -- Python
            "black", -- Python
            "prettierd", -- JavaScript / TypeScript
            "prettier", -- JavaScript / TypeScript
            "shfmt", -- bash
            "markdownlint", -- Markdown
            "markdownlint-cli2", -- Markdown
            "ocamlformat", -- OCaml
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
            desc = "Install all tools",
        })

        require("mason-tool-installer").setup({
            auto_update = false,
            run_on_start = false,
            run_on_config = false,
        })

        vim.lsp.config("clangd", {
            settings = {
                cmd = { "clangd", "-Wall" },
            },
        })

        vim.lsp.config("hls", {
            settings = {
                haskell = {
                    formattingProvider = "fourmolu",
                },
            },
        })

        vim.lsp.config("lua_ls", {
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
            vim.lsp.config("powershell_es", {
                settings = {
                    powershell_es = {
                        bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services",
                    },
                },
                -- shell = "powershell.exe",
                -- cmd = { "pwsh", "-NoLogo", "-NoProfile", "-Command", "c:/PSES/Start-EditorServices.ps1 ..." },
            })
        end

        vim.lsp.config("pylsp", {
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

        vim.lsp.config("rust_analyzer", {
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
