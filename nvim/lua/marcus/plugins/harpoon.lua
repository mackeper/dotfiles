return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local harpoon = require("harpoon")

        harpoon.setup({})

        vim.keymap.set("n", "<leader>ha", function()
            harpoon:list():add()
        end, { desc = "Add current file to harpoon" })
        vim.keymap.set("n", "<leader>h;", function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end, { desc = "Toggle harpoon" })

        vim.keymap.set("n", "<leader>hh", function()
            harpoon:list():select(1)
        end, { desc = "Select first harpoon item" })
        vim.keymap.set("n", "<leader>hj", function()
            harpoon:list():select(2)
        end, { desc = "Select second harpoon item" })
        vim.keymap.set("n", "<leader>hk", function()
            harpoon:list():select(3)
        end, { desc = "Select third harpoon item" })
        vim.keymap.set("n", "<leader>hl", function()
            harpoon:list():select(4)
        end, { desc = "Select fourth harpoon item" })
        --
        -- -- Toggle previous & next buffers stored within Harpoon list
        -- vim.keymap.set("n", "<C-S-P>", function()
        --     harpoon:list():prev()
        -- end)
        -- vim.keymap.set("n", "<C-S-N>", function()
        --     harpoon:list():next()
        -- end)
    end,
}
