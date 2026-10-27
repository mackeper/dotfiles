-- Marcus try on a minimal init.lua
--
-- Philosophy:
--   - Use defaults for as much as possible.
--   - Try to reduce dependencies on plugins.
--   - One file.
--
-- TODO:
--  - mini.git?
--  - Replace mini.sessions with native
--
-- Tips:
--  - Use C-a + C-q in MiniPick to send all to qf list.
--  - LSP: C-w + d open diagnostic float
-- ================================================
--                   Options
-- ================================================

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- UI
-- [bufnr] filepath [flags] | | [ft] (row,col-Vcol) tLines percentage%
vim.opt.statusline = "[%n] %<%f %h%w%m%r%q%=%=%y %-14.(%l,%c%V%) %L %P"
vim.opt.list = true -- Show invisible characters
vim.opt.listchars = { tab = " ", trail = "·", nbsp = "␣" }
vim.opt.signcolumn = "yes" -- Always show signcolumn.
vim.opt.cursorline = true -- Highlight current line

local function apply_theme(theme)
    vim.g.theme_mode = theme
    if theme == "light" then
        vim.o.background = "light"
        vim.cmd.colorscheme("delek")
    else
        vim.o.background = "dark"
        vim.cmd.colorscheme("catppuccin")
        vim.api.nvim_set_hl(0, "Normal", { bg = "none" }) -- Transparent background
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
        local heading_colors = {
            { "#f38ba8", "#493446" },
            { "#fab387", "#4a3c40" },
            { "#f9e2af", "#4a4548" },
            { "#a6e3a1", "#394545" },
            { "#74c7ec", "#2f4054" },
            { "#b4befe", "#3c3e58" },
        }
        for level, c in ipairs(heading_colors) do
            vim.api.nvim_set_hl(0, "@markup.heading." .. level .. ".markdown", { fg = c[1], bg = c[2], bold = true })
        end
    end
end

local function toggle_light_mode()
    apply_theme(vim.g.theme_mode == "light" and "dark" or "light")
end

apply_theme("dark")

-- Editing
vim.opt.clipboard = "unnamedplus" -- System clipboard
vim.opt.wrap = false -- Disable wrap lines
vim.opt.scrolloff = 8 -- Keep X lines from top/bottom
vim.opt.sidescrolloff = 8 -- Keep X characters from the side
vim.opt.undofile = true -- Persistent undo
vim.opt.spelllang = { "en_us", "sv" }
local work_spellfile = "C:/git/dotfiles-work/nvim/en.utf-8.add"
if vim.uv.fs_stat(work_spellfile) then
    vim.opt.spellfile = { vim.fn.stdpath("config") .. "/spell/en.utf-8.add", work_spellfile }
end
vim.opt.fixendofline = false -- Don't automatically add newline at end of file

-- Search
vim.opt.ignorecase = true -- Ignore case in search patterns
vim.opt.smartcase = true -- Override ignorecase if search pattern contains uppercase letters
vim.opt.inccommand = "split" -- Show search substitution in split

vim.opt.grepprg = "rg --vimgrep --smart-case"

-- Indentation
vim.opt.tabstop = 4 -- Number of spaces that a <Tab> counts for
vim.opt.softtabstop = 4 -- Number of spaces that a <Tab> counts for
vim.opt.shiftwidth = 4 -- Number of spaces to use for each step of (auto)indent
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.smartindent = true -- Smart autoindenting when starting a new line

-- Command
vim.opt.wildmode = "longest:full,full"

-- Completion (<C-x><C-o> omnifunc, <C-x><C-n> keywords, <C-x><C-f> file paths, <C-x><C-u> user defined)
vim.opt.autocomplete = true -- Enable autocompletion
vim.opt.complete:append("o") -- Default sources plus omnifunc
vim.opt.completeopt = "fuzzy,noinsert,noselect,menu,menuone" -- how completion menu behaves
vim.opt.pumheight = 10 -- Max height of the completion menu

-- ================================================
--                   Keymaps
-- ================================================
local function opts(desc, extra)
    return vim.tbl_extend("force", { silent = true, desc = desc }, extra or {})
end
local map = vim.keymap.set

-- Explorer
map("n", "<leader>ee", "<cmd>Explore<cr>", opts("Open file explorer"))
map("n", "<leader>ec", "<cmd>edit $MYVIMRC<cr>", opts("Edit init.lua"))
map("n", "<leader>eu", "<cmd>lua require('undotree').open()<cr>", opts("Toggle undotree"))
map("n", "<leader>er", "<cmd>lua MiniSessions.restart()<CR>", opts("Restart nvim"))

-- Editing
map(
    "n",
    "<leader>rw",
    [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    opts("Substitute word under cursor", { silent = false })
)

-- Search
map("n", "<Esc>", "<cmd>nohlsearch<CR>", opts("Clear search highlight"))
map("n", "<C-t>", toggle_light_mode, opts("Toggle light theme"))
map("n", "<leader>es", function()
    local path = vim.api.nvim_buf_get_name(0)
    MiniFiles.open(vim.uv.fs_stat(path) and path or nil, false)
end, opts("Open mini.files at current file"))
map("n", "<C-p>", "<cmd>Pick files<cr>", opts("Find files"))
map("n", "<C-f>", "<cmd>Pick grep_live<cr>", opts("Live grep"))
map("n", "<C-b>", "<cmd>Pick buffers<cr>", opts("Find buffers"))
map("n", "<leader>fg", "<cmd>Pick git_hunks<cr>", opts("Search git hunks"))
map("n", "<M-r>", "<cmd>Pick visit_paths<cr>", opts("Recent visits"))
map("n", "<leader>fh", "<cmd>Pick help<cr>", opts("Search help"))
map("n", "<leader>fw", "<cmd>Pick grep pattern='<cword>'<cr>", opts("Grep word"))
map(
    "n",
    "<leader>fW",
    "<cmd>Pick grep pattern=[[(([^n][^e][^w])\\s+<cword>\\s*\\\\\\(|class.*<cword>\\s|<cword>\\s\\{)]]<cr>",
    opts("Grep C function")
)
map("n", "<leader>ff", "<cmd>Pick resume<cr>", opts("Resume last picker"))

-- Used for wiki
local function pick_tags_then_grep()
    local tags = vim.fn.systemlist({ "rg", "-oPIN", [[(?<!\S)#\w+]], "." })
    require("mini.pick").start({
        source = {
            items = vim.fn.uniq(vim.fn.sort(tags)),
            name = "Tags",
            choose = function(tag)
                require("mini.pick").builtin.grep({ pattern = tag })
            end,
        },
    })
end
map("n", "<leader>ft", pick_tags_then_grep, opts("Pick tag → grep"))

-- C# dotnet test output to file via $PROFILE.
local function pick_failed_tests()
    local test_output_path = vim.fs.joinpath(vim.fn.stdpath("data"), "test-output.log")
    if not vim.uv.fs_stat(test_output_path) then
        vim.notify("Test output not found. Run testall first.", vim.log.levels.WARN)
        return
    end

    local read_succeeded, lines = pcall(vim.fn.readfile, test_output_path)
    if not read_succeeded then
        vim.notify("Could not read test output: " .. test_output_path, vim.log.levels.ERROR)
        return
    end

    local failed_tests = {}
    local added = {}
    for _, line in ipairs(lines) do
        local test_name = line:match("^%s*[Ff][Aa][Ii][Ll][Ee][Dd]%s+(.+)%s+%([^)]*%)%s*$")
        if test_name and not added[test_name] then
            local name_without_arguments = test_name:gsub("%b()$", "")
            local search_term = name_without_arguments:match("([%w_]+)$") or name_without_arguments
            table.insert(failed_tests, {
                text = test_name,
                search_term = search_term,
            })
            added[test_name] = true
        end
    end

    if #failed_tests == 0 then
        vim.notify("No failed tests found in the latest testall output", vim.log.levels.INFO)
        return
    end

    require("mini.pick").start({
        source = {
            items = failed_tests,
            name = "Failed tests",
            choose = function(test)
                require("mini.pick").builtin.grep({ pattern = test.search_term })
            end,
        },
    })
end
map("n", "<leader>fT", pick_failed_tests, opts("Find failed test"))

local function pick_recent_files()
    local root = vim.fs.root(vim.fn.getcwd(), ".git")
    local files = root
        and vim.fn.systemlist({ "git", "-C", root, "diff", "--name-only", "--merge-base", "origin/HEAD" })
    if not root or vim.v.shell_error ~= 0 then
        vim.notify("Recent branch files requires a Git repository with origin/HEAD", vim.log.levels.ERROR)
        return
    end
    vim.list_extend(files, vim.fn.systemlist({ "git", "-C", root, "ls-files", "--others", "--exclude-standard" }))

    local items = {}
    for _, file in ipairs(files) do
        local path = vim.fs.joinpath(root, file)
        local stat = vim.uv.fs_stat(path)
        if stat then
            local text = vim.fs.basename(vim.fs.dirname(path)) .. "/" .. vim.fs.basename(path)
            table.insert(items, { path = path, text = text, mtime = stat.mtime.sec })
        end
    end
    table.sort(items, function(a, b)
        return a.mtime > b.mtime
    end)

    require("mini.pick").start({ source = { items = items, name = "Recent branch files" } })
end
map("n", "<leader>fr", pick_recent_files, opts("Recent modified files"))

-- AI
map("i", "<M-l>", vim.lsp.inline_completion.get, opts("Accept Copilot suggestion"))
map("i", "<M-]>", vim.lsp.inline_completion.select, opts("Next Copilot suggestion"))

local terminals = {}

local function terminal_running(buf)
    return buf and vim.api.nvim_buf_is_valid(buf) and vim.fn.jobwait({ vim.bo[buf].channel }, 0)[1] == -1
end

local function terminal_open(cmd)
    local buf = terminals[cmd]
    if terminal_running(buf) then
        vim.cmd.buffer(buf)
        return vim.bo[buf].channel, false
    end
    vim.cmd("terminal " .. cmd)
    terminals[cmd] = vim.api.nvim_get_current_buf()
    return vim.bo.channel, true
end

local function terminal_toggle(cmd)
    return function()
        if vim.api.nvim_get_current_buf() == terminals[cmd] and terminal_running(terminals[cmd]) then
            return vim.cmd(vim.fn.buflisted(vim.fn.bufnr("#")) == 1 and "buffer #" or "bprevious")
        end
        terminal_open(cmd)
        vim.cmd.startinsert()
    end
end

local function copilot_open()
    return terminal_open("copilot --continue")
end

map({ "n", "t" }, "<C-l>", terminal_toggle("copilot --continue"), opts("Toggle Copilot CLI"))

-- chansend submits at every newline, so send a one-line @file reference instead of the text.
map({ "n", "x" }, "<leader>ia", function()
    local a, b = vim.fn.line("v"), vim.fn.line(".")
    local ref = ("@%s lines %d-%d "):format(vim.fs.normalize(vim.fn.expand("%:.")), math.min(a, b), math.max(a, b))
    vim.cmd("normal! \27")
    local chan, started = copilot_open()
    vim.defer_fn(function()
        vim.fn.chansend(chan, ref)
    end, started and 3000 or 0)
    vim.cmd("startinsert")
end, opts("Send @file lines to Copilot CLI"))

map("x", "<leader>ip", function()
    local lines = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = vim.fn.mode() })
    vim.cmd("normal! \27")
    local _, started = copilot_open()
    vim.defer_fn(function()
        vim.api.nvim_put(lines, "c", false, true)
    end, started and 3000 or 0)
    vim.cmd("startinsert")
end, opts("Paste selection into Copilot CLI"))

-- Git
map("n", "<leader>gd", "<cmd>lua MiniDiff.toggle_overlay()<cr>", opts("Toggle git diff overlay"))
map("n", "<leader>gc", "<cmd>Pick git_commits<cr>", opts("Git commits"))

-- stylua: ignore start
-- Git blame line, run again to copy hash
local last_time, last_line = 0, 0
map("n", "<leader>gb", function()
    local now = vim.uv.now()
    local line = vim.fn.line(".")
    local path = vim.uv.fs_realpath(vim.api.nvim_buf_get_name(0)) or vim.api.nvim_buf_get_name(0)
    local o = vim.fn.systemlist({
        "git",
        "-C",
        vim.fs.dirname(path),
        "blame",
        "--line-porcelain",
        "-L",
        vim.fn.line(".") .. ",+1",
        "--",
        path,
    })
    if vim.v.shell_error ~= 0 then
        return vim.notify(o[1] or "git blame failed", vim.log.levels.WARN)
    end
    local h = o[1]:match("^(%w+)"):sub(1, 7)
    local a = vim.iter(o):find(function(x) return x:match("^author ") end):sub(8)
    local t = vim.iter(o):find(function(x) return x:match("^author%-time ") end):sub(13)
    if now - last_time < 5000 and line == last_line then
        vim.fn.setreg("+", h)
        vim.notify("Copied hash: " .. h, vim.log.levels.INFO)
    else
        print(h, a, os.date("%F", tonumber(t)))
    end
    last_time, last_line = now, line
end, opts("Git blame"))
-- stylua: ignore end

-- Navigation
map("n", "n", "nzzzv", opts("Move to next match"))
map("n", "N", "Nzzzv", opts("Move to previous match"))
map("n", "<C-d>", "<C-d>zz", opts("Scroll down"))
map("n", "<C-u>", "<C-u>zz", opts("Scroll up"))

map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", opts("Down (screen line)", { expr = true }))
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", opts("Up (screen line)", { expr = true }))
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", opts("Down (screen line)", { expr = true }))
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", opts("Up (screen line)", { expr = true }))
map("i", "<Down>", function()
    return vim.fn.pumvisible() == 1 and "<Down>" or "<C-o>gj"
end, opts("Down (screen line)", { expr = true }))
map("i", "<Up>", function()
    return vim.fn.pumvisible() == 1 and "<Up>" or "<C-o>gk"
end, opts("Up (screen line)", { expr = true }))
map({ "n", "x" }, "$", "&wrap ? 'g$' : '$'", opts("End of line (screen line when wrapped)", { expr = true }))
map("n", "A", "&wrap ? 'g$a' : 'A'", opts("Append at end of line (screen line when wrapped)", { expr = true }))

map("n", "<C-Left>", "<C-w>h", opts("Window left"))
map("n", "<C-Down>", "<C-w>j", opts("Window down"))
map("n", "<C-Up>", "<C-w>k", opts("Window up"))
map("n", "<C-Right>", "<C-w>l", opts("Window right"))

map("n", "<tab>", ":bnext<CR>", opts("Next buffer"))
map("n", "<S-tab>", ":bprevious<CR>", opts("Previous buffer"))

vim.api.nvim_create_autocmd("FileType", {
    pattern = "cs",
    callback = function(e)
        local pattern = [[^\s*\(public\|private\|protected\|class\|interface\|struct\|enum\)]]
        map("n", "[[", function()
            vim.fn.search(pattern, "bs")
        end, opts("Previous C# declaration", { buffer = e.buf }))
        map("n", "]]", function()
            vim.fn.search(pattern, "s")
        end, opts("Next C# declaration", { buffer = e.buf }))
    end,
})

-- Buffers
map("n", "<leader>bd", "<cmd>bdelete<CR>", opts("Close buffer"))

-- Terminal
map("n", "<C-space>", "<cmd>terminal<CR>", opts("Open terminal"))
map("t", "<Esc><Esc>", "<C-\\><C-n>", opts("Exit terminal mode"))
map("t", "<C-Left>", "<C-\\><C-O><C-w>h<esc>", opts("Window left"))
map("t", "<C-Down>", "<C-\\><C-O><C-w>j<esc>", opts("Window down"))
map("t", "<C-Up>", "<C-\\><C-O><C-w>k<esc>", opts("Window up"))
map("t", "<C-Right>", "<C-\\><C-O><C-w>l<esc>", opts("Window right"))

map({ "n", "t" }, "<C-s>", terminal_toggle(""), opts("Toggle terminal"))
map({ "n", "t" }, "<C-g>", terminal_toggle("lazygit"), opts("Toggle lazygit"))

local METHOD_MODIFIERS =
    { public = true, private = true, protected = true, internal = true, static = true, async = true }

-- "public async Task<int> Foo(" -> "Foo". Anything not starting with a modifier is not a declaration.
local function declared_method_on_line(line)
    if not METHOD_MODIFIERS[line:match("^%s*(%a+)%s")] then
        return nil
    end
    return line:match("^%s*[%w_%s<>,%.%?%[%]]*%f[%w_]([%w_]+)%s*%(")
end

-- Nearest enclosing class and method, searching upwards from the cursor. Each line is joined with
-- the one below it so that signatures wrapped after the return type are still recognised.
local function find_test_at_cursor()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local method_name
    for i = vim.api.nvim_win_get_cursor(0)[1], 1, -1 do
        method_name = method_name or declared_method_on_line(lines[i] .. " " .. (lines[i + 1] or ""))
        local class_name = lines[i]:match("class%s+([%w_]+)")
        if class_name then
            return class_name, method_name
        end
    end
    return nil, method_name
end

local function uses_testing_platform(dir)
    local global_json = vim.fs.find("global.json", { path = dir, upward = true, type = "file" })[1]
    if not global_json then
        return false
    end
    local ok, config = pcall(vim.json.decode, table.concat(vim.fn.readfile(global_json), "\n"))
    return ok
        and type(config) == "table"
        and type(config.test) == "table"
        and config.test.runner == "Microsoft.Testing.Platform"
end

local function run_dotnet_test(filter)
    local source_dir = vim.fn.expand("%:p:h")
    local csproj = vim.fs.find(function(name)
        return name:match("%.csproj$")
    end, { path = source_dir, upward = true, type = "file" })[1]
    if not csproj then
        return vim.notify("No .csproj found for " .. source_dir, vim.log.levels.ERROR)
    end

    local buf = vim.api.nvim_create_buf(false, true)
    vim.bo[buf].bufhidden = "wipe"
    local width = math.floor(vim.o.columns * 0.85)
    local height = math.floor(vim.o.lines * 0.85)
    vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = math.floor((vim.o.lines - height) / 2),
        col = math.floor((vim.o.columns - width) / 2),
        style = "minimal",
        border = "rounded",
        title = " " .. filter .. " ",
        title_pos = "center",
    })

    local test_filter = "FullyQualifiedName~" .. filter
    local command = { "dotnet", "test", csproj, "--filter", test_filter }
    -- --output and --no-progress are MTP-only; VSTest mode rejects them with MSB1001.
    if uses_testing_platform(source_dir) then
        vim.list_extend(command, { "--output", "detailed", "--no-progress" })
    else
        vim.list_extend(command, { "--logger", "console;verbosity=detailed" })
    end
    vim.fn.jobstart(command, { cwd = vim.fs.dirname(csproj), term = true })
    vim.cmd("startinsert")
    map("n", "q", "<cmd>close<CR>", opts("Close test window", { buffer = buf }))
    map("t", "<Esc><Esc>", "<C-\\><C-n><cmd>close<CR>", opts("Close test window", { buffer = buf }))
end

map("n", "<leader>tt", function()
    local class_name, method_name = find_test_at_cursor()
    if not method_name then
        return vim.notify("No test method found above cursor", vim.log.levels.WARN)
    end
    run_dotnet_test(class_name and class_name .. "." .. method_name or method_name)
end, opts("Run .NET test at cursor"))

map("n", "<leader>tc", function()
    local class_name = find_test_at_cursor()
    if not class_name then
        return vim.notify("No test class found above cursor", vim.log.levels.WARN)
    end
    run_dotnet_test(class_name)
end, opts("Run .NET test class at cursor"))

-- Copying
map("n", "<leader>cp", [[:let @+=expand("%:p")<CR>]], opts("Copy file path to clipboard"))
map("n", "<leader>cn", [[:let @+=expand("%:t")<CR>]], opts("Copy file name to clipboard"))
map("n", "<leader>cd", [[:let @+=expand("%:h")<CR>]], opts("Copy file directory to clipboard"))

-- Pasting
map("n", "<leader>p", function()
    local text = vim.trim(vim.fn.getreg("+")):gsub("[ :]", "_")
    vim.api.nvim_put({ text }, "c", true, true)
end, opts("Paste replacing spaces with _"))

-- LSP
map("n", "grd", vim.lsp.buf.definition, opts("vim.lsp.buf.definition()"))
map("n", "grf", vim.lsp.buf.format, opts("vim.lsp.buf.format()"))
map("n", "grs", vim.lsp.buf.signature_help, opts("vim.lsp.buf.signature_help()"))

-- Spell check
map("n", "<leader>zs", "<CMD>setlocal spell!<CR>", opts("Toggle spell check"))

-- Sessions
map("n", "<leader>sl", "<CMD>lua MiniSessions.read(MiniSessions.get_latest())<CR>", opts("Load last session"))
map("n", "<leader>ss", "<CMD>lua MiniSessions.select()<CR>", opts("Select session"))

-- Quickfix list
map("n", "<M-j>", "<cmd>cnext<CR>", opts("Next quickfix entry"))
map("n", "<M-k>", "<cmd>cprev<CR>", opts("Previous quickfix entry"))
map("n", "<leader>qq", "<cmd>copen<CR>", opts("Open quickfix"))
vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    callback = function(e)
        local loclist = vim.fn.win_gettype() == "loclist"
        map("n", "q", loclist and "<cmd>lclose<CR>" or "<cmd>cclose<CR>", opts("Close list", { buffer = e.buf }))
        map("n", "dd", function()
            local row = vim.fn.line(".")
            local items = loclist and vim.fn.getloclist(0) or vim.fn.getqflist()
            table.remove(items, row)
            if loclist then
                vim.fn.setloclist(0, items, "r")
            else
                vim.fn.setqflist(items, "r")
            end
            local new_row = math.min(row, #items)
            if new_row > 0 then
                vim.schedule(function()
                    pcall(vim.api.nvim_win_set_cursor, 0, { new_row, 0 })
                end)
            end
        end, opts("Delete list entry", { buffer = e.buf }))
    end,
})

-- wiki
local wiki = vim.fn.expand("~/git/wiki")
local work_wiki = vim.env.WORK_WIKI
if vim.fn.has("win32") == 1 then
    wiki = "C:\\git\\wiki"
end
map("n", "<leader>ww", "<cmd>edit " .. wiki .. "/index.md<CR>:lcd %:p:h<CR>", opts("Open wiki index"))
map("n", "<leader>wj", function()
    vim.cmd.edit(vim.fn.fnameescape(wiki .. "/98_Journal/" .. os.date("%Y-%m-%d") .. ".md"))
    vim.cmd("lcd %:p:h")
end, opts("Open wiki journal"))
if work_wiki then
    map("n", "<leader>wc", function()
        vim.cmd.edit(vim.fn.fnameescape(work_wiki .. "/current.md"))
        vim.cmd("lcd %:p:h")
    end, opts("Open wiki current work"))
end
map("n", "<M-t>", function()
    vim.cmd([[keeppatterns s/\v[-*] \[\zs[ x]\ze\]/\=submatch(0) ==# 'x' ? ' ' : 'x'/e]])
end, opts("Toggle checkbox"))

-- Markdown preview with pandoc (no extra dependencies)
local pandoc_theme_header = [[
<style>
:root { --bg: #1e1e1e; --fg: #d4d4d4; --link: #4ea1ff; --mono: #2d2d2d; }
:root[data-theme=light] { --bg: #ffffff; --fg: #1f2328; --link: #0969da; --mono: #eff1f3; }
#theme-toggle {
  position: fixed; top: 12px; right: 12px; padding: 4px 10px; cursor: pointer;
  background: var(--mono); color: var(--fg); border: 1px solid var(--fg); border-radius: 6px;
}
:root[data-theme=light] div.sourceCode { color: #1f1c1b; background-color: #f6f8fa; }
:root[data-theme=light] code span { color: #1f1c1b; }
:root[data-theme=light] code span.al { color: #bf0303; background-color: #f7e6e6; font-weight: bold; }
:root[data-theme=light] code span.an { color: #ca60ca; }
:root[data-theme=light] code span.at { color: #0057ae; }
:root[data-theme=light] code span.bn { color: #b08000; }
:root[data-theme=light] code span.bu { color: #644a9b; font-weight: bold; }
:root[data-theme=light] code span.cf { color: #1f1c1b; font-weight: bold; }
:root[data-theme=light] code span.ch { color: #924c9d; }
:root[data-theme=light] code span.cn { color: #aa5500; font-weight: normal; }
:root[data-theme=light] code span.co { color: #898887; }
:root[data-theme=light] code span.cv { color: #0095ff; }
:root[data-theme=light] code span.do { color: #607880; }
:root[data-theme=light] code span.dt { color: #0057ae; }
:root[data-theme=light] code span.dv { color: #b08000; }
:root[data-theme=light] code span.er { color: #bf0303; }
:root[data-theme=light] code span.ex { color: #0095ff; }
:root[data-theme=light] code span.fl { color: #b08000; }
:root[data-theme=light] code span.fu { color: #644a9b; }
:root[data-theme=light] code span.im { color: #ff5500; }
:root[data-theme=light] code span.in { color: #b08000; }
:root[data-theme=light] code span.kw { color: #1f1c1b; }
:root[data-theme=light] code span.op { color: #1f1c1b; }
:root[data-theme=light] code span.ot { color: #006e28; }
:root[data-theme=light] code span.pp { color: #006e28; }
:root[data-theme=light] code span.re { color: #0057ae; background-color: #e0e9f8; }
:root[data-theme=light] code span.sc { color: #3daee9; }
:root[data-theme=light] code span.ss { color: #ff5500; }
:root[data-theme=light] code span.st { color: #bf0303; }
:root[data-theme=light] code span.va { color: #0057ae; }
:root[data-theme=light] code span.vs { color: #bf0303; }
:root[data-theme=light] code span.wa { color: #bf0303; }
</style>
<script>
document.documentElement.dataset.theme = localStorage.getItem("theme")
  || (matchMedia("(prefers-color-scheme: light)").matches ? "light" : "dark");
</script>
<style>pre.mermaid { background: transparent; text-align: center; }</style>
<script type="module">
const nodes = [...document.querySelectorAll("pre.mermaid")];
if (nodes.length) {
  const { default: mermaid } = await import("https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs");
  nodes.forEach((n) => (n.dataset.src = n.textContent));
  window.renderMermaid = async () => {
    const dark = document.documentElement.dataset.theme !== "light";
    mermaid.initialize({ startOnLoad: false, theme: dark ? "dark" : "default" });
    nodes.forEach((n) => {
      n.removeAttribute("data-processed");
      n.textContent = n.dataset.src;
    });
    await mermaid.run({ nodes });
  };
  renderMermaid();
}
</script>]]

local pandoc_theme_button = [[
<button id="theme-toggle" title="Toggle dark/light" onclick="
  const t = document.documentElement.dataset.theme === 'light' ? 'dark' : 'light';
  document.documentElement.dataset.theme = t;
  localStorage.setItem('theme', t);
  window.renderMermaid?.();">&#9680;</button>]]

map("n", "<leader>mp", function()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local tmp = vim.fn.tempname() .. ".html"
    local header = vim.fn.tempname()
    local button = vim.fn.tempname()
    vim.fn.writefile(vim.split(pandoc_theme_header, "\n"), header)
    vim.fn.writefile(vim.split(pandoc_theme_button, "\n"), button)

    local title = "pagetitle=" .. vim.fn.expand("%:t")
    local cmd = { "pandoc", "-f", "markdown", "-t", "html", "-s", "--metadata", title, "--highlight-style=breezedark" }
    vim.list_extend(cmd, { "-H", header, "-B", button })
    local vars = {
        "backgroundcolor=var(--bg)",
        "fontcolor=var(--fg)",
        "linkcolor=var(--link)",
        "monobackgroundcolor=var(--mono)",
        "mainfont=Segoe UI, sans-serif",
        "monofont=Cascadia Code, Consolas, monospace",
        "fontsize=16px",
        "maxwidth=72em",
        "margin-left=24px",
        "margin-right=24px",
        "margin-top=24px",
        "margin-bottom=24px",
    }
    for _, var in ipairs(vars) do
        vim.list_extend(cmd, { "-V", var })
    end
    vim.list_extend(cmd, { "-o", tmp })

    vim.system(cmd, { stdin = table.concat(lines, "\n") }, function(obj)
        if obj.code ~= 0 then
            vim.schedule(function()
                vim.notify("pandoc failed: " .. (obj.stderr or ""), vim.log.levels.ERROR)
            end)
            return
        end
        vim.schedule(function()
            vim.ui.open(tmp)
        end)
    end)
end, opts("Preview markdown with pandoc"))
map("n", "<leader>me", function()
    local editing = vim.wo.concealcursor ~= ""
    vim.wo.concealcursor = editing and "" or "nc"
    vim.wo.conceallevel = editing and 0 or 2
    vim.wo.spell = editing
end, opts("Markdown edit (toggle conceal and spell)"))

-- Harpoon -ish
map("n", "<leader>a", "<cmd>$argadd %<cr><cmd>argdedup<cr>", opts("Harpoon add current file"))
map("n", "<leader>h", "<cmd>silent! 1argument<cr>", opts("Harpoon 1"))
map("n", "<leader>j", "<cmd>silent! 2argument<cr>", opts("Harpoon 2"))
map("n", "<leader>k", "<cmd>silent! 3argument<cr>", opts("Harpoon 3"))
map("n", "<leader>l", "<cmd>silent! 4argument<cr>", opts("Harpoon 4"))
map("n", "<leader>;", "<cmd>silent! 5argument<cr>", opts("Harpoon 5"))

-- ================================================
--                   Plugins
-- ================================================
vim.pack.add({
    "https://github.com/nvim-mini/mini.nvim", -- Collection of plugins
    "https://github.com/neovim/nvim-lspconfig", -- Default LSP configurations
    "https://github.com/mason-org/mason.nvim", -- LSP/DAP/Linter/Formatter installer
    "https://github.com/mason-org/mason-lspconfig.nvim", -- Auto enable plugins installed by mason.nvim
    "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim", -- Auto install tools installed by mason.nvim
})
vim.cmd.packadd("cfilter") -- filder quickfix list.
vim.cmd.packadd("nvim.undotree") -- UI to navigate undo tree.
vim.cmd.packadd("nvim.difftool") -- :DiffTool, and `nvim -d a b` opens in the difftool layout

vim.api.nvim_create_user_command("VimPackList", function()
    for _, value in ipairs(vim.pack.get()) do
        print(value.spec.name)
    end
end, { desc = "List plugins" })

-- Mini - A collection of plugins
-- Show long paths as ./<csproj dir>/./<file>. Display only, matching uses full path.
local pick_proj_cache = {}
local function shorten_pick_path(path, cwd)
    if #path <= 60 then
        return path
    end
    local abs = vim.fs.normalize(vim.fn.fnamemodify(vim.fs.joinpath(cwd, path), ":p"))
    if vim.fn.filereadable(abs) == 0 then
        abs = vim.fs.normalize(vim.fn.fnamemodify(path, ":p"))
        if vim.fn.filereadable(abs) == 0 then
            return path
        end
    end
    local dir = vim.fs.dirname(abs)
    if pick_proj_cache[dir] == nil then
        pick_proj_cache[dir] = vim.fs.root(dir, function(name)
            return name:match("%.csproj$") ~= nil
        end) or false
    end
    local proj = pick_proj_cache[dir]
    if not proj then
        return path
    end
    local sep = proj == dir and "/" or "/./"
    return "./" .. vim.fs.basename(proj) .. sep .. vim.fs.basename(abs)
end

local function pick_show(buf_id, items, query)
    local picker_opts = MiniPick.get_picker_opts() or {}
    local cwd = (picker_opts.source and picker_opts.source.cwd) or vim.fn.getcwd()
    local display = vim.tbl_map(function(item)
        if type(item) ~= "string" then
            return item
        end
        -- Keep real path so icon lookup still works
        local path, rest = item:match("^([^%z]+)(%z.*)$")
        path, rest = path or item, rest or ""
        local short = shorten_pick_path(path, cwd)
        if short == path then
            return item
        end
        local real = vim.fn.isabsolutepath(path) == 1 and path or vim.fs.joinpath(cwd, path)
        return { text = short .. rest, path = real }
    end, items)
    MiniPick.default_show(buf_id, display, query, { show_icons = true })
end

require("mini.pick").setup({
    source = { show = pick_show },
    window = { config = { width = 100, height = 30 } },
    mappings = {
        choose_marked = "<C-q>", -- send marked to quickfix
    },
}) -- Picker, e.g. :Pick files, :Pick grep_live
require("mini.files").setup({ -- File explorer. :MiniFiles.open() g? to show info
    windows = {
        preview = true,
        width_preview = 80,
    },
    mappings = {
        go_in_plus = "<CR>",
        go_out = "-",
    },
})
if vim.g.no_fancy_ui then
    -- In difftool/mergetool mode nvim is launched with directory arguments.
    -- mini.files hijacks directory buffers with a floating window, which makes
    -- nvim.difftool's :only call fail with E5601. Drop that hijack autocmd.
    pcall(vim.api.nvim_clear_autocmds, { group = "MiniFiles", event = "BufEnter" })
end
require("mini.visits").setup({}) -- Track file visits and jump to them. E.g. :Visit
require("mini.extra").setup({}) -- Extra functionality. E.g. :Pick git_hunks
require("mini.sessions").setup({}) -- Session management.
require("mini.diff").setup({}) -- Show git diff in signcolumn and MiniDiff.toggle_overlay()

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
    once = true,
    callback = function()
        require("mini.cursorword").setup({}) -- Highlight word under cursor
        require("mini.splitjoin").setup({}) -- Split and join code blocks. gS to toggle
        require("mini.ai").setup({}) -- Extend a/i text objects
        require("mini.surround").setup({}) -- Add/change/delete surrounding pairs. E.g. sr"' to change surrounding " to '
        require("mini.align").setup({}) -- Align text by a delimiter. E.g. gaip= to align a paragraph by = signs.
        local hipatterns = require("mini.hipatterns")
        local function md(pattern)
            return function(buf)
                return vim.bo[buf].filetype == "markdown" and pattern or nil
            end
        end
        local function md_conceal(pattern, char, group, skip)
            return {
                pattern = md(pattern),
                group = function(_, _, data)
                    if not (skip and data.full_match:match(skip)) then
                        return group
                    end
                end,
                extmark_opts = function(_, _, data)
                    return {
                        end_row = data.line - 1,
                        end_col = data.to_col,
                        conceal = char,
                        hl_group = data.hl_group,
                        priority = 200,
                    }
                end,
            }
        end
        local callout_groups = {
            NOTE = "DiagnosticInfo",
            TIP = "DiagnosticOk",
            IMPORTANT = "DiagnosticHint",
            WARNING = "DiagnosticWarn",
            CAUTION = "DiagnosticError",
        }
        hipatterns.setup({
            highlighters = {
                hex_color = hipatterns.gen_highlighter.hex_color(),
                md_bullet = md_conceal("^%s*()[-*+]() .*", "•", "@markup.list", "^%s*[-*+] %[[ xX]%]"),
                md_unchecked = md_conceal("^%s*()[-*+] %[ %]()", "󰄱", "@markup.list.unchecked"),
                md_checked = md_conceal("^%s*()[-*+] %[[xX]%]()", "󰄲", "@markup.list.checked"),
                md_done = {
                    pattern = md("^%s*[-*+] %[[xX]%] ()%S.*()"),
                    group = "Comment",
                    extmark_opts = { hl_group = { "Comment", "@markup.strikethrough" }, priority = 200 },
                },
                md_callout = {
                    pattern = md("^>%s*()%[!%u+%]()"),
                    group = function(_, match)
                        return callout_groups[match:match("%u+")]
                    end,
                },
            },
        })
        local gen_loader = require("mini.snippets").gen_loader
        require("mini.snippets").setup({
            snippets = {
                gen_loader.from_file(vim.fn.stdpath("config") .. "/snippets/global.json"),
                gen_loader.from_lang(),
            },
        })
        MiniSnippets.start_lsp_server()
    end,
})

local miniclue = require("mini.clue")
miniclue.setup({
    triggers = {
        { mode = { "n", "x" }, keys = "<Leader>" },
        { mode = "n", keys = "[" },
        { mode = "n", keys = "]" },
        { mode = "i", keys = "<C-x>" },
        { mode = { "n", "x" }, keys = "g" },
        { mode = { "n", "x" }, keys = "'" },
        { mode = { "n", "x" }, keys = "`" },
        { mode = { "n", "x" }, keys = '"' },
        { mode = { "i", "c" }, keys = "<C-r>" },
        { mode = "n", keys = "<C-w>" },
        { mode = { "n", "x" }, keys = "z" },
    },
    clues = {
        miniclue.gen_clues.square_brackets(),
        miniclue.gen_clues.builtin_completion(),
        miniclue.gen_clues.g(),
        miniclue.gen_clues.marks(),
        miniclue.gen_clues.registers(),
        miniclue.gen_clues.windows(),
        miniclue.gen_clues.z(),
        { mode = "n", keys = "<Leader>b", desc = "+Buffer" },
        { mode = "n", keys = "<Leader>c", desc = "+Copy" },
        { mode = "n", keys = "<Leader>e", desc = "+Explorer/Edit" },
        { mode = "n", keys = "<Leader>f", desc = "+Find" },
        { mode = "n", keys = "<Leader>g", desc = "+Git" },
        { mode = { "n", "x" }, keys = "<Leader>i", desc = "+AI" },
        { mode = "n", keys = "<Leader>m", desc = "+Markdown" },
        { mode = "n", keys = "<Leader>q", desc = "+Quickfix" },
        { mode = "n", keys = "<Leader>r", desc = "+Refactor" },
        { mode = "n", keys = "<Leader>s", desc = "+Session" },
        { mode = "n", keys = "<Leader>w", desc = "+Wiki" },
        { mode = "n", keys = "<Leader>z", desc = "+Spell check" },
    },
})

-- ================================================
--                     LSP
-- ================================================
require("mason").setup({})
require("mason-lspconfig").setup({})
require("mason-tool-installer").setup({
    ensure_installed = {
        "bashls",
        "clangd",
        "copilot-language-server", -- npm
        "lua-language-server",
        "powershell_es",
        "pylsp",
        "stylua", -- npm
        "tinymist", -- npm
        "prettierd", -- npm
        "shfmt",
    },
    run_on_start = false,
})

-- Default roslyn_ls opens first sln alphabetically. Prefer sln named after repo, else prompt.
vim.lsp.config("roslyn_ls", {
    handlers = {
        -- Core handler pulls workspace diagnostics: one bufadd() per solution document, O(n^2) in buffer count.
        -- That freezes nvim for minutes on large solutions, so only re-pull diagnostics for loaded buffers.
        ["workspace/diagnostic/refresh"] = function(_, _, ctx)
            local client = vim.lsp.get_client_by_id(ctx.client_id)
            if not client then
                return vim.NIL
            end
            for buf in pairs(client.attached_buffers) do
                if vim.api.nvim_buf_is_loaded(buf) then
                    client:request(
                        "textDocument/diagnostic",
                        { textDocument = vim.lsp.util.make_text_document_params(buf) },
                        nil,
                        buf
                    )
                end
            end
            return vim.NIL
        end,
    },
    on_init = function(client)
        local root_dir = client.config.root_dir
        local slns = {}
        for entry, type in vim.fs.dir(root_dir) do
            if type == "file" and (entry:match("%.sln$") or entry:match("%.slnx$")) then
                table.insert(slns, entry)
            end
        end
        local function open(sln)
            client:notify("solution/open", { solution = vim.uri_from_fname(vim.fs.joinpath(root_dir, sln)) })
        end
        if #slns == 0 then
            local projects = {}
            for entry, type in vim.fs.dir(root_dir) do
                if type == "file" and entry:match("%.csproj$") then
                    table.insert(projects, vim.uri_from_fname(vim.fs.joinpath(root_dir, entry)))
                end
            end
            client:notify("project/open", { projects = projects })
            return
        end
        if #slns == 1 then
            return open(slns[1])
        end
        local git_root = vim.fs.root(root_dir, ".git") or root_dir
        local repo = vim.fs.basename(git_root):lower()
        for _, sln in ipairs(slns) do
            if sln:lower():gsub("%.slnx?$", "") == repo then
                return open(sln)
            end
        end
        vim.ui.select(slns, { prompt = "Roslyn solution:" }, function(choice)
            if choice then
                open(choice)
            end
        end)
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "cs",
    callback = function()
        vim.lsp.enable("roslyn_ls")
        vim.cmd.compiler("dotnet")
    end,
})

vim.lsp.enable("copilot")
vim.lsp.inline_completion.enable()

-- ================================================
--                 Autocmds
-- ================================================
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.hl.on_yank({ timeout = 1000 })
    end,
})

-- Jump to the last cursor position, except in commit and rebase messages (:h restore-cursor).
vim.api.nvim_create_autocmd("BufReadPre", {
    callback = function(e)
        vim.api.nvim_create_autocmd("FileType", {
            buffer = e.buf,
            once = true,
            callback = function()
                local line = vim.fn.line([['"]])
                local skip = vim.bo.filetype:match("commit") or vim.bo.filetype == "gitrebase" or vim.wo.diff
                if not skip and line >= 1 and line <= vim.fn.line("$") then
                    vim.cmd([[normal! g`"]])
                end
            end,
        })
    end,
})

-- Enable spelling for certain filetypes
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "text", "gitcommit" },
    command = "setlocal spell",
})

-- Don't conceal [text] or [text][label]: the parser treats them as reference links even without a definition
local md_inline_query = table.concat(
    vim.tbl_map(function(f)
        return table.concat(vim.fn.readfile(f), "\n")
    end, vim.treesitter.query.get_files("markdown_inline", "highlights")),
    "\n"
)
for _, node in ipairs({ "shortcut_link", "full_reference_link", "collapsed_reference_link" }) do
    md_inline_query = md_inline_query:gsub("(%(" .. node .. '%s*%[[^@]-%]%s*@markup%.link)%s*%(#set! conceal ""%)', "%1")
end
vim.treesitter.query.set("markdown_inline", "highlights", md_inline_query)

vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function(args)
        vim.treesitter.start(args.buf)
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
        vim.opt_local.breakindent = true
        vim.opt_local.breakindentopt = "list:-1"
        vim.opt_local.conceallevel = 2
        vim.opt_local.concealcursor = "nc"
    end,
})

-- Save session on exit. Checked at startup: <leader>a adds to the arglist later.
local started_with_file = vim.fn.argc() > 0 and vim.fn.isdirectory(vim.fn.argv(0)) == 0
vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
        if started_with_file or vim.g.no_fancy_ui then
            return
        end
        MiniSessions.write(vim.fn.fnamemodify(vim.fn.getcwd(), ":t") .. ".vim")
    end,
})

-- ================================================
--               Minimal Scrollbar
-- ================================================
local function scrollbar_hl()
    vim.api.nvim_set_hl(0, "Scrollbar", { fg = "#6c7086", bg = "NONE" })
end
scrollbar_hl()
vim.api.nvim_create_autocmd("ColorScheme", { callback = scrollbar_hl })

local sb_win = nil
local sb_buf = nil

local function scrollbar_hide()
    if sb_win and vim.api.nvim_win_is_valid(sb_win) then
        vim.api.nvim_win_close(sb_win, true)
        sb_win = nil
    end
end

local function scrollbar_show()
    if vim.g.no_fancy_ui then
        return
    end
    local win = vim.fn.win_getid()
    local info = vim.fn.getwininfo(win)[1]
    if not info then
        return
    end

    local total = vim.fn.line("$")
    if total <= 1 then
        scrollbar_hide()
        return
    end

    local height = vim.api.nvim_win_get_height(win)
    local top = info.topline
    local bot = info.botline

    -- Calculate scrollbar position
    local scroll_pct = (top - 1) / math.max(1, total - (bot - top + 1))
    local thumb_pct = math.max(0.05, math.min(1, (bot - top) / total))

    local bar_height = math.max(1, math.floor(thumb_pct * height))
    local row = math.floor(scroll_pct * (height - bar_height))

    -- Create buffer if needed
    if not sb_buf or not vim.api.nvim_buf_is_valid(sb_buf) then
        sb_buf = vim.api.nvim_create_buf(false, true)
        vim.bo[sb_buf].bufhidden = "wipe"
    end

    -- Create window if needed
    local config = {
        relative = "win",
        win = win,
        anchor = "NE",
        width = 1,
        height = bar_height,
        row = row,
        col = vim.api.nvim_win_get_width(win),
        style = "minimal",
        focusable = false,
        noautocmd = true,
    }

    if not sb_win or not vim.api.nvim_win_is_valid(sb_win) then
        sb_win = vim.api.nvim_open_win(sb_buf, false, config)
        vim.wo[sb_win].winhighlight = "Normal:Scrollbar"
    else
        vim.api.nvim_win_set_config(sb_win, config)
    end

    -- Set content
    vim.api.nvim_buf_set_lines(sb_buf, 0, -1, false, vim.fn["repeat"]({ "▌" }, bar_height))
end

vim.api.nvim_create_autocmd({ "WinScrolled", "WinEnter", "BufEnter", "VimResized" }, {
    callback = function()
        local win = vim.fn.win_getid()
        local info = vim.fn.getwininfo(win)[1]
        if not info then
            return
        end
        local total = vim.fn.line("$")
        local height = vim.api.nvim_win_get_height(win)
        if total <= height then
            scrollbar_hide()
        else
            scrollbar_show()
        end
    end,
})

vim.api.nvim_create_autocmd({ "WinLeave", "BufWinLeave" }, {
    callback = scrollbar_hide,
})

-- ================================================
--                     Review
-- ================================================
-- <leader>gR: unstaged hunks and untracked files to quickfix. Move with ]q/[q, stage with ghgh.
-- <leader>gm: comment on the line or selection, appended to .git/review-comments.md. gF on a heading jumps back.
local function git_repo(path)
    local real = vim.uv.fs_realpath(path) or path
    local dir = vim.fn.isdirectory(real) == 1 and real or vim.fs.dirname(real)
    local out = vim.fn.systemlist({
        "git",
        "-C",
        dir,
        "rev-parse",
        "--show-toplevel",
        "--absolute-git-dir",
        "--abbrev-ref",
        "HEAD",
    })
    if vim.v.shell_error ~= 0 then
        return nil
    end
    return {
        root = vim.fs.normalize(out[1]),
        gitdir = vim.fs.normalize(out[2]),
        branch = out[3],
        file = vim.fs.normalize(real),
    }
end

local function review_hunks()
    local repo = git_repo(vim.fn.getcwd())
    if not repo then
        return vim.notify("Review needs a git repository", vim.log.levels.WARN)
    end
    local function git(...)
        return vim.fn.systemlist({ "git", "-c", "core.quotePath=false", "-C", repo.root, ... })
    end
    local items, file, header = {}, nil, false
    for _, line in ipairs(git("diff", "-U0", "--no-color", "--no-ext-diff")) do
        if vim.startswith(line, "diff --git ") then
            header, file = true, nil
        elseif header and vim.startswith(line, "+++ ") then
            file = line:match("^%+%+%+ b/(.-)\t?$")
        elseif vim.startswith(line, "@@ ") then
            header = false
            local lnum = file and tonumber(line:match("^@@ %-[%d,]+ %+(%d+)"))
            if lnum then
                local item = { filename = vim.fs.joinpath(repo.root, file), lnum = math.max(lnum, 1), text = line }
                table.insert(items, item)
            end
        end
    end
    for _, path in ipairs(git("ls-files", "--others", "--exclude-standard")) do
        table.insert(items, { filename = vim.fs.joinpath(repo.root, path), lnum = 1, text = "untracked file" })
    end
    if #items == 0 then
        return vim.notify("Review: no unstaged changes", vim.log.levels.INFO)
    end
    vim.fn.setqflist({}, " ", { title = "Review: unstaged changes", items = items })
    vim.cmd.cfirst()
end

local function review_comment()
    local first, last = vim.fn.line("v"), vim.fn.line(".")
    first, last = math.min(first, last), math.max(first, last)
    vim.cmd("normal! \27")
    local repo = git_repo(vim.api.nvim_buf_get_name(0))
    if not repo or vim.fn.filereadable(repo.file) == 0 then
        return vim.notify("Review comments need a file in a git repository", vim.log.levels.WARN)
    end
    local where = ("%s:%d"):format(vim.fs.relpath(repo.root, repo.file) or repo.file, first)
    if last > first then
        where = where .. "-" .. last
    end
    local code = vim.api.nvim_buf_get_lines(0, first - 1, last, false)
    local lang = vim.bo.filetype
    vim.ui.input({ prompt = "Comment on " .. where .. ": " }, function(text)
        if not text or vim.trim(text) == "" then
            return
        end
        local path = vim.fs.joinpath(repo.gitdir, "review-comments.md")
        local lines = {}
        if not vim.uv.fs_stat(path) then
            lines = { ("# Review: %s (%s)"):format(vim.fs.basename(repo.root), repo.branch), "" }
        end
        local fence = table.concat(code, "\n"):find("```", 1, true) and "````" or "```"
        vim.list_extend(lines, { "## " .. where, "", fence .. lang })
        vim.list_extend(lines, code)
        vim.list_extend(lines, { fence, "", text, "" })
        vim.fn.writefile(lines, path, "a")
        vim.notify("Comment added to " .. path)
    end)
end

local function review_open_comments()
    local name = vim.api.nvim_buf_get_name(0)
    local repo = git_repo(vim.uv.fs_stat(name) and name or vim.fn.getcwd())
    if not repo then
        return vim.notify("Review comments need a git repository", vim.log.levels.WARN)
    end
    vim.cmd.split(vim.fn.fnameescape(vim.fs.joinpath(repo.gitdir, "review-comments.md")))
    vim.opt_local.path:prepend(repo.root)
end

map("n", "<leader>gR", review_hunks, opts("Review unstaged hunks in quickfix"))
map({ "n", "x" }, "<leader>gm", review_comment, opts("Add review comment"))
map("n", "<leader>go", review_open_comments, opts("Open review comments"))

--- =============================================
---                ui2
--- =============================================
-- Experimental UI2: floating cmdline and messages
-- https://www.reddit.com/r/neovim/comments/1sfmgkb/comment/oeyrgua/?context=3
-- Skip the floating UI when launched as a git difftool/mergetool (see
-- git config difftool.nvimdifftool.cmd), otherwise nvim.difftool's :only call
-- fails with E5601 because only a floating window would remain. Keep this block
-- last in the file so this early return stays safe.
if vim.g.no_fancy_ui then
    return
end
require("vim._core.ui2").enable({
    msg = {
        targets = {
            typed_cmd = "cmd", -- Trigger, checked before kinds: typed commands answer in the cmdline
            bufwrite = "msg",
            echo = "msg",
            echomsg = "msg",
            lua_print = "msg",
            quickfix = "msg",
            shell_ret = "msg",
            undo = "msg",
            wmsg = "msg",
            emsg = "pager",
            list_cmd = "pager",
            lua_error = "pager",
            progress = "pager",
            rpc_error = "pager",
            shell_cmd = "pager",
            shell_err = "pager",
            shell_out = "pager",
            verbose = "pager",
        },
        msg = { height = 0.3, timeout = 5000 },
        pager = { height = 0.5 },
    },
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "msg",
    callback = function()
        local ui2 = require("vim._core.ui2")
        local win = ui2.wins and ui2.wins.msg
        if win and vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_set_option_value(
                "winhighlight",
                "Normal:NormalFloat,FloatBorder:FloatBorder",
                { scope = "local", win = win }
            )
        end
    end,
})

-- Private ui2 internals: patch only if they still look the same after a Neovim update.
local ui2 = require("vim._core.ui2")
local msgs_ok, msgs = pcall(require, "vim._core.ui2.messages")
if msgs_ok and type(msgs.set_pos) == "function" then
    local orig_set_pos = msgs.set_pos
    msgs.set_pos = function(tgt)
        orig_set_pos(tgt)
        local win = ui2.wins and ui2.wins.msg
        if (tgt == "msg" or tgt == nil) and win and vim.api.nvim_win_is_valid(win) then
            pcall(vim.api.nvim_win_set_config, win, {
                relative = "editor",
                anchor = "NE",
                row = 1,
                col = vim.o.columns - 1,
                border = "rounded",
            })
        end
    end
end
