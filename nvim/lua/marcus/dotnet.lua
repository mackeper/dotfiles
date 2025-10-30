-- cs autocmd
vim.api.nvim_create_autocmd("FileType", {
    pattern = "cs",
    callback = function()
        local function get_current_project()
            local filepath = vim.fn.expand("%:p")
            local dir = vim.fn.fnamemodify(filepath, ":h")
            local search_path = "*.csproj"
            local project = nil

            -- Search for .csproj file in current and parent directories
            for _ = 1, 5, 1 do
                local csproj_files = vim.fn.globpath(dir, search_path, false, true)
                if #csproj_files > 0 then
                    project = csproj_files[1]
                    break
                end
                search_path = "../" .. search_path
            end

            -- expend path to remove ../..
            if project then
                project = vim.fn.fnamemodify(project, ":p")
            end
            return project
        end
        ------
        vim.keymap.set("n", "<leader>ibc", function()
            vim.cmd("!dotnet build " .. (get_current_project() or ""))
        end, { desc = "Dotnet: Build current project" })

        vim.keymap.set("n", "<leader>ibc", function()
            vim.cmd("!dotnet build " .. (get_current_project() or ""))
        end, { desc = "Dotnet: Build current project" })
        vim.keymap.set("n", "<leader>ip", function()
            vim.notify("Current project: " .. (get_current_project() or "Not found"), vim.log.levels.INFO)
        end, { desc = "Dotnet: Show current project" })
    end,
})
