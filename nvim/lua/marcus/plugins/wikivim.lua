return {
    "lervag/wiki.vim",
    lazy = false,
    init = function()
        -- You have to manually create the wiki root folder
        vim.g.wiki_root = '~/git/wiki'
        vim.g.wiki_select_method = {
            pages = require("wiki.telescope").pages,
            tags = require("wiki.telescope").tags,
            toc = require("wiki.telescope").toc,
            links = require("wiki.telescope").links,
        }
        vim.g.wiki_tag_list = {
            output = 'echo',
        }
    end,
    keys = {
        { "<leader>wp",  "<cmd>WikiPages<cr>",          desc = "Wiki pages" },
        { "<leader>wjj", "<cmd>WikiJournal<cr>",        desc = "Wiki journal" },
        { "<leader>wjn", "<cmd>WikiJournalNext<cr>",    desc = "Wiki journal next" },
        { "<leader>wjp", "<cmd>WikiJournalPrev<cr>",    desc = "Wiki journal previous" },
        { "<leader>wjw", "<cmd>WikiJournalToWeek<cr>",  desc = "Wiki journal week" },
        { "<leader>wjm", "<cmd>WikiJournalToMonth<cr>", desc = "Wiki journal month" },
        { "<leader>wt",  "<cmd>WikiTags<cr>",           desc = "Wiki tags" },
    },
}
