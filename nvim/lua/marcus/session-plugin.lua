Config = {
    session_dir = vim.fn.stdpath("data") .. "/sessions",
    session_name_delimiter = "_-_",
    autosave = true,
}

function Get_encoded_cwd()
    return vim.fn.substitute(vim.fn.getcwd(), "/", Config.session_name_delimiter, "g")
end

function Get_session_file()
    return Config.session_dir .. "/" .. Get_encoded_cwd() .. ".vim"
end

function Get_sessions()
    local session_files = vim.fn.readdir(Config.session_dir)
    local sessions = {}
    for _, session_file in ipairs(session_files) do
        local session_file_path = Config.session_dir .. "/" .. session_file
        table.insert(sessions, {
            name = session_file,
            path = session_file_path,
            time = vim.fn.getftime(session_file_path),
            readable_time = vim.fn.strftime("%d-%m-%Y %H:%M", vim.fn.getftime(session_file_path)),
        })
    end
    return sessions
end

vim.keymap.set("n", "<leader>js", function()
    local opts = {
        prompt_title = "Sessions",
        cwd = Config.session_dir,
    }
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local actions = require("telescope.actions")
    local entry_display = require("telescope.pickers.entry_display")
    local make_entry = require("telescope.make_entry")

    local displayer = entry_display.create({
        separator = "   ",
        items = {
            { width = 40 },
            { width = 40 },
        },
    })

    local make_display = function(entry)
        return displayer({ { entry.name }, { entry.readable_time } })
    end

    require("telescope.pickers")
        .new(opts, {
            finder = finders.new_table({
                results = Get_sessions(),
                entry_maker = function(entry)
                    entry.value = entry
                    entry.display = make_display
                    entry.ordinal = entry.name
                    return make_entry.set_default_entry_mt(entry, opts)
                end,
            }),
            previewer = conf.grep_previewer(opts),
            sorter = conf.file_sorter(opts),
            attach_mappings = function(prompt_bufnr, map)
                local load_session = function()
                    local selection = require("telescope.actions.state").get_selected_entry()
                    require("telescope.actions").close(prompt_bufnr)
                    vim.cmd("source " .. selection.value.path)
                end
                actions.select_default:replace(load_session)
                return true
            end,
        })
        :find()
end, {
    noremap = true,
    desc = "Sessions",
})

-- vim.api.nvim_create_autocmd("ExitPre", {
vim.api.nvim_create_autocmd("BufWrite", {
    desc = "Save session on exit",
    group = vim.api.nvim_create_augroup("session-plugin", { clear = true }),
    callback = function()
        if not Config.autosave then
            return
        end

        print(Config.session_dir)
        print(vim.fn.isdirectory(Config.session_dir))
        if vim.fn.isdirectory(Config.session_dir) == 0 then
            print("Directory does not exist")
            vim.fn.mkdir(Config.session_dir, "p")
        end

        vim.cmd("mksession! " .. Get_session_file())
    end,
})

vim.api.nvim_create_user_command("SessionSave", function()
    vim.cmd("mksession! " .. Get_session_file())
end, { nargs = 0 })

vim.api.nvim_create_user_command("SessionLoad", function()
    vim.cmd("source " .. Get_session_file())
end, { nargs = 0 })

vim.api.nvim_create_user_command("SessionDelete", function()
    vim.fn.delete(Get_session_file())
end, { nargs = 0 })

vim.api.nvim_create_user_command("SessionList", function()
    local sessions = Get_sessions()
    print("Sessions:")
    for _, session in ipairs(sessions) do
        print(("%-60s %-20s"):format(session.name, session.readable_time))
    end
end, { nargs = 0 })

vim.api.nvim_create_user_command("SessionLoadLast", function()
    local sessions = Get_sessions()

    local last_session = nil
    local last_time = 0
    for _, session in ipairs(sessions) do
        if session.time > last_time then
            last_time = session.time
            last_session = session
        end
    end

    if last_session then
        print("Loading last session " .. last_session.name)
        vim.cmd("source " .. last_session.path)
    else
        print("No sessions found")
    end
end, { nargs = 0 })
