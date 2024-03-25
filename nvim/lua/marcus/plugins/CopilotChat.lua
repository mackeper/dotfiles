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
                "<CMD>CopilotChatToggle<CR>",
                desc = "Co[p]ilot: Chat",
            },
            {
                "<leader>pe",
                "ggVG<CMD>CopilotChatExplain<CR>",
                desc = "Co[p]ilot: Explain selection",
            },
            {
                "<leader>pe",
                "<CMD>CopilotChatExplain<CR>",
                desc = "Co[p]ilot: Explain selection",
                mode = "v",
            },
            {
            {
                "<leader>pf",
                "ggVG<CMD>CopilotChatFix<CR>",
                desc = "Co[p]ilot: Fix selection",
            },
            {
                "<leader>pf",
                "<CMD>CopilotChatFix<CR>",
                desc = "Co[p]ilot: Fix selection",
                mode = "v",
            },
            {
                "<leader>po",
                "ggVG<CMD>CopilotChatOptimize<CR>",
                desc = "Co[p]ilot: Optimize selection",
            },
            {
                "<leader>po",
                "<CMD>CopilotChatOptimize<CR>",
                desc = "Co[p]ilot: Optimize selection",
                mode = "v",
            },
            {
                "<leader>pd",
                "ggVG<CMD>CopilotChatDocs<CR>",
                desc = "Co[p]ilot: Docs",
            },
            {
                "<leader>pd",
                "<CMD>CopilotChatDocs<CR>",
                desc = "Co[p]ilot: Docs",
                mode = "v",
            },
            {
                "<leader>pt",
                "ggVG<CMD>CopilotChatTest<CR>",
                desc = "Co[p]ilot: Test",
            },
            {
                "<leader>pt",
                "<CMD>CopilotChatTest<CR>",
                desc = "Co[p]ilot: Test",
                mode = "v",
            },
        },
    },
}
