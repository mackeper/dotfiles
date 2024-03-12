return {
    "rmagatti/auto-session",
    enabled = false,
    config = function()
        ---@diagnostic disable-next-line: missing-fields
        require("auto-session").setup({
            log_level = vim.log.levels.ERROR,
            auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/", "~/git/", "~/documents/" },
            auto_session_use_git_branch = false,
            auto_session_enable_last_session = true,

            session_lens = {
                buftypes_to_ignore = {},
                load_on_setup = true,
                theme_conf = { border = true },
                previewer = false,
            },
        })

        vim.keymap.set("n", "<leader>js", "<CMD>Autosession search<CR>", {
            noremap = true,
            desc = "Sessions",
        })
    end,
}
