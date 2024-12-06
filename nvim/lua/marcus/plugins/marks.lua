return {
    -- view marks in the sign column
    -- Create marks with m{a-zA-Z}
    -- Go to mark with '{a-zA-Z}
    -- Delete mark with dm{a-zA-Z}
    enabled = false,
    "chentoast/marks.nvim",
    lazy = true,
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
}
