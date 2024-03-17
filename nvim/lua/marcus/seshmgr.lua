local config = {
    session_dir = vim.fn.stdpath("data") .. "/sessions",
    session_name_delimiter = "_-_",
    autosave = true,
}

local actions = {
    load = function(session_file_path)
        vim.cmd("source " .. session_file_path)
    end,
    save = function(session_file_name)
        if vim.fn.isdirectory(SessionPlugin.config.session_dir) == 0 then
            vim.fn.mkdir(SessionPlugin.config.session_dir, "p")
        end

        vim.cmd("mksession! " .. session_file_name)
    end,
    delete = function(session_file_path)
        vim.fn.delete(session_file_path)
    end,
}

SessionPlugin = {
    config = config,
    actions = actions,
}

function Get_encoded_cwd()
    return vim.fn.substitute(vim.fn.getcwd(), "/", SessionPlugin.config.session_name_delimiter, "g")
end

function Get_decoded_session_file_path(encoded_cwd)
    return vim.fn.substitute(encoded_cwd, SessionPlugin.config.session_name_delimiter, "/", "g")
end

function Get_session_file()
    return SessionPlugin.config.session_dir .. "/" .. Get_encoded_cwd() .. ".vim"
end

function Get_sessions()
    local session_files = vim.fn.readdir(SessionPlugin.config.session_dir)
    local sessions = {}
    for _, session_file in ipairs(session_files) do
        local session_file_path = SessionPlugin.config.session_dir .. "/" .. session_file
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
        cwd = SessionPlugin.config.session_dir,
        previewer = false,
    }
    local finders = require("telescope.finders")
    local telescope_config = require("telescope.config").values
    local actions = require("telescope.actions")
    local entry_display = require("telescope.pickers.entry_display")
    local make_entry = require("telescope.make_entry")

    local displayer = entry_display.create({
        separator = "   ",
        items = {
            { width = 0.7 },
            { width = 0.25, right_justify = true },
        },
    })

    local make_display = function(entry)
        return displayer({ { Get_decoded_session_file_path(entry.name) }, { entry.readable_time } })
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
            previewer = telescope_config.grep_previewer(opts),
            sorter = telescope_config.file_sorter(opts),
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

vim.api.nvim_create_autocmd("ExitPre", {
    desc = "Save session on exit",
    group = vim.api.nvim_create_augroup("session-plugin", { clear = true }),
    callback = function()
        if not SessionPlugin.config.autosave then
            return
        end

        SessionPlugin.actions.save(Get_session_file())
    end,
})

vim.api.nvim_create_user_command("SessionSave", function()
    SessionPlugin.actions.save(Get_session_file())
end, { nargs = 0 })

vim.api.nvim_create_user_command("SessionLoad", function()
    SessionPlugin.actions.load(Get_session_file())
end, { nargs = 0 })

vim.api.nvim_create_user_command("SessionDelete", function()
    SessionPlugin.actions.delete(Get_session_file())
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
        SessionPlugin.actions.load(last_session.path)
    end
end, { nargs = 0 })
