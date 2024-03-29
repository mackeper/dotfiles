return {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    cmd = "Copilot",
    build = ":Copilot auth",
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
