return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile" },
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
        { "folke/neodev.nvim" },
        { "WhoIsSethDaniel/mason-tool-installer.nvim" },
        { "Hoffs/omnisharp-extended-lsp.nvim" },
    },
    config = function()
        local cmp = require("cmp")
        local cmp_lsp = require("cmp_nvim_lsp")
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
                ["<CR>"] = cmp.mapping.confirm({ select = true }),
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
                    return { buffer = event.buf, noremap = true, desc = desc }
                end

                -- Enable completion triggered by <c-x><c-o>
                vim.api.nvim_buf_set_option(event.buf, "omnifunc", "v:lua.vim.lsp.omnifunc")

                vim.keymap.set("n", "gd", builtin.lsp_definitions, opts("Definition"))
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

                if client.name == "omnisharp" then
                    client.server_capabilities.semanticTokensProvider = {
                        full = vim.empty_dict(),
                        legend = {
                            tokenModifiers = { "static" },
                            tokenTypes = {
                                "comment",
                                "excluded_code",
                                "identifier",
                                "keyword",
                                "keyword_control",
                                "number",
                                "operator",
                                "operator_overloaded",
                                "preprocessor_keyword",
                                "string",
                                "whitespace",
                                "text",
                                "static_symbol",
                                "preprocessor_text",
                                "punctuation",
                                "string_verbatim",
                                "string_escape_character",
                                "class_name",
                                "delegate_name",
                                "enum_name",
                                "interface_name",
                                "module_name",
                                "struct_name",
                                "type_parameter_name",
                                "field_name",
                                "enum_member_name",
                                "constant_name",
                                "local_name",
                                "parameter_name",
                                "method_name",
                                "extension_method_name",
                                "property_name",
                                "event_name",
                                "namespace_name",
                                "label_name",
                                "xml_doc_comment_attribute_name",
                                "xml_doc_comment_attribute_quotes",
                                "xml_doc_comment_attribute_value",
                                "xml_doc_comment_cdata_section",
                                "xml_doc_comment_comment",
                                "xml_doc_comment_delimiter",
                                "xml_doc_comment_entity_reference",
                                "xml_doc_comment_name",
                                "xml_doc_comment_processing_instruction",
                                "xml_doc_comment_text",
                                "xml_literal_attribute_name",
                                "xml_literal_attribute_quotes",
                                "xml_literal_attribute_value",
                                "xml_literal_cdata_section",
                                "xml_literal_comment",
                                "xml_literal_delimiter",
                                "xml_literal_embedded_expression",
                                "xml_literal_entity_reference",
                                "xml_literal_name",
                                "xml_literal_processing_instruction",
                                "xml_literal_text",
                                "regex_comment",
                                "regex_character_class",
                                "regex_anchor",
                                "regex_quantifier",
                                "regex_grouping",
                                "regex_alternation",
                                "regex_text",
                                "regex_self_escaped_character",
                                "regex_other_escape",
                            },
                        },
                    }
                end
            end,
        })

        require("mason").setup({})

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
            "pylsp", -- Python
            -- "pyright", -- Python
            "rust_analyzer", -- Rust
            "sqlls", -- SQL
            "svelte", -- Svelte
            "tsserver", -- JavaScript / TypeScript
            "yamlls", -- yaml
        }

        if jit.os == "Windows" then
            table.insert(ensure_installed, "powershell_es")
        end

        local setup_mason_lspconfig = function(lsps)
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

        require("mason-tool-installer").setup({
            ensure_installed = {
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
            },
        })

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

        require("lspconfig").omnisharp.setup({
            cmd = {
                "dotnet",
                vim.fn.stdpath("data") .. "/mason/packages/omnisharp/libexec/OmniSharp.dll",
            },
            sdk_include_prereleases = true,
            enable_editorconfig_support = true,
            enable_roslyn_analyzers = true,
            organize_imports_on_format = true,
            enable_import_completion = true,
            enable_ms_build_load_projects_on_demand = true,
            handlers = {
                ["textDocument/definition"] = require("omnisharp_extended").handler,
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

        -- vim.api.nvim_create_autocmd('BufWritePre', {
        --     desc = 'Format python on write using black',
        --     pattern = '*.py',
        --     group = vim.api.nvim_create_augroup('black_on_save', { clear = true }),
        --     callback = function()
        --         local format_command = { "black", vim.api.nvim_buf_get_name(0) }
        --         vim.fn.jobstart(format_command, {
        --             on_exit = function(_, code, _)
        --                 if code == 0 then
        --                     vim.api.nvim_command('e!')
        --                 end
        --             end,
        --         })
        --     end,
        -- })

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
