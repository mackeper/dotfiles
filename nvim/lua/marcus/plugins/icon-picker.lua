return {
    "ziontee113/icon-picker.nvim",
    lazy = true,
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        require("icon-picker").setup({ disable_legacy_commands = true })

        local function opts(desc)
            return { noremap = true, silent = true, desc = desc }
        end
        vim.keymap.set("n", "<Leader>ji", "<cmd>IconPickerNormal<cr>", opts("Icon Picker"))
        -- vim.keymap.set("n", "<Leader>jy", "<cmd>IconPickerYank<cr>", opts) --> Yank the selected icon into register
        -- vim.keymap.set("i", "<C-i>", "<cmd>IconPickerInsert<cr>", opts)
    end,
}
