return {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    cmd = "Copilot",
    build = ":Copilot auth",
    keys = {
        { "<leader>pD", "<cmd>Copilot disable<CR>", mode = "n", desc = "Disable Copilot" },
        { "<leader>pE", "<cmd>Copilot enable<CR>", mode = "n", desc = "Enable Copilot" },
        { "<leader>pA", "<cmd>Copilot auth<CR>", mode = "n", desc = "Auth Copilot" },
        { "<leader>pS", "<cmd>Copilot suggestion<CR>", mode = "n", desc = "Suggest Copilot" },
        { "<leader>pT", "<cmd>Copilot toggle<CR>", mode = "n", desc = "Toggle Copilot" },
    },
    opts = {
        enabled = true,
        auto_refresh = true,
        suggestion = {
            enabled = true,
            auto_trigger = true,
        },
        panel = {
            enabled = false,
        },
        filetypes = {
            markdown = true,
            help = true,
            yaml = true,
            gitcommit = true,
        },
    },
}
