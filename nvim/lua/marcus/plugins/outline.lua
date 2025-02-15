return {
    "hedyhli/outline.nvim",
    cmd = { "Outline", "OutlineOpen" },
    keys = {
        {
            "<leader>eo",
            function()
                require("outline").toggle_outline({ focus_outline = false })
            end,
            desc = "Toggle outline",
        },
    },
    opts = {
        outline_window = {
            width = 15,
            auto_close = false,
            focus_on_open = true,
        },
        outline_items = {
            show_symbol_details = true,
        },
    },
    config = function(_, opts)
        require("outline").setup(opts)

        -- Auto close
        vim.api.nvim_create_autocmd("BufEnter", {
            nested = true,
            callback = function()
                if #vim.api.nvim_list_wins() == 1 and require("outline").is_focus_in_outline() then
                    vim.cmd("quit")
                end
            end,
        })
    end,
}
