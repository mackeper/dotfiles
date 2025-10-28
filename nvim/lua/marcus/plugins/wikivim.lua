return {
    "lervag/wiki.vim",
    lazy = false,
    init = function()
        -- You have to manually create the wiki root folder
        vim.g.wiki_root = "~/git/wiki"
        if jit.os == "Windows" then
            vim.g.wiki_root = "C:/git/wiki"
        end

        vim.g.wiki_select_method = {
            pages = require("wiki.telescope").pages,
            tags = require("wiki.telescope").tags,
            toc = require("wiki.telescope").toc,
            links = require("wiki.telescope").links,
        }

        vim.g.wiki_tag_list = {
            output = "echo",
        }

        vim.g.wiki_journal = {
            name = "98_journal",
            root = "",
            frequency = "daily",
            date_format = {
                daily = "%Y-%m-%d",
                weekly = "%Y_w%V",
                monthly = "%Y_m%m",
            },
        }

        local function JournalTemplate(context)
            local date = os.date("%Y-%m-%d")
            vim.api.nvim_buf_set_lines(0, 0, -1, false, {
                "# " .. date,
                "",
                "## Highlights (Things that went well today)",
                "",
                "- ",
                "",
                "## Lowlights (Challenges or negatives from today)",
                "",
                "- ",
                "",
                "## Improvements (How I could do better tomorrow)",
                "",
                "- ",
                "",
                "## Tasks",
                "",
                "- [ ] ",
                "",
                "## Random thoughts, ideas, or observations",
                "",
                "- ",
            })
        end

        local function MatchJournal(context)
            return context.path_wiki:match("^98_journal/%d%d%d%d%-%d%d%-%d%d%.md$") ~= nil
        end

        vim.g.wiki_templates = {
            {
                match_func = MatchJournal,
                source_func = JournalTemplate,
            },
        }

        vim.api.nvim_create_user_command("WikiCurrent", function()
            if jit.os == "Windows" then
                vim.cmd("edit C:/git/wiki/01_Work/current.md")
            else
                vim.cmd("edit ~/git/wiki/01_Work/current.md")
            end
        end, {})
    end,
    keys = {
        { "<leader>wp", "<cmd>WikiPages<cr>", desc = "Wiki pages" },
        { "<leader>wjj", "<cmd>WikiJournal<cr>", desc = "Wiki journal" },
        { "<leader>wjn", "<cmd>WikiJournalNext<cr>", desc = "Wiki journal next" },
        { "<leader>wjp", "<cmd>WikiJournalPrev<cr>", desc = "Wiki journal previous" },
        { "<leader>wjw", "<cmd>WikiJournalToWeek<cr>", desc = "Wiki journal week" },
        { "<leader>wjm", "<cmd>WikiJournalToMonth<cr>", desc = "Wiki journal month" },
        { "<leader>wt", "<cmd>WikiTags<cr>", desc = "Wiki tags" },
    },
}
