return {
    enabled = VARIANT == 0,
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
        { "<leader>pP", "<cmd>Copilot panel<CR>", mode = "n", desc = "Panel Copilot" },
    },
    opts = {
        suggestion = {
            enabled = true,
            auto_trigger = true,
        },
        panel = {
            enabled = true,
            auto_refresh = true,
        },
        filetypes = {
            markdown = true,
            help = true,
            yaml = true,
            gitcommit = true,
        },
    },
}
