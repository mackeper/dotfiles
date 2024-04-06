return {
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        branch = "canary",
        dependencies = {
            { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
            { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
        },
        opts = {
            window = {
                layout = "float",
                border = "rounded",
            },
        },
        commands = {
            "CopilotChatToggle",
        },
        keys = {
            {
                "<leader>pc",
                "ggVG<CMD>CopilotChatToggle<CR>",
                desc = "Copilot: Chat",
            },
            {
                "<leader>pc",
                "<CMD>CopilotChatToggle<CR>",
                desc = "Copilot: Chat",
                mode = "v",
            },
            {
                "<leader>pe",
                "ggVG<CMD>CopilotChatExplain<CR>",
                desc = "Copilot: Explain selection",
            },
            {
                "<leader>pe",
                "<CMD>CopilotChatExplain<CR>",
                desc = "Copilot: Explain selection",
                mode = "v",
            },
            {
                "<leader>pf",
                "ggVG<CMD>CopilotChatFix<CR>",
                desc = "Copilot: Fix selection",
            },
            {
                "<leader>pf",
                "<CMD>CopilotChatFix<CR>",
                desc = "Copilot: Fix selection",
                mode = "v",
            },
            {
                "<leader>po",
                "ggVG<CMD>CopilotChatOptimize<CR>",
                desc = "Copilot: Optimize selection",
            },
            {
                "<leader>po",
                "<CMD>CopilotChatOptimize<CR>",
                desc = "Copilot: Optimize selection",
                mode = "v",
            },
            {
                "<leader>pd",
                "ggVG<CMD>CopilotChatDocs<CR>",
                desc = "Copilot: Docs",
            },
            {
                "<leader>pd",
                "<CMD>CopilotChatDocs<CR>",
                desc = "Copilot: Docs",
                mode = "v",
            },
            {
                "<leader>pt",
                "ggVG<CMD>CopilotChatTest<CR>",
                desc = "Copilot: Test",
            },
            {
                "<leader>pt",
                "<CMD>CopilotChatTest<CR>",
                desc = "Copilot: Test",
                mode = "v",
            },
        },
    },
}
