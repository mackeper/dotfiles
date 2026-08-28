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
vim.opt.fixendofline = false -- Don't automatically add newline at end of file

-- Search
vim.opt.ignorecase = true -- Ignore case in search patterns
vim.opt.smartcase = true -- Override ignorecase if search pattern contains uppercase letters
vim.opt.hlsearch = true -- Highlight search matches
vim.opt.incsearch = true -- Show search matches as you type
vim.opt.inccommand = "split" -- Show search substitution in split

vim.opt.grepprg = "rg --vimgrep --smart-case"

-- Indentation
vim.opt.tabstop = 4 -- Number of spaces that a <Tab> counts for
vim.opt.softtabstop = 4 -- Number of spaces that a <Tab> counts for
vim.opt.shiftwidth = 4 -- Number of spaces to use for each step of (auto)indent
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.smartindent = true -- Smart autoindenting when starting a new line

-- Command
vim.opt.wildmenu = true -- Command line wild search
vim.opt.wildmode = "longest:full,full"

-- Completion (<C-x><C-o> omnifunc, <C-x><C-n> keywords, <C-x><C-f> file paths, <C-x><C-u> user defined)
vim.opt.autocomplete = true -- Enable autocompletion
vim.opt.complete = { ".,w,b,u,t,o" } -- Sources for completion
vim.opt.completeopt = "fuzzy,noinsert,noselect,menu,menuone" -- how completion menu behaves
vim.opt.pumheight = 10 -- Max height of the completion menu


-- ================================================
--                   Keymaps
-- ================================================
local function opts(desc, extra)
    return vim.tbl_extend("force", { silent = true, noremap = true, desc = desc }, extra or {})
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
map("n", "<Esc>", "<cmd>nohlsearch<CR>", opts())
map("n", "<C-t>", toggle_light_mode, opts("Toggle light theme"))
map("n", "<leader>es", "<cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0), false)<cr>", opts("Open file explorer"))
map("n", "<C-p>", "<cmd>Pick files<cr>", opts())
map("n", "<C-f>", "<cmd>Pick grep_live<cr>", opts())
map("n", "<C-b>", "<cmd>Pick buffers<cr>", opts())
map("n", "<leader>fg", "<cmd>Pick git_hunks<cr>", opts("Search git hunks"))
map("n", "<M-r>", "<cmd>Pick visit_paths<cr>", opts())
map("n", "<leader>fh", "<cmd>Pick help<cr>", opts("Search help"))
map("n", "<leader>fw", "<cmd>Pick grep pattern='<cword>'<cr>", opts("Grep word"))
map(
    "n",
    "<leader>fW",
    "<cmd>Pick grep pattern=[[(([^n][^e][^w])\\s+<cword>\\s*\\\\\\(|class.*<cword>\\s|<cword>\\s\\{)]]<cr>",
    opts("Grep C function")
)
map("n", "<leader>ff", "<cmd>Pick resume<cr>", opts("Resume last picker"))

local function pick_tags_then_grep()
    require('mini.pick').start({
        source = {
            items = vim.fn.systemlist([[rg -oPIN '(?<!\S)#\w+' . | sort -u]]) ,
            name = "Tags",
            choose = function(tag)
                require('mini.pick').builtin.grep({ pattern = tag })
            end,
        },
    })
end
vim.keymap.set("n", "<leader>ft", pick_tags_then_grep, { desc = "Pick tag → grep" })

-- AI
map({ "n", "v" }, "<C-l>", "<cmd>CopilotChatToggle<cr>", opts())
vim.keymap.set("i", "<M-l>", 'copilot#Accept("\\<CR>")', {
    expr = true,
    replace_keycodes = false,
})
vim.g.copilot_no_tab_map = true

-- Git
map("n", "<leader>gd", "<cmd>lua MiniDiff.toggle_overlay()<cr>", opts("Toggle git diff overlay"))
map("n", "<leader>gc", "<cmd>Pick git_commits<cr>", opts("Git commits"))

-- stylua: ignore start
-- Git blame line, run again to copy hash
local last_time, last_line = 0, 0
map("n", "<leader>gb", function()
    local now = vim.loop.now()
    local line = vim.fn.line(".")
    local o = vim.fn.systemlist({
        "git",
        "blame",
        "--line-porcelain",
        "-L",
        vim.fn.line(".") .. ",+1",
        vim.api.nvim_buf_get_name(0),
    })
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

map("n", "<C-Left>", "<C-w>h", opts("Window left"))
map("n", "<C-Down>", "<C-w>j", opts("Window down"))
map("n", "<C-Up>", "<C-w>k", opts("Window up"))
map("n", "<C-Right>", "<C-w>l", opts("Window right"))

map("n", "<tab>", ":bnext<CR>", opts("Next buffer"))
map("n", "<S-tab>", ":bprevious<CR>", opts("Previous buffer"))

vim.api.nvim_create_autocmd("FileType", {
    pattern = "cs",
    callback = function()
        local scope_pattern = [[\(public\|private\|protected\|class\|interface\|struct\|enum\)]]
        map("n", "[[", "?^\\s*" .. scope_pattern .. "<CR>:nohl<CR>", { buffer = true })
        map("n", "]]", "/^\\s*" .. scope_pattern .. "<CR>:nohl<CR>", { buffer = true })
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

local term_buffer = nil
map({"n", "t"}, "<C-s>", function()
    if term_buffer and vim.api.nvim_buf_is_valid(term_buffer) then
        if vim.api.nvim_buf_get_name(0) == vim.api.nvim_buf_get_name(term_buffer) then
            vim.cmd("bprevious")
        else
            vim.cmd("buffer " .. term_buffer)
            vim.cmd("startinsert")
        end
    else
        vim.cmd("terminal")
        vim.cmd("startinsert")
        term_buffer = vim.api.nvim_get_current_buf()
    end
end, opts("Toggle terminal"))

local lazygit_buffer = nil
map({"n", "t"}, "<C-g>", function()
    if lazygit_buffer and vim.api.nvim_buf_is_valid(lazygit_buffer) then
        if vim.api.nvim_buf_get_name(0) == vim.api.nvim_buf_get_name(lazygit_buffer) then
            vim.cmd("bprevious")
        else
            vim.cmd("buffer " .. lazygit_buffer)
            vim.cmd("startinsert")
        end
    else
        vim.cmd("terminal lazygit")
        vim.cmd("startinsert")
        lazygit_buffer = vim.api.nvim_get_current_buf()
    end
end, opts("Toggle lazygit"))

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

local function run_dotnet_test(filter)
    local source_dir = vim.fn.expand("%:p:h")
    local csproj = vim.fs.find(function(name)
        return name:match("%.csproj$")
    end, { path = source_dir, upward = true, type = "file" })[1]
    if not csproj then
        return vim.notify("No .csproj found for " .. source_dir, vim.log.levels.ERROR)
    end

    local buf = vim.api.nvim_create_buf(false, true)
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
    local command = { "dotnet", "test", csproj, "--filter", test_filter, "--output", "detailed", "--progress", "off" }
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
    local text = vim.fn.getreg("+"):gsub("[ :]", "_")
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
        map("n", "q", "<cmd>cclose<CR>", opts("Close quickfix", { buffer = e.buf }))
        map("n", "dd", function()
            local row = vim.fn.line(".")
            local qf = vim.fn.getqflist()
            table.remove(qf, row)
            vim.fn.setqflist(qf, "r")
            vim.cmd("copen")
            local new_row = math.min(row, #qf)
            if new_row > 0 then
                vim.schedule(function()
                    pcall(vim.api.nvim_win_set_cursor, 0, { new_row, 0 })
                end)
            end
        end, opts("Delete qf entry", { buffer = e.buf }))
    end,
})

-- wiki
local wiki = vim.fn.expand("~/git/wiki")
local work_wiki = vim.fn.expand("~/OneDrive - RaySearch Laboratories AB/Marcus/10_Documents/05_wiki")
if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
    wiki = "C:\\git\\wiki"
end
map("n", "<leader>ww", "<cmd>edit " .. wiki .. "/index.md<CR>:lcd %:p:h<CR>", opts("Open wiki index"))
map(
    "n",
    "<leader>wj",
    "<cmd>edit " .. wiki .. "/98_Journal/" .. os.date("%Y-%m-%d") .. ".md<CR>:lcd %:p:h<CR>",
    opts("Open wiki journal")
)
map("n", "<leader>wc", "<cmd>edit " .. work_wiki .. "/current.md<CR>:lcd %:p:h<CR>", opts("Open wiki current work"))
map("n", "<M-t>", function()
    vim.cmd([[s/\v[-*] \[\zs[ x]\ze\]/\=submatch(0) ==# 'x' ? ' ' : 'x'/]])
end, opts("Toggle checkbox"))

-- Markdown preview with pandoc (no extra dependencies)
map("n", "<leader>mp", function()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local tmp = os.tmpname() .. ".html"

    vim.system(
        { "pandoc", "-f", "markdown", "-t", "html", "-o", tmp },
        { stdin = table.concat(lines, "\n") },
        function(obj)
            if obj.code ~= 0 then
                vim.schedule(function()
                    vim.notify("pandoc failed: " .. (obj.stderr or ""), vim.log.levels.ERROR)
                end)
                return
            end

            local open_cmd = vim.fn.has("mac") == 1 and "open" or (vim.fn.has("win32") == 1 and "start" or "xdg-open")
            vim.schedule(function()
                vim.fn.jobstart({ open_cmd, tmp }, { detach = true })
                vim.defer_fn(function()
                    vim.fn.delete(tmp)
                end, 60000)
            end)
        end
    )
end, opts("Preview markdown with pandoc"))

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
    "https://github.com/nvim-lua/plenary.nvim", -- Common library
    "https://github.com/nvim-mini/mini.nvim", -- Collection of plugins
    "https://github.com/neovim/nvim-lspconfig", -- Default LSP configurations
    "https://github.com/mason-org/mason.nvim", -- LSP/DAP/Linter/Formatter installer
    "https://github.com/mason-org/mason-lspconfig.nvim", -- Auto enable plugins installed by mason.nvim
    "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim", -- Auto install tools installed by mason.nvim
    "https://github.com/github/copilot.vim", -- GitHub copilot :Copilot setup
    "https://github.com/CopilotC-Nvim/CopilotChat.nvim", -- GitHub copilot chat :CopilotChat
})
vim.cmd.packadd("cfilter") -- filder quickfix list.
vim.cmd.packadd("nvim.undotree") -- UI to navigate undo tree.
vim.cmd.packadd("nvim.difftool") -- not sure

vim.api.nvim_create_user_command("VimPackList", function()
    for _, value in ipairs(vim.pack.get()) do
        print(value.spec.name)
    end
end, { desc = "List plugins" })

-- Mini - A collection of plugins
require("mini.pick").setup({
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
        hipatterns.setup({
            highlighters = {
                hex_color = hipatterns.gen_highlighter.hex_color(),
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

vim.api.nvim_create_autocmd("FileType", {
    pattern = "cs",
    callback = function()
        vim.lsp.enable("roslyn_ls")
    end,
})

-- vim.api.nvim_create_autocmd("LspAttach", {
--     callback = function(args)
--         local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
--         if client:supports_method("textDocument/completion") then
--             vim.lsp.completion.enable(true, client.id, args.buf)
--         end
--     end,
-- })

-- ================================================
--                 Autocmds
-- ================================================
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank({ timeout = 1000 })
    end,
})

-- Restore cursor position when reopening files
vim.opt.viewoptions = "folds,cursor" -- what gets saved in the session
vim.api.nvim_create_autocmd("BufWinLeave", { command = "silent! mkview" })
vim.api.nvim_create_autocmd("BufWinEnter", {
    callback = function()
        pcall(vim.cmd, "silent! loadview")
    end,
})

-- Enable spelling for certain filetypes
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "markdown", "text", "gitcommit" },
    command = "setlocal spell",
})

-- Save session on exit
vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
        MiniSessions.write(vim.fn.fnamemodify(vim.fn.getcwd(), ":t") .. ".vim")
    end,
})

-- ================================================
--               Minimal Scrollbar
-- ================================================
vim.api.nvim_set_hl(0, "Scrollbar", { fg = "#6c7086", bg = "NONE" })

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
    local scroll_pct = (top - 1) / (total - 1)
    local thumb_pct = math.max(0.05, math.min(1, (bot - top) / total))

    local row = math.floor(scroll_pct * (height - 1))
    local bar_height = math.max(1, math.floor(thumb_pct * height))

    -- Create buffer if needed
    if not sb_buf or not vim.api.nvim_buf_is_valid(sb_buf) then
        sb_buf = vim.api.nvim_create_buf(false, true)
        vim.bo[sb_buf].bufhidden = "wipe"
    end

    -- Create window if needed
    local config = {
        relative = "win",
        win = win,
        anchor = "SE",
        width = 1,
        height = bar_height,
        row = row,
        col = vim.o.columns - 1,
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
    vim.api.nvim_buf_set_lines(sb_buf, 0, -1, false, { "▌" })
end

vim.api.nvim_create_autocmd({ "WinScrolled", "BufEnter", "VimResized" }, {
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
vim.o.cmdheight = 1
require("vim._core.ui2").enable({
    enable = true,
    msg = {
        targets = {
            [""] = "cmd",
            empty = "cmd",
            bufwrite = "msg",
            confirm = "cmd",
            emsg = "pager",
            echo = "msg",
            echomsg = "msg",
            echoerr = "cmd",
            completion = "cmd",
            list_cmd = "pager",
            lua_error = "pager",
            lua_print = "msg",
            progress = "pager",
            rpc_error = "pager",
            quickfix = "msg",
            search_cmd = "cmd",
            search_count = "cmd",
            shell_cmd = "pager",
            shell_err = "pager",
            shell_out = "pager",
            shell_ret = "msg",
            undo = "msg",
            verbose = "pager",
            wildlist = "cmd",
            wmsg = "msg",
            typed_cmd = "cmd",
        },
        cmd = {
            height = 0.5,
        },
        dialog = {
            height = 0.5,
        },
        msg = {
            height = 0.3,
            timeout = 5000,
        },
        pager = {
            height = 0.5,
        },
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

local ui2 = require("vim._core.ui2")
local msgs = require("vim._core.ui2.messages")
local orig_set_pos = msgs.set_pos
msgs.set_pos = function(tgt)
    orig_set_pos(tgt)
    if (tgt == "msg" or tgt == nil) and vim.api.nvim_win_is_valid(ui2.wins.msg) then
        pcall(vim.api.nvim_win_set_config, ui2.wins.msg, {
            relative = "editor",
            anchor = "NE",
            row = 1,
            col = vim.o.columns - 1,
            border = "rounded",
        })
    end
end

-- ================================================
--        Diff review mode (git add -p, but nvim)
-- ================================================
-- Toggle with <leader>gR. While active, in the buffer under review:
--   y  stage hunk under cursor (git add -p "yes") and jump to next hunk
--   n  leave hunk unstaged (git add -p "no") and jump to next hunk
--   K  jump to previous hunk
--   c  comment on this hunk (stub - Azure DevOps integration TODO)
--   q  exit review mode
--
-- When a buffer runs out of hunks in one direction, review mode moves to the
-- next/previous changed file (`git diff --name-only HEAD`, sorted) and keeps
-- going, so a whole multi-file changeset can be reviewed without manually
-- reopening each file. NOTE: this only considers already-tracked files;
-- brand new untracked files won't show up unless you `git add -N` them first.
local review_mode = {} -- buf_id -> saved keymaps, to restore on exit
local review_mode_toggle -- forward declaration (used by review_switch_file below)

--- List files that differ from HEAD (staged + unstaged), as absolute paths.
--- @return string[] files, string|nil root
local function review_get_changed_files()
    local dir = vim.fn.expand("%:p:h")
    local root = vim.fn.system({ "git", "-C", dir, "rev-parse", "--show-toplevel" })
    if vim.v.shell_error ~= 0 then
        return {}, nil
    end
    root = vim.trim(root)
    local out = vim.fn.system({ "git", "-C", root, "diff", "--name-only", "HEAD" })
    if vim.v.shell_error ~= 0 then
        return {}, root
    end
    local files = {}
    for _, rel in ipairs(vim.split(out, "\n", { trimempty = true })) do
        table.insert(files, vim.fs.normalize(root .. "/" .. rel))
    end
    table.sort(files)
    return files, root
end

--- Block (without freezing the UI) until mini.diff has computed hunks for
--- `buf`, or `timeout_ms` elapses. Needed because opening a new file and
--- immediately jumping to its first hunk can otherwise race mini.diff's
--- asynchronous diff computation (it shells out to git under the hood).
local function review_wait_hunks(buf, timeout_ms)
    vim.wait(timeout_ms or 1000, function()
        local ok, data = pcall(MiniDiff.get_buf_data, buf)
        return ok and data ~= nil and #data.hunks > 0
    end, 20)
end

--- Turn review mode off in the current buffer, open `path`, enable mini.diff
--- and wait for its hunks there, then turn review mode back on and jump to
--- the first/last hunk depending on `goto_dir`.
---
--- IMPORTANT: MiniDiff.enable() + review_wait_hunks() must run BEFORE
--- review_mode_toggle()'s "enter" branch, because that branch immediately
--- calls MiniDiff.toggle_overlay()/goto_hunk() - which error if the buffer
--- isn't enabled yet, and an error at this point can trigger a blocking
--- message prompt (hangs headless nvim, e.g. under `git difftool`).
local function review_switch_file(path, goto_dir)
    if review_mode[vim.api.nvim_get_current_buf()] then
        review_mode_toggle()
    end
    vim.cmd.edit(vim.fn.fnameescape(path))
    local buf = vim.api.nvim_get_current_buf()
    -- mini.diff normally enables itself on a scheduled BufEnter callback
    -- (an extra event-loop tick); call it directly so review_wait_hunks
    -- below doesn't have to also wait out that scheduling delay.
    pcall(MiniDiff.enable, buf)
    review_wait_hunks(buf, 1000)
    review_mode_toggle()
    vim.api.nvim_buf_call(buf, function() MiniDiff.goto_hunk(goto_dir) end)
end

--- Move to the next/previous hunk; if none remain in this buffer in that
--- direction, hop to the next/previous changed file in the repo.
--- @param direction "next"|"prev"
local function review_advance(direction)
    local before = vim.fn.line(".")
    MiniDiff.goto_hunk(direction, { wrap = false })
    if vim.fn.line(".") ~= before then
        return -- moved within the current buffer, nothing more to do
    end

    local files, root = review_get_changed_files()
    if not root or #files == 0 then
        vim.notify("Review: no more hunks", vim.log.levels.INFO)
        return
    end

    -- Normalize to forward slashes: git paths use "/" while fnamemodify(":p")
    -- returns "\" on Windows, so a raw string comparison never matches there.
    local cur = vim.fs.normalize(vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p"))
    local idx
    for i, f in ipairs(files) do
        if f == cur then
            idx = i
            break
        end
    end

    local target = idx and files[idx + (direction == "next" and 1 or -1)]
    if not target then
        local edge = direction == "next" and "last" or "first"
        vim.notify("Review: reached the " .. edge .. " changed file", vim.log.levels.INFO)
        return
    end

    review_switch_file(target, direction == "next" and "first" or "last")
    vim.notify("Reviewing: " .. vim.fn.fnamemodify(target, ":."), vim.log.levels.INFO)
end

local function review_stage_and_next()
    local line = vim.fn.line(".")
    MiniDiff.do_hunks(0, "apply", { line_start = line, line_end = line })
    review_advance("next")
end

local function review_skip_and_next()
    review_advance("next")
end

local function review_prev()
    review_advance("prev")
end

local function review_comment()
    -- TODO: wire up to Azure DevOps (e.g. `az repos pr` CLI or REST API).
    -- For now, just report which hunk/lines the comment would target.
    local line = vim.fn.line(".")
    vim.notify(("Comment on hunk at line %d - not implemented yet"):format(line), vim.log.levels.WARN)
end

review_mode_toggle = function()
    local buf = vim.api.nvim_get_current_buf()
    if review_mode[buf] then
        -- Exit: restore whatever y/n/c/K/q did before
        for _, saved in ipairs(review_mode[buf]) do
            if saved.rhs then
                vim.keymap.set(saved.mode, saved.lhs, saved.rhs, { buffer = buf })
            else
                pcall(vim.keymap.del, saved.mode, saved.lhs, { buffer = buf })
            end
        end
        review_mode[buf] = nil
        MiniDiff.toggle_overlay(buf)
        vim.notify("Diff review mode: OFF", vim.log.levels.INFO)
        return
    end

    -- Enter: remember prior mappings so we can restore them
    local to_save = { "y", "n", "K", "c", "q" }
    local saved = {}
    for _, lhs in ipairs(to_save) do
        local existing = vim.fn.maparg(lhs, "n", false, true)
        table.insert(saved, {
            mode = "n",
            lhs = lhs,
            rhs = existing.buffer == 1 and existing.rhs or nil,
        })
    end
    review_mode[buf] = saved

    local bmap = function(lhs, fn, desc)
        vim.keymap.set("n", lhs, fn, { buffer = buf, desc = desc })
    end
    bmap("y", review_stage_and_next, "Review: stage hunk, next")
    bmap("n", review_skip_and_next, "Review: skip hunk, next")
    bmap("K", review_prev, "Review: previous hunk")
    bmap("c", review_comment, "Review: comment on hunk (TODO)")
    bmap("q", review_mode_toggle, "Review: exit review mode")

    MiniDiff.toggle_overlay(buf)
    MiniDiff.goto_hunk("first")
    vim.notify("Diff review mode: ON (y=stage n=skip K=prev c=comment q=quit)", vim.log.levels.INFO)
end

map("n", "<leader>gR", review_mode_toggle, opts("Toggle diff review mode"))
