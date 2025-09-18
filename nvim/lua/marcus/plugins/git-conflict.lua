return {
    "akinsho/git-conflict.nvim",
    version = "*",
    opts = {
        {
            default_mappings = false,
            default_commands = true,
            disable_diagnostics = false,
            list_opener = "copen",
            highlights = {
                incoming = "DiffAdd",
                current = "DiffText",
            },
        },
    },
    keys = {
        -- GitConflictChooseOurs — Select the current changes.
        -- GitConflictChooseTheirs — Select the incoming changes.
        -- GitConflictChooseBoth — Select both changes.
        -- GitConflictChooseNone — Select none of the changes.
        -- GitConflictNextConflict — Move to the next conflict.
        -- GitConflictPrevConflict — Move to the previous conflict.
        -- GitConflictListQf — Get all conflict to quickfix
        { "<leader>gco", "<CMD>GitConflictChooseOurs<CR>", mode = "n", desc = "Choose ours" },
        { "<leader>gct", "<CMD>GitConflictChooseTheirs<CR>", mode = "n", desc = "Choose theirs" },
        { "<leader>gcb", "<CMD>GitConflictChooseBoth<CR>", mode = "n", desc = "Choose both" },
        { "<leader>gcN", "<CMD>GitConflictChooseNone<CR>", mode = "n", desc = "Choose none" },
        { "<leader>gcn", "<CMD>GitConflictNextConflict<CR>", mode = "n", desc = "Next conflict" },
        { "<leader>gcp", "<CMD>GitConflictPrevConflict<CR>", mode = "n", desc = "Previous conflict" },
        { "<leader>gcl", "<CMD>GitConflictListQf<CR>", mode = "n", desc = "List conflicts" },
        { "<leader>gcr", "<CMD>GitConflictRefresh<CR>", mode = "n", desc = "Refresh git conflicts" },
    },
    config = true,
}
