return {
    -- Hide sensitive information in your files
    enabled = true,
    "laytan/cloak.nvim",
    event = "BufReadPre",
    opts = {},
    keys = {
        { "<leader>zce", ":CloakEnable<CR>", desc = "[Cloak] Enable" },
        { "<leader>zcd", ":CloakDisable<CR>", desc = "[Cloak] Disable" },
        { "<leader>zcp", ":CloakPreview<CR>", desc = "[Cloak] Preview current line" },
    },
}
