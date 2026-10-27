# Neovim config review

Target: `.config/nvim/init.lua` (1309 lines), Neovim 0.12.2, Windows. Nothing in your config was modified.

Second version, after your feedback on items 1 to 13. The Decision column in the summary records what you decided. Items without a decision are unchanged and still open. Skipped items stay as short stubs, so the numbers do not move.

I kept to your own rules in `neovim.instructions.md`: one file (the exception is `lua/dotnet.lua` in items 12-13, which you asked for), `vim.pack` only, built-in first, then a mini.nvim module, then a few lines of local Lua, then a new plugin (justified). Every new keymap in `init.lua` uses `map` and `opts`, and its lhs was checked against your existing mappings and the 0.12 defaults.

How to read this:

- **[verified]** the snippet was extracted from this file and executed headless on Neovim 0.12.2, usually against real data (your `test-output.log`, a sample Roslyn project, your session folder in dry-run mode).
- **[partly verified]** the non-UI parts ran. Where the item says so, a picker, float, terminal or popup was not seen on screen.
- **[unverified]** not run, because it needs something installed or would touch your real data. The reason is stated.

## Summary

| # | Change | Gain | Effort | Status | Your decision |
|---|--------|------|--------|--------|---------------|
| [1](#item-1) | `completeopt` + `popup`, borders, `jumpoptions`, title, `vim.loader` | Doc popups in C# completion, about 25 ms faster startup | 7 lines | verified | Question answered in the item |
| [2](#item-2) | Statusline: diagnostics, LSP progress, git branch | See buffer errors and server progress at a glance | 8 lines | verified | |
| [3](#item-3) | Diagnostics: current-line text and one picker | Today only signs are shown | 13 lines | verified | `<leader>fd` only |
| [4](#item-4) | mini.clue: `<Leader>t` and the `s` trigger | Your rule says new prefixes need a clue | 2 lines | verified | No `<Leader>d` clue |
| [5](#item-5) | Drop `<Tab>`/`<S-Tab>` maps | `]b` needs two keys | none | n/a | Skipped, keep `<Tab>` |
| [6](#item-6) | mini.icons and mini.git | Per-filetype icons in pickers; git summary, history | 8 lines | verified | Try both, no bufremove |
| [7](#item-7) | Copilot only on code filetypes | Copilot is attached to markdown, your wiki, everything | 8 lines, replaces 2 | verified | |
| [8](#item-8) | Warn once when `roslyn-language-server` is missing | Log has 1228 errors from this | 3 lines | verified | "Is not 2 enough?" |
| [9](#item-9) | LspAttach: on-type formatting | Roslyn reindents as you type `}` and `;` | 8 lines | verified | No folding, no inlay hints |
| [10](#item-10) | Symbol, reference and call-hierarchy navigation | | none | n/a | Skipped |
| [11](#item-11) | Roslyn: analysis scope, file watching | Server CPU and UI hitches on a large solution | 11 lines | settings verified, perf unverified | Yes |
| [12-13](#item-12-13) | `lua/dotnet.lua`: async build, test runner into quickfix | `:make` blocks the UI; jump from a failed test to the frame | new file of 263 lines, 11 lines in `init.lua`, deletes 92 | verified (fake `dotnet` for tests, real for build) | Write it as `dotnet.lua` |
| [14](#item-14) | Short paths in the quickfix list | Reuses your `shorten_pick_path` | 17 lines | verified | |
| [15](#item-15) | Format only changed hunks (Roslyn range formatting) | No noisy whole-file diffs | 18 lines | verified | |
| [16](#item-16) | Wire up stylua and shfmt, with range support | Installed but unused today | 62 lines | verified | |
| [17](#item-17) | TODO/FIXME highlighting and picker | mini.hipatterns is already set up | 8 lines | highlighting verified, picker not seen | |
| [18](#item-18) | Wiki pickers | Find and grep the wiki from anywhere | 9 lines | partly verified | |
| [19](#item-19) | `<C-s>` terminal opens `cmd.exe` | Your pwsh profile is not loaded | 2 lines | verified | |
| [20](#item-20) | Prune stale sessions | 24 of 70 sessions point at deleted folders | 20 lines | verified | |
| [21](#item-21) | Native sessions (your TODO) | Drop a module, honest verdict inside | 45 lines | partly verified | |
| [22](#item-22) | Copilot inline: previous, partial accept, toggle | Accept a word or a line | 26 lines | verified | |
| [23](#item-23) | Copilot CLI: send diagnostics and quickfix | Fix this error in one key | 38 lines | partly verified | |
| [24](#item-24) | Treesitter parsers (decision) | Only 7 bundled parsers; no C#, Python, bash | 21 lines | unverified | |
| [25](#item-25) | Home setup: Linux and more languages | Same config, other languages | 4 lines | unverified | |
| [26](#item-26) | Debugging (decision) | Built-in `:Termdebug`; nvim-dap not advised | 1 line | partly verified | |
| [27](#item-27) | Small cleanups | Redundant call, quoted paths, `.luarc.json` globals | various | verified | |
| [28](#item-28) | Considered and not recommended | Saves you the research | none | n/a | |

Suggested order: [1](#item-1), [3](#item-3), [4](#item-4), [6](#item-6) and [8](#item-8) today (all small, low risk), then [9](#item-9) and [11](#item-11), then [12-13](#item-12-13) and [14](#item-14) (the C# loop), then the rest as you feel the need. Items [2](#item-2) and [7](#item-7) are also small; they just have no decision yet.

## Facts that shaped the advice

- Startup is about 155 ms (median of 7 runs); `vim.loader.enable()` brings it to about 128 ms. Four eager mini.nvim `require`s (`pick`, `extra`, `sessions`, `clue`) cost 17 to 20 ms each; with a warm loader cache each takes under 2 ms.
- Only Neovim's bundled parsers exist: `c`, `lua`, `markdown`, `markdown_inline`, `query`, `vim`, `vimdoc`. There is no parser for C#, Python or bash.
- Roslyn (`roslyn-language-server 5.12.0-1.26426.8`, installed as a dotnet tool) advertises these capabilities, checked on a live server: folding ranges, selection ranges, on-type formatting (`}`, `;`, newline), code lens, inlay hints, call and type hierarchy, workspace symbols, range-only semantic tokens. It does not advertise document links, linked editing or inline completion.
- The `roslyn_ls` config you inherit from nvim-lspconfig already enables inlay hints, code lens, and `fullSolution` background analysis in the server settings. Neovim never requests hints or lenses, and your `workspace/diagnostic/refresh` override only re-pulls diagnostics for loaded buffers.
- `lsp.log` (1.4 MB since April): 1228 `roslyn_ls ... not executable` errors (last on 2026-08-21), 40 benign "request superseded" and 71 benign "content modified". Nothing is failing right now.
- 70 session files, 24 of them point at folders that no longer exist (worktrees, `%TEMP%` test runs).
- Your main work repo has 4576 `.cs` files, 99 projects and 3 solution files. The three sit side by side in one folder, so "the nearest `.sln`" is ambiguous; the build code in items 12-13 uses the same pick rule as your `roslyn_ls` `on_init`.
- Copilot LSP has no `filetypes`, so it attaches to every buffer. Checked: it attached to a markdown file within 1 second.
- `autoread` already reloads a file that the Copilot CLI edited on disk as soon as you switch back to its buffer. Checked, so no `checktime` autocmd is needed.
- With the .NET 10 SDK, `dotnet build` prints every diagnostic twice even with `-consoleloggerparameters:NoSummary`, so your `:make` (via `compiler dotnet`) lists each error and warning twice. Checked on a sample project.

## What is already good

- One file with clear sections, and a philosophy header that the code actually follows.
- Native completion (`autocomplete` + omnifunc) and `vim.lsp.inline_completion`. The omnifunc path already applies `additionalTextEdits` and snippets on accept, I read the source to confirm (`trigger()` registers the `CompleteDone` handler), so auto-`using` works.
- The `roslyn_ls` override: solution picked by repo name, and a refresh handler that avoids the O(n^2) `bufadd` freeze. Good detective work, and it is documented in a comment.
- Your own tools: test runner with MTP detection, failed-test picker, review-comments workflow, Copilot CLI toggles with `@file` references.
- `ui2` with a version-guarded patch of private internals.
- mini.clue, mini.pick with a path shortener, mini.visits and sessions per working directory.

---

<a id="item-1"></a>

## 1. Completion docs popup and a small option pack

`completeopt` has no `popup`. In 0.12 the omnifunc path registers a `CompleteChanged` handler that calls `completionItem/resolve` and shows the documentation, but only when `popup` is present. For C# that means the XML doc summary and the overload detail next to the menu. The rest are one-liners: `winborder` and `pumborder` for consistent borders, `jumpoptions=view` so `<C-o>` restores the scroll position, a window title with the folder name (useful with many worktrees in Windows Terminal tabs), and `vim.loader`.

<!-- snippet: options -->
```lua
vim.loader.enable()

vim.opt.completeopt = "fuzzy,noinsert,noselect,menu,menuone,popup"
vim.o.winborder = "rounded"
vim.o.pumborder = "rounded"
vim.opt.jumpoptions = "clean,view"
vim.o.title = true
vim.o.titlestring = "%{fnamemodify(getcwd(), ':t')}: %t"
```

Notes:

- Put `vim.loader.enable()` on the first line of `init.lua`. The docs mark it "experimental/unstable". Measured gain: median 155 ms to 128 ms over 7 runs each, with about 15 ms of noise. If anything odd happens, remove it first.
- Replace your existing `completeopt` line.

**Your question: is the menu in your screenshot not the complete popup?** No. Your screenshot shows the completion *menu*, the list of candidates. The *popup* is a second window beside the menu that shows the documentation of the selected candidate. Neovim 0.12's default is `completeopt=menu,popup`; the line in your config replaces it and drops `popup`.

The second window only opens for candidates that carry documentation. The words in your screenshot (`hex here help HEAD header ...`) come from keyword completion and have none, so that menu looks the same with or without `popup`. The difference is in LSP completion. Roslyn sends no documentation in the completion list; it sends it on `completionItem/resolve`, and Neovim only requests that when `popup` is set. On a live Roslyn, `Console.WriteLine` resolves to this text (the `popup` content, minus the markdown):

```text
void Console.WriteLine()
(+ 19 overloads)
Writes the current line terminator to the standard output stream.
```

To see the window itself I drove a second Neovim in a 120-column terminal against a stand-in LSP server whose items carry documentation, and copied what it drew. Your current setting, menu only:

```text
Write
Write        Method void Write()
WriteLine    Method void WriteLine()
WriteAllText Method void WriteAllText()
```

With `popup`, the documentation window sits to the right of the selected row (here it wraps onto the next line):

```text
Write
Write        Method void Write()        Writes the text representation of the specified value to the standard output st
WriteLine    Method void WriteLine()    ream.
WriteAllText Method void WriteAllText()
```

Keyword completion with `popup` draws the same plain menu as your screenshot, with no second window.

<a id="item-2"></a>

## 2. Statusline: diagnostics, LSP progress, git branch

0.12's default statusline shows `vim.diagnostic.status()` and `vim.ui.progress_status()`. Your custom statusline dropped both, so nothing shows the buffer's error count or what a server is busy with. It also has `%=%=` (doubled). The `%{%...%}` form is required because `status()` returns highlight escapes. The branch comes from mini.git (item 6) and is empty until it is set up.

<!-- snippet: statusline -->
```lua
vim.opt.statusline = table.concat({
    "[%n] %<%f %h%w%m%r%q",
    "%=",
    "%{%v:lua.vim.ui.progress_status()%}",
    "%{%v:lua.vim.diagnostic.status()%} ",
    "%{get(b:, 'minigit_summary_string', '')} ",
    "%y %-14.(%l,%c%V%) %L %P",
})
```

Notes: the render was verified with two diagnostics and a fake branch string. Roslyn emitted no `Progress` events in my run (a small project, 0 events), so do not expect a "loading solution" indicator from it; only servers that send `$/progress` show up in `progress_status()`. nvim-lspconfig's `roslyn_ls` prints a one-off "Roslyn project initialization complete" message instead. A "Roslyn is ready" marker would mean wrapping that `workspace/projectInitializationComplete` handler and setting a global the statusline reads; I did not build that.

<a id="item-3"></a>

## 3. Diagnostics: current-line text and one picker

`vim.diagnostic.config()` is never called, so you get signs and underlines only (virtual text and lines are off). Showing the message only on the cursor line keeps the buffer quiet and still readable. The 0.12 docs list no `jump.float` option, only `on_jump`, `wrap` and `severity`; `on_jump` is the documented way to open the float after a jump (it runs on the next event-loop tick). As you asked, there is one picker key: `<leader>fd` lists the diagnostics of all buffers, errors first.

<!-- snippet: diagnostics -->
```lua
vim.diagnostic.config({
    severity_sort = true,
    virtual_text = { current_line = true, source = "if_many" },
    float = { source = "if_many" },
    jump = {
        on_jump = function(diagnostic, bufnr)
            if diagnostic then
                vim.diagnostic.open_float({ bufnr = bufnr, scope = "cursor", focus = false })
            end
        end,
    },
})

map("n", "<leader>fd", "<cmd>Pick diagnostic scope='all'<cr>", opts("Diagnostics (all buffers)"))
```

Notes: `<leader>fd` is free and sits in your existing `<Leader>f` "Find" group, so it needs no new clue. `Pick diagnostic` needs mini.extra, which you already set up, and sorts by severity by default. "All buffers" means every buffer Neovim holds diagnostics for. With Roslyn that is the buffers you have opened, because your `workspace/diagnostic/refresh` override only re-pulls loaded buffers (item 11 has the on-demand alternative).

Seen on screen: I pressed `<leader>fd` in a second Neovim running in a terminal, with three sample diagnostics in two files (empty picker rows removed). Errors come first, then warnings and hints:

```text
╭> ▏───────────────────────────────────────────────────────────────────────╮
│E │ Greeter.cs │ CS0103: The name 'greting' does not exist in the current…│
│W │ Helpers.cs │ CS8618: Non-nullable property 'Name' must contain a non-…│
│H │ Greeter.cs │ IDE0005: Using directive is unnecessary                  │
╰ Diagnostic (all) ───────────────────────────────────────────────── 1|3|3 ╯
```

<a id="item-4"></a>

## 4. mini.clue: the `s` trigger and the `<Leader>t` group

Your rule says a new leader prefix needs a clue entry. `<Leader>t` (tests) already has mappings and no entry. `s` is the prefix for all mini.surround mappings (`sa`, `sd`, `sr`...) but is not a trigger, so there is no hint popup after pressing it. With item 3 reduced to `<leader>fd`, there is no `<Leader>d` group, so no entry for it.

<!-- snippet: clue -->
```lua
-- add to `triggers`
{ mode = { "n", "x" }, keys = "s" },

-- add to `clues`
{ mode = "n", keys = "<Leader>t", desc = "+Test/.NET" },
```

<a id="item-5"></a>

## 5. Drop the `<Tab>` and `<S-Tab>` maps (skipped)

You decided to keep them: the built-in `]b` and `[b` need two keys. The one thing to know is that `<Tab>` and `<C-i>` are the same byte in terminals without the kitty keyboard protocol, so the maps hide jump-forward (`<C-i>`). To check your terminal, run `:lua print(vim.inspect(vim.fn.getcharstr()))`, press Tab, then repeat with Ctrl-i. If both print the same and you never miss `<C-i>`, there is nothing to do.

<a id="item-6"></a>

## 6. mini.icons and mini.git

- `mini.icons`: `pick_show` passes `show_icons = true` and you wrote "keep real path so icon lookup still works", but `MiniIcons` is never set up. Without it (and without nvim-web-devicons, which you do not have), mini.pick and mini.files draw one fixed glyph for files and one for folders; checked in `H.get_icon` and `MiniFiles.default_prefix`. With it, every entry gets an icon and color by filetype.
- `mini.git` is a TODO in your header. It gives `:Git`, `show_at_cursor`, the history of a selection (`git log -L`) and `b:minigit_summary_string` for the statusline (item 2). Keep your own `<leader>gb` blame; it does something mini.git does not (copy hash on a second press).

You decided against `mini.bufremove`, so `<leader>bd` stays as it is. Both modules are already in the installed mini.nvim, so there is no new dependency.

<!-- snippet: mini_modules -->
```lua
require("mini.icons").setup({})
require("mini.git").setup({})

map({ "n", "x" }, "<leader>gs", function()
    MiniGit.show_at_cursor()
end, opts("Show git info at cursor"))
map("x", "<leader>gh", function()
    MiniGit.show_range_history()
end, opts("Git history of selection"))
```

Notes:

- `<leader>gs` shows the commit when the cursor is on a hash, and otherwise the history of the current line (`git log -L`). `<leader>gh` does the same for a selection. Both histories refuse to run while the file has uncommitted changes (mini.git's own rule, from its docs).
- Checked on a temporary repository: the branch in `b:minigit_summary_string`, the line history, the selection history and the commit view all work on Windows. For the icons, mini.pick's `default_show` gave the same fixed glyph for a `.cs` and a `.lua` file before the setup, and different glyphs and highlight groups after it.
- Add `MiniIcons` and `MiniGit` to `diagnostics.globals` in `.luarc.json`. The icons need a Nerd Font, which you already use for the markdown bullets.

<a id="item-7"></a>

## 7. Copilot: attach only to code filetypes

`copilot` has no `filetypes`, so the language server attaches to every buffer: markdown, your wiki notes, `appsettings.json`, certificate and `.env` files. With inline completion enabled globally, typing in those buffers sends context to GitHub. GitHub's own VS Code defaults (`github.copilot.enable`) turn Copilot off for plaintext, markdown and commit messages. An allow-list means the client never attaches, which is stronger than detaching after `didOpen`. Add `json` or `yaml` if you want them.

<!-- snippet: copilot_filetypes -->
```lua
vim.lsp.config("copilot", {
    filetypes = {
        "cs", "lua", "python", "sh", "bash", "ps1", "c", "cpp", "rust", "go",
        "javascript", "typescript", "typst", "make",
    },
})
vim.lsp.enable("copilot")
vim.lsp.inline_completion.enable()
```

Notes: replace your two existing `copilot` lines. Verified on your real config: a markdown buffer no longer gets the client, a Lua buffer still does.

<a id="item-8"></a>

## 8. Roslyn: warn once when the server is missing

When `roslyn-language-server` is not executable, each `.cs` buffer logs `invalid "roslyn_ls" config` (1228 times in your log, until 2026-08-21). Roslyn is the only server not covered by `ensure_installed`, so a fresh machine (your Linux box) fails silently.

You asked "is not 2 enough?". I read that as "make it smaller": your autocmd already has its two lines, and this adds three at the end of the callback, a check and a one-time message with the install command. If you meant that the existing two lines are enough, skip this item. What you lose is only the message on a machine without the tool.

<!-- snippet: roslyn_guard -->
```lua
vim.api.nvim_create_autocmd("FileType", {
    pattern = "cs",
    callback = function()
        vim.lsp.enable("roslyn_ls")
        vim.cmd.compiler("dotnet")
        if vim.fn.executable(vim.lsp.config.roslyn_ls.cmd[1]) == 0 then
            vim.notify_once("Install: dotnet tool install -g roslyn-language-server --prerelease", vim.log.levels.WARN)
        end
    end,
})
```

Notes:

- The check uses the command nvim-lspconfig resolved for `roslyn_ls`: `Microsoft.CodeAnalysis.LanguageServer` when that is on `PATH`, otherwise `roslyn-language-server`. The message names the dotnet tool, which is the one you use.
- The server is still enabled when it is missing, so the harmless log error remains on such a machine; the visible message is what changes.
- Do not `return` the result of `vim.notify_once`: an autocmd callback that returns `true` deletes its autocmd, and `vim.notify_once` returns `true` when it shows the message. My first draft did that and later `.cs` buffers lost `compiler dotnet`.
- Mason also has a `roslyn-language-server` package (NuGet), but it would shadow your dotnet-tool version on `PATH`, so I did not suggest adding it to `ensure_installed`.

<a id="item-9"></a>

## 9. LspAttach: on-type formatting

You never register an `LspAttach` handler, so on-type formatting is never switched on. Roslyn supports it (checked on a live server: it advertises `}`, `;` and newline as triggers, and typing `}` reindents the block). It reindents as you type, using your `.editorconfig` through Roslyn. The snippet follows the pattern from `:help vim.lsp.on_type_formatting.enable()` and scopes it to `roslyn_ls`; a bare `vim.lsp.on_type_formatting.enable()` would switch it on for every server that offers it.

You said no folding and no inlay hints, so both are gone from this item, and so are the `<leader>d` toggles that came with them. Three things that are no longer in the snippet but are good to know:

- `:lsp restart` (new in 0.12) restarts the clients when Roslyn gets stuck. No mapping needed.
- `grx` (a 0.12 default) runs a code lens. Showing them needs `vim.lsp.codelens.enable()`; Roslyn's own docs list code lens as a cost on big solutions, because it runs find-references per method, so I left it out.
- Selection ranges: Roslyn supports them, and Neovim 0.12 binds Visual-mode `an` and `in` to them (`:help v_an`). Your mini.ai already maps both keys (around and inside next textobject), so the built-in never fires. The call underneath works on a live Roslyn: `vim.lsp.buf.selection_range(1)` grew an identifier outwards by syntax node (identifier, declarator, declaration) and `selection_range(-1)` shrank it back. Map it to other keys if you want it. (My first version called `an` a free bonus; running the keys showed it is mini.ai's.)

<!-- snippet: lsp_attach -->
```lua
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
        local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
        if client.name == "roslyn_ls" then
            vim.lsp.on_type_formatting.enable(true, { client_id = client.id })
        end
    end,
})
```

<a id="item-10"></a>

## 10. Symbol, reference and call-hierarchy navigation (skipped)

You skipped this. `gO` (default) already lists the document symbols in the location list, and `grr` and `gri` cover references and implementations.

<a id="item-11"></a>

## 11. Roslyn tuning: analysis scope and file watching

You said yes to this one, so it stays as written.

The server settings you inherit from nvim-lspconfig use `fullSolution` background analysis. Roslyn's own "Performance considerations for large solutions" guide lists disabling full solution diagnostics as its first remedy, and a web search turned up reports of slow whole-solution analysis in roslyn.nvim (`seblyng/roslyn.nvim#324`; I could not open that page, so treat it as a pointer). In your setup the extra analysis is also invisible: your refresh override re-pulls diagnostics only for loaded buffers, so nothing from unopened files reaches `vim.diagnostic`. `openFiles` should cut server CPU and memory with no visible loss; items 12-13 cover errors in other projects, because a build reports them.

The second setting stops Neovim from registering file watchers for Roslyn, so the server uses its own. This is exactly what roslyn.nvim's `filewatching = "roslyn"` does. Try it if the UI hitches during `dotnet build` or branch switches.

<!-- snippet: roslyn_tuning -->
```lua
vim.lsp.config("roslyn_ls", {
    settings = {
        ["csharp|background_analysis"] = {
            dotnet_analyzer_diagnostics_scope = "openFiles",
            dotnet_compiler_diagnostics_scope = "openFiles",
        },
    },
    capabilities = {
        workspace = { didChangeWatchedFiles = { dynamicRegistration = false } },
    },
})
```

Notes:

- Verified: the settings deep-merge with nvim-lspconfig's defaults (inlay hint and code lens settings survive, and so does its diagnostic `dynamicRegistration` capability).
- Unverified: the performance effect on your solution. Compare Roslyn's CPU and memory in Task Manager before and after.
- `vim.lsp.buf.workspace_diagnostics()` pulls diagnostics for the whole solution on demand. It may hit the same `bufadd` slowness you patched, so try it on a small solution first.
- With 5.12.0-1.26426.8 `roslyn-language-server --help` lists only `--stdio` and `--pipe`. roslyn.nvim documents a daemon mode that shares one server between several Neovim instances (useful with your worktrees) for newer builds; update the tool and check `--help` if you want to try it.

<a id="item-12-13"></a>

## 12-13. `lua/dotnet.lua`: async build and test runner into quickfix

You asked for these as a `dotnet.lua` file. It is the one exception to your one-file rule. `lua/dotnet.lua` next to `init.lua` is already on the runtimepath, so `require("dotnet")` finds it without any setup, and it loads on first use, so startup does not change. `init.lua` only keeps the key maps.

What it does:

- **Build.** `<leader>tb` builds the nearest `.csproj`, `<leader>tB` the solution. `compiler dotnet` makes `:make` do the same, but `:make` blocks the UI until the build ends. This runs `dotnet build` with `vim.system`, puts the result in quickfix, reports "N errors, M warnings" and opens the list when it has entries. A second press cancels the running build and starts again. For the solution it takes the nearest folder that has a `.sln` or `.slnx`. If there are several, it prefers the one named after the repository (the rule from your `roslyn_ls` `on_init`) and otherwise asks, once per folder and session. Your work repo needs this, because its three solutions sit side by side.
- **Test.** `<leader>tt` (method at cursor) and `<leader>tc` (class at cursor) keep their keys. New: `<leader>tp` runs the whole project and `<leader>tl` re-runs the last test in the same project, from any buffer. The output streams into your floating window. When the run ends the stack frames go to quickfix, so `<M-j>` and `<M-k>` jump to the failing line. `dotnet test` prints `at ... in C:\path\File.cs:38` with MTP and `...File.cs:line 38` with VSTest; both are parsed.

Design points:

- A terminal buffer hard-wraps at the window width, and this codebase has stack frames over 400 characters, so parsing the terminal buffer would lose the long ones. The module streams the process output through pipes, feeds the terminal buffer with `nvim_open_term`, and parses the untouched text at the end. The trade-off is that `dotnet` sees a pipe, not a TTY, so you lose its colors.
- Identical lines are dropped before parsing. With the .NET 10 SDK, `-consoleloggerparameters:NoSummary` no longer suppresses the end-of-build summary, so every diagnostic is printed twice (your `:make` lists each one twice for that reason). For tests this also collapses frames that several failing tests share.
- The float opens in Normal mode (your version enters Terminal mode); `q` closes it, and the output follows the cursor while it sits on the last line. The quickfix list is replaced on every run; `:colder` reaches the previous one.
- `global.json` is now looked up from the project folder, which is where `dotnet` runs, instead of the source file's folder. That only differs when a `global.json` sits between the two, and `dotnet` ignores one there anyway.
- Inside the module the two float maps call `vim.keymap.set` directly, because `map` and `opts` are locals of `init.lua`.

Seen on screen: I pressed `<leader>tp` in a second Neovim running in a terminal, with a stand-in for `dotnet` that prints sample VSTest output (empty rows at the bottom trimmed). The float is 85% of the screen, the footer shows the exit code and how many frames reached quickfix, and `q` closed it:

```text
╭──────────────────────────────────────── Sample.Tests.csproj ─────────────────────────────────────────╮
│Test run for Sample.Tests.dll (.NETCoreApp,Version=v10.0)                                             │
│Starting test execution, please wait...                                                               │
│  Passed Sample.Tests.GreeterTests.Other_Works [3 ms]                                                 │
│  Failed Sample.Tests.GreeterTests.Greet_ReturnsHello [12 ms]                                         │
│  Error Message:                                                                                      │
│   Assert.Equal() Failure: Values differ                                                              │
│   Expected: Hello, Ada                                                                               │
│   Actual:   Hello, Bob                                                                               │
│  Stack Trace:                                                                                        │
│     at Sample.Tests.GreeterTests.Greet_ReturnsHello() in C:\src\Sample.Tests\GreeterTests.cs:line 8  │
│                                                                                                      │
│Failed!  - Failed: 1, Passed: 1, Skipped: 0, Total: 2                                                 │
│                                                                                                      │
│[exit 1] 1 locations in quickfix (<M-j>, <M-k>)                                                       │
╰──────────────────────────────────────────────────────────────────────────────────────────────────────╯
```

In `init.lua`, delete lines 376 to 467, from `local METHOD_MODIFIERS` to the end of the `<leader>tc` map. The module takes over `METHOD_MODIFIERS`, `declared_method_on_line`, `find_test_at_cursor`, `uses_testing_platform` and `run_dotnet_test`, and the first four moved unchanged. Put this in their place. The new `<leader>t` group needs the clue entry from item 4.

<!-- snippet: dotnet_maps -->
```lua
local function dotnet(action)
    return function()
        require("dotnet")[action]()
    end
end
map("n", "<leader>tt", dotnet("test_at_cursor"), opts("Run .NET test at cursor"))
map("n", "<leader>tc", dotnet("test_class_at_cursor"), opts("Run .NET test class at cursor"))
map("n", "<leader>tp", dotnet("test_project"), opts("Run all tests in project"))
map("n", "<leader>tl", dotnet("test_last"), opts("Re-run last .NET test"))
map("n", "<leader>tb", dotnet("build_project"), opts("Build project (async)"))
map("n", "<leader>tB", dotnet("build_solution"), opts("Build solution (async)"))
```

The new file, `.config/nvim/lua/dotnet.lua`:

<!-- snippet: dotnet_module -->
```lua
local M = {}

local ERRORFORMAT = table.concat({
    [[%E%f(%l\,%c):\ %trror\ %m]],
    [[%W%f(%l\,%c):\ %tarning\ %m]],
    [[%*[ ]at\ %m\ in\ %f:line\ %l]],
    [[%*[ ]at\ %m\ in\ %f:%l]],
    [[%-G%.%#]],
}, ",")

local METHOD_MODIFIERS =
    { public = true, private = true, protected = true, internal = true, static = true, async = true }

local build_job
local last_test
local chosen_solution = {}

local function find_upward(pattern)
    return vim.fs.find(function(name)
        return name:match(pattern) ~= nil
    end, { path = vim.fn.expand("%:p:h"), upward = true, type = "file" })[1]
end

local function find_csproj()
    local csproj = find_upward("%.csproj$")
    if not csproj then
        vim.notify("No .csproj found above " .. vim.fn.expand("%:p:h"), vim.log.levels.ERROR)
    end
    return csproj
end

-- Same rule as the roslyn_ls on_init: prefer the solution named after the repository, else ask once.
local function with_solution(callback)
    local nearest = find_upward("%.slnx?$")
    if not nearest then
        return vim.notify("No .sln or .slnx found above " .. vim.fn.expand("%:p:h"), vim.log.levels.ERROR)
    end
    local dir = vim.fs.dirname(nearest)
    if chosen_solution[dir] then
        return callback(chosen_solution[dir])
    end

    local solutions = {}
    for name, kind in vim.fs.dir(dir) do
        if kind == "file" and name:match("%.slnx?$") then
            table.insert(solutions, vim.fs.joinpath(dir, name))
        end
    end
    local function choose(solution)
        chosen_solution[dir] = solution
        callback(solution)
    end
    if #solutions == 1 then
        return choose(solutions[1])
    end
    local repo = vim.fs.basename(vim.fs.root(dir, ".git") or dir):lower()
    for _, solution in ipairs(solutions) do
        if (vim.fs.basename(solution):lower():gsub("%.slnx?$", "")) == repo then
            return choose(solution)
        end
    end
    vim.ui.select(solutions, { prompt = "Solution:", format_item = vim.fs.basename }, function(solution)
        if solution then
            choose(solution)
        end
    end)
end

-- dotnet 10 prints every diagnostic twice, so identical lines are dropped before parsing.
local function to_quickfix(title, text)
    local seen, lines = {}, {}
    for _, line in ipairs(vim.split(text, "\r?\n")) do
        if not seen[line] then
            seen[line] = true
            table.insert(lines, line)
        end
    end
    vim.fn.setqflist({}, " ", { title = title, lines = lines, efm = ERRORFORMAT })
    local counts = { E = 0, W = 0 }
    for _, item in ipairs(vim.fn.getqflist()) do
        local kind = item.type:upper()
        if counts[kind] then
            counts[kind] = counts[kind] + 1
        end
    end
    return counts
end

local function build(target)
    if build_job then
        build_job:kill(15)
    end
    local title = "dotnet build " .. vim.fs.basename(target)
    vim.notify(title)
    local job
    job = vim.system(
        { "dotnet", "build", target, "-nologo", "-consoleloggerparameters:NoSummary" },
        { text = true },
        vim.schedule_wrap(function(res)
            if build_job == job then
                build_job = nil
            end
            if res.signal ~= 0 then
                return
            end
            local counts = to_quickfix(title, (res.stdout or "") .. (res.stderr or ""))
            local level = counts.E > 0 and vim.log.levels.ERROR or vim.log.levels.INFO
            vim.notify(("%s: %d errors, %d warnings"):format(title, counts.E, counts.W), level)
            if counts.E + counts.W > 0 then
                vim.cmd("botright copen")
            end
        end)
    )
    build_job = job
end

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

-- The output is streamed through pipes into a terminal buffer instead of running dotnet in one:
-- a terminal hard-wraps long stack frames, and the full lines are needed for the quickfix list.
local function run_test(csproj, filter)
    last_test = { csproj = csproj, filter = filter }
    local title = filter or vim.fs.basename(csproj)

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
        title = " " .. title .. " ",
        title_pos = "center",
    })

    local command = { "dotnet", "test", csproj }
    if filter then
        vim.list_extend(command, { "--filter", "FullyQualifiedName~" .. filter })
    end
    -- --output and --no-progress are MTP-only; VSTest mode rejects them with MSB1001.
    if uses_testing_platform(vim.fs.dirname(csproj)) then
        vim.list_extend(command, { "--output", "detailed", "--no-progress" })
    else
        vim.list_extend(command, { "--logger", "console;verbosity=detailed" })
    end

    local term = vim.api.nvim_open_term(buf, {})
    local chunks = {}
    local function on_output(_, data)
        if data then
            table.insert(chunks, data)
            vim.schedule(function()
                pcall(vim.api.nvim_chan_send, term, (data:gsub("\r?\n", "\r\n")))
            end)
        end
    end
    vim.system(
        command,
        { cwd = vim.fs.dirname(csproj), text = true, stdout = on_output, stderr = on_output },
        vim.schedule_wrap(function(res)
            to_quickfix("dotnet test " .. title, table.concat(chunks))
            local summary = ("\r\n[exit %d] %d locations in quickfix (<M-j>, <M-k>)\r\n"):format(
                res.code,
                #vim.fn.getqflist()
            )
            pcall(vim.api.nvim_chan_send, term, summary)
        end)
    )
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = buf, silent = true, desc = "Close test window" })
    vim.keymap.set(
        "t",
        "<Esc><Esc>",
        "<C-\\><C-n><cmd>close<CR>",
        { buffer = buf, silent = true, desc = "Close test window" }
    )
end

function M.build_project()
    local csproj = find_csproj()
    if csproj then
        build(csproj)
    end
end

function M.build_solution()
    with_solution(build)
end

function M.test_at_cursor()
    local class_name, method_name = find_test_at_cursor()
    if not method_name then
        return vim.notify("No test method found above cursor", vim.log.levels.WARN)
    end
    local csproj = find_csproj()
    if csproj then
        run_test(csproj, class_name and class_name .. "." .. method_name or method_name)
    end
end

function M.test_class_at_cursor()
    local class_name = find_test_at_cursor()
    if not class_name then
        return vim.notify("No test class found above cursor", vim.log.levels.WARN)
    end
    local csproj = find_csproj()
    if csproj then
        run_test(csproj, class_name)
    end
end

function M.test_project()
    local csproj = find_csproj()
    if csproj then
        run_test(csproj)
    end
end

function M.test_last()
    if not last_test then
        return vim.notify("No .NET test has been run yet", vim.log.levels.WARN)
    end
    run_test(last_test.csproj, last_test.filter)
end

return M
```

<a id="item-14"></a>

## 14. Short paths in the quickfix list

Build and test lists show full paths such as `src/frameworks/<area>/<project>/<folder>/<file>.cs|38 col 5|` and the message is pushed off the edge. You already wrote `shorten_pick_path` for mini.pick; reuse it so the quickfix list shows `./<csproj dir>/./File.cs|38 col 5| message`. Define this after `shorten_pick_path` in the Plugins section.

<!-- snippet: qf_text -->
```lua
function _G.qf_text(info)
    local list
    if info.quickfix == 1 then
        list = vim.fn.getqflist({ id = info.id, items = 1 })
    else
        list = vim.fn.getloclist(info.winid, { id = info.id, items = 1 })
    end
    local lines = {}
    for i = info.start_idx, info.end_idx do
        local item = list.items[i]
        local name = item.bufnr > 0 and shorten_pick_path(vim.fn.bufname(item.bufnr), vim.fn.getcwd()) or ""
        local pos = item.lnum > 0 and ("%d col %d"):format(item.lnum, item.col) or ""
        lines[#lines + 1] = ("%s|%s| %s"):format(name, pos, (item.text:gsub("%s*\n%s*", " ")))
    end
    return lines
end
vim.o.quickfixtextfunc = "v:lua.qf_text"
```

<a id="item-15"></a>

## 15. Format only the changed hunks

`grf` formats the whole buffer. In a repo with an enforced style but a few legacy files, that produces noisy diffs. Roslyn advertises range formatting (verified), and mini.diff already knows your hunks. This formats only the lines you changed, bottom to top so line numbers stay valid.

<!-- snippet: format_hunks -->
```lua
local function format_changed_hunks()
    local data = MiniDiff.get_buf_data(0)
    if not data then
        return vim.notify("mini.diff is not attached to this buffer", vim.log.levels.WARN)
    end
    local hunks = vim.tbl_filter(function(hunk)
        return hunk.buf_count > 0
    end, data.hunks)
    for i = #hunks, 1, -1 do
        local first = hunks[i].buf_start
        local last = first + hunks[i].buf_count - 1
        vim.lsp.buf.format({
            async = false,
            range = { start = { first, 0 }, ["end"] = { last, #vim.fn.getline(last) } },
        })
    end
end
map("n", "<leader>gf", format_changed_hunks, opts("Format changed hunks"))
```

Notes: verified against Roslyn with a file that has one badly formatted line inside a hunk and one outside; only the first is touched. Deleted-only hunks are skipped.

<a id="item-16"></a>

## 16. Wire up stylua and shfmt, with range support

`stylua`, `prettierd` and `shfmt` are in `ensure_installed` but nothing calls them, and your own rule says "don't run stylua on the whole file; it rewrites unrelated lines". `stylua` has `--range-start` and `--range-end`, so a visual-mode format can touch only the selection. This replaces `grf` (it falls back to `vim.lsp.buf.format`, also with a range, for every other filetype, so C# keeps using Roslyn). It writes back only the changed middle of the buffer, so marks and folds outside it survive. This is local Lua in the spirit of your header. If you prefer a plugin, `conform.nvim` does the same with `range_args` and `lsp_format = "fallback"`.

<!-- snippet: formatters -->
```lua
local function byte_offset(lines, row)
    local offset = 0
    for i = 1, row - 1 do
        offset = offset + #lines[i] + 1
    end
    return offset
end

local formatters = {
    lua = {
        cmd = { "stylua", "--search-parent-directories", "--stdin-filepath", "$FILE", "-" },
        range_args = function(lines, first, last)
            return { "--range-start", byte_offset(lines, first), "--range-end", byte_offset(lines, last + 1) }
        end,
    },
    sh = { cmd = { "shfmt", "-filename", "$FILE" } },
}

local function replace_changed(buf, old, new)
    local first = 1
    while first <= #old and first <= #new and old[first] == new[first] do
        first = first + 1
    end
    local last_old, last_new = #old, #new
    while last_old >= first and last_new >= first and old[last_old] == new[last_new] do
        last_old, last_new = last_old - 1, last_new - 1
    end
    if first > last_old and first > last_new then
        return
    end
    vim.api.nvim_buf_set_lines(buf, first - 1, last_old, false, vim.list_slice(new, first, last_new))
end

local function format_buffer()
    local first, last
    if vim.fn.mode():match("^[vV\22]") then
        first, last = vim.fn.line("v"), vim.fn.line(".")
        first, last = math.min(first, last), math.max(first, last)
        vim.cmd("normal! \27")
    end
    local formatter = formatters[vim.bo.filetype]
    if not formatter then
        local range = first and { start = { first, 0 }, ["end"] = { last, #vim.fn.getline(last) } }
        return vim.lsp.buf.format({ range = range })
    end

    local buf = vim.api.nvim_get_current_buf()
    local old = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    local cmd = vim.tbl_map(function(arg)
        return arg == "$FILE" and vim.api.nvim_buf_get_name(buf) or arg
    end, formatter.cmd)
    cmd[1] = vim.fn.exepath(cmd[1])
    if first and formatter.range_args then
        vim.list_extend(cmd, formatter.range_args(old, first, last))
    end
    local res = vim.system(cmd, { stdin = table.concat(old, "\n") .. "\n", text = true }):wait()
    if res.code ~= 0 then
        return vim.notify(res.stderr, vim.log.levels.ERROR)
    end
    local new = vim.split(res.stdout, "\n", { plain = true })
    if new[#new] == "" then
        table.remove(new)
    end
    replace_changed(buf, old, new)
end
map({ "n", "x" }, "grf", format_buffer, opts("Format buffer or selection"))
```

Notes:

- `vim.fn.exepath` resolves Mason's `.cmd` shims on Windows.
- `shfmt` has no range option, so a visual-mode format on a shell file formats the whole file.
- Verified against the real `stylua` on a file where only line 2 was selected: lines 1 and 3 stay unformatted.

<a id="item-17"></a>

## 17. TODO and FIXME highlighting and picker

mini.hipatterns is already configured (hex colors, markdown). `mini.extra` ships a `words` highlighter and a picker over the matches. Add these entries to your existing `hipatterns.setup({ highlighters = { ... } })` call, plus the mapping. `NOTE` is left out on purpose: it would also match your `[!NOTE]` callouts.

<!-- snippet: hipatterns_words -->
```lua
local words = require("mini.extra").gen_highlighter.words
hipatterns.setup({
    highlighters = {
        fixme = words({ "FIXME", "HACK" }, "MiniHipatternsFixme"),
        todo = words({ "TODO" }, "MiniHipatternsTodo"),
    },
})

map("n", "<leader>fn", "<cmd>Pick hipatterns highlighters={'fixme','todo'}<cr>", opts("Find TODO and FIXME"))
```

<a id="item-18"></a>

## 18. Wiki pickers

`<leader>ww`, `wj` and `wc` open fixed files, and `<leader>ft` greps tags, but only inside the wiki after you `:lcd` there. Finding or grepping a note from any project needs separate mappings: two for the personal wiki and two for the work wiki. They use the `wiki` and `work_wiki` locals you already have.

<!-- snippet: wiki_pickers -->
```lua
local function wiki_pick(picker, root)
    return function()
        MiniPick.builtin[picker](nil, { source = { cwd = root } })
    end
end
map("n", "<leader>wf", wiki_pick("files", wiki), opts("Find wiki file"))
map("n", "<leader>ws", wiki_pick("grep_live", wiki), opts("Search wiki"))
map("n", "<leader>wF", wiki_pick("files", work_wiki), opts("Find work wiki file"))
map("n", "<leader>wS", wiki_pick("grep_live", work_wiki), opts("Search work wiki"))
```

<a id="item-19"></a>

## 19. The `<C-s>` terminal opens `cmd.exe`

`vim.o.shell` is `cmd.exe` (checked), so `<C-s>` and `<C-space>` give you a `cmd.exe` prompt without your PowerShell profile (`testall`, `tapp`, aliases). If that is on purpose, skip this. The smallest change is to name `pwsh` in the two terminal mappings. The full alternative sets `pwsh` as `shell` (the settings come from `:h shell-pwsh`), which also changes `:!`, `:make` and string `system()`, at the cost of about 0.4 s PowerShell startup per such call (measured 355 to 476 ms against about 40 ms for `cmd.exe`). Your list-form `systemlist({...})` and `vim.system` calls do not use a shell and are unaffected.

<!-- snippet: pwsh_terminal -->
```lua
map("n", "<C-space>", "<cmd>terminal pwsh<CR>", opts("Open terminal"))
map({ "n", "t" }, "<C-s>", terminal_toggle("pwsh"), opts("Toggle terminal"))
```

<!-- snippet: pwsh_shell -->
```lua
if vim.fn.has("win32") == 1 and vim.fn.executable("pwsh") == 1 then
    vim.o.shell = "pwsh"
    vim.o.shellcmdflag = table.concat({
        "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command ",
        "[Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();",
        "$PSDefaultParameterValues['Out-File:Encoding']='utf8';",
        "$PSStyle.OutputRendering='PlainText';",
    })
    vim.o.shellpipe = "> %s 2>&1"
    vim.o.shellquote = ""
    vim.o.shellxquote = ""
    vim.env.__SuppressAnsiEscapeSequences = 1
end
```

<a id="item-20"></a>

## 20. Prune stale sessions

`<leader>ss` lists 70 sessions, 24 of which point at folders that no longer exist (removed worktrees, `%TEMP%` test runs). The first `cd` line of a session file is its folder, so stale ones are easy to find. `:SessionsPrune` only lists; `:SessionsPrune!` deletes. The dry run of this exact command against your session folder reported 24, the same number a separate PowerShell check found.

<!-- snippet: sessions_prune -->
```lua
vim.api.nvim_create_user_command("SessionsPrune", function(cmd)
    local stale = {}
    for name, session in pairs(MiniSessions.detected) do
        local line = vim.iter(vim.fn.readfile(session.path, "", 30)):find(function(l)
            return l:match("^cd ")
        end)
        local dir = line and vim.fs.normalize((line:gsub("^cd ", ""):gsub("\\ ", " ")))
        if dir and not vim.uv.fs_stat(dir) then
            table.insert(stale, name)
        end
    end
    table.sort(stale)
    if not cmd.bang then
        local list = table.concat(stale, "\n")
        return vim.notify(("%d stale sessions (:SessionsPrune! deletes them):\n%s"):format(#stale, list))
    end
    for _, name in ipairs(stale) do
        MiniSessions.delete(name, { force = true })
    end
end, { bang = true, desc = "List or delete sessions whose folder no longer exists" })
```

Notes: a session whose folder is on an unreachable network share can make the check slow, because `fs_stat` waits for the share. I did not delete anything.

<a id="item-21"></a>

## 21. Native sessions (your TODO)

Honest verdict: not worth doing on its own. MiniSessions is one module of a plugin you already install, and the startup cost you would save is its `require` parse, which `vim.loader` already removes (item 1). Do it if you want one dependency fewer or want to own the behavior. The version below covers everything you use: write on exit per working directory, load the latest, select, and restart. It also makes the restart native: `:restart` takes a command, which is the documented way to "restart and restore the current session".

<!-- snippet: sessions_native -->
```lua
local session_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "session")
vim.fn.mkdir(session_dir, "p")

local function session_path(name)
    return vim.fs.joinpath(session_dir, name .. ".vim")
end

local function session_write(name)
    local path = session_path(name or vim.fs.basename(vim.fn.getcwd()))
    vim.cmd.mksession({ args = { vim.fn.fnameescape(path) }, bang = true })
    return path
end

local function session_list()
    local sessions = {}
    for file, kind in vim.fs.dir(session_dir) do
        if kind == "file" and vim.endswith(file, ".vim") then
            local name = file:sub(1, -5)
            table.insert(sessions, { name = name, mtime = vim.uv.fs_stat(session_path(name)).mtime.sec })
        end
    end
    table.sort(sessions, function(a, b)
        return a.mtime > b.mtime
    end)
    return vim.tbl_map(function(session)
        return session.name
    end, sessions)
end

local function session_read(name)
    vim.cmd.source(vim.fn.fnameescape(session_path(name)))
end

map("n", "<leader>sl", function()
    local latest = session_list()[1]
    if latest then
        session_read(latest)
    end
end, opts("Load last session"))
map("n", "<leader>ss", function()
    vim.ui.select(session_list(), { prompt = "Session:" }, function(name)
        if name then
            session_read(name)
        end
    end)
end, opts("Select session"))
map("n", "<leader>er", function()
    local path = vim.fs.joinpath(vim.fn.stdpath("data"), "restart_session.vim")
    vim.cmd(("mksession! %s | restart source %s"):format(vim.fn.fnameescape(path), vim.fn.fnameescape(path)))
end, opts("Restart nvim"))
```

In the `VimLeavePre` autocmd, replace the `MiniSessions.write(...)` line with `session_write()`, and drop `require("mini.sessions").setup({})`. `session_write`, `session_list` and `session_read` ran in a temporary data directory. `:restart` is UI-bound and was not run.

<a id="item-22"></a>

## 22. Copilot inline: previous, partial accept, toggle

You have accept (`<M-l>`) and next (`<M-]>`). Missing: previous, accepting only the next word or the first line, and an on/off switch. `get()` takes an `on_accept` callback that may return a modified item, which is the documented way to implement partial accept; the accept code then replaces the item's range with the shortened text, so it behaves like a normal accept. Snippet-kind items are accepted whole.

<!-- snippet: copilot_inline -->
```lua
map("i", "<M-[>", function()
    vim.lsp.inline_completion.select({ count = -1 })
end, opts("Previous Copilot suggestion"))

local function accept_inline(patterns)
    return function()
        return vim.lsp.inline_completion.get({
            on_accept = function(item)
                if type(item.insert_text) == "string" then
                    for _, pattern in ipairs(patterns) do
                        local part = item.insert_text:match(pattern)
                        if part then
                            item.insert_text = part
                            break
                        end
                    end
                end
                return item
            end,
        })
    end
end
map("i", "<M-w>", accept_inline({ "^%s*[%w_]+", "^%s*%p+" }), opts("Accept next Copilot word"))
map("i", "<M-e>", accept_inline({ "^[^\n]*" }), opts("Accept first Copilot line"))

map("n", "<leader>it", function()
    vim.lsp.inline_completion.enable(not vim.lsp.inline_completion.is_enabled())
end, opts("Toggle Copilot suggestions"))
```

Notes: `<M-w>`, `<M-e>` and `<leader>it` are free. Verified against an in-process fake inline-completion server: the whole suggestion, the first word and the first line each land correctly in the buffer.

<a id="item-23"></a>

## 23. Copilot CLI: send diagnostics and quickfix

Your `<leader>ia` and `<leader>ip` already send `@file` references and selections. Two natural additions: the diagnostics on the current line ("fix this"), and the first locations of the quickfix list after a failed build or test run (items 12-13 fill that list). Both send one line without a newline, so nothing is submitted until you press Enter. `copilot_send` also replaces the duplicated "defer 3 seconds then chansend" in `<leader>ia`; the 3000 ms is a guess that is too slow on a warm start and too fast on a cold one.

<!-- snippet: copilot_cli -->
```lua
local function copilot_send(text)
    local chan, started = copilot_open()
    vim.defer_fn(function()
        vim.fn.chansend(chan, text)
    end, started and 3000 or 0)
    vim.cmd("startinsert")
end

local function one_line(text)
    return (text:gsub("%s*\n%s*", " "))
end

map("n", "<leader>id", function()
    local line = vim.fn.line(".")
    local diagnostics = vim.diagnostic.get(0, { lnum = line - 1 })
    if #diagnostics == 0 then
        return vim.notify("No diagnostics on this line", vim.log.levels.INFO)
    end
    local messages = vim.tbl_map(function(diagnostic)
        return one_line(diagnostic.message)
    end, diagnostics)
    local file = vim.fs.normalize(vim.fn.expand("%:."))
    copilot_send(("Fix @%s line %d: %s "):format(file, line, table.concat(messages, "; ")))
end, opts("Send line diagnostics to Copilot CLI"))

map("n", "<leader>iq", function()
    local items = vim.iter(vim.fn.getqflist())
        :filter(function(item)
            return item.valid == 1 and item.bufnr > 0
        end)
        :take(10)
        :totable()
    if #items == 0 then
        return vim.notify("Quickfix list has no locations", vim.log.levels.INFO)
    end
    local refs = vim.tbl_map(function(item)
        local file = vim.fs.normalize(vim.fn.fnamemodify(vim.fn.bufname(item.bufnr), ":."))
        return ("@%s line %d"):format(file, item.lnum)
    end, items)
    copilot_send("Investigate " .. table.concat(refs, ", ") .. " ")
end, opts("Send quickfix locations to Copilot CLI"))
```

Notes: the message building ran against stubbed terminal functions. The terminal hand-off itself is the same pattern as your existing `<leader>ia` and was not run.

<a id="item-24"></a>

## 24. Treesitter parsers (decision)

Without parsers, C#, Python, bash, PowerShell, JSON and YAML use Vim's regex syntax files. For C# that is covered by Roslyn semantic tokens once the server is ready, which may take a while on a large solution, and until then the file has the older highlighting. The `main` branch of nvim-treesitter is the maintained one and needs Neovim 0.12, which you have. It needs `tar` and `curl`, a C compiler (you have mingw `gcc`), and `tree-sitter-cli` 0.26.1 or newer from a package manager, not npm; Mason has `tree-sitter-cli` (checked in the registry). It does not support lazy loading and does not turn highlighting on by itself.

This is a plugin you would add, and you asked to be asked first, so I did not install it. Treat it as a small spike: add `tree-sitter-cli` to `ensure_installed`, run `:MasonToolsInstall`, then try the block below. If parser builds fail on Windows, the usual fix is `CC=gcc` in the environment; I could not check whether the tree-sitter CLI picks mingw `gcc` on your machine.

<!-- snippet: treesitter -->
```lua
vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
        local data = ev.data
        if data.spec.name == "nvim-treesitter" and (data.kind == "install" or data.kind == "update") then
            if not data.active then
                vim.cmd.packadd("nvim-treesitter")
            end
            vim.cmd("TSUpdate")
        end
    end,
})
vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter" })

require("nvim-treesitter").install({
    "c_sharp", "python", "bash", "powershell", "json", "yaml", "toml", "xml",
    "typst", "sql", "regex", "diff", "gitcommit", "cpp",
})

vim.api.nvim_create_autocmd("FileType", {
    callback = function(ev)
        pcall(vim.treesitter.start, ev.buf)
    end,
})
```

Notes: unverified because it installs a plugin and a CLI. Tree-sitter text objects for `mini.ai` need `nvim-treesitter-textobjects` as well; I would skip that.

<a id="item-25"></a>

## 25. Home setup: Linux and more languages

- **Python.** `pylsp` works but is slow and needs plugins for most checks. `ruff` (lint and format) plus `basedpyright` (types) are both in the Mason registry (checked). Adding the Mason names to `ensure_installed` is enough, because `mason-lspconfig` defaults to `automatic_enable`.
- **Other servers in the registry** (checked): `gopls`, `rust-analyzer`, `json-lsp`, `yaml-language-server`, `taplo`, `vtsls`, `marksman`.
- **Clipboard.** `clipboard=unnamedplus` needs a clipboard tool on Linux (`wl-clipboard` or `xclip`). Without one, Neovim reports `clipboard: No clipboard tool` (message text from `provider/clipboard.vim`). The guard below sets it only when a provider exists; `has("clipboard")` is 1 on your Windows box. Over SSH, Neovim does not use OSC 52 while `clipboard` is set (comment in the same file); `vim.g.clipboard = "osc52"` opts in, which I did not test.
- **Debug and formatters** are items 26 and 16.

<!-- snippet: home_setup -->
```lua
-- add to mason-tool-installer `ensure_installed`
"ruff", "basedpyright", "gopls", "rust-analyzer", "json-lsp", "yaml-language-server", "taplo",

-- replace `vim.opt.clipboard = "unnamedplus"`
if vim.fn.has("clipboard") == 1 then
    vim.opt.clipboard = "unnamedplus"
end
```

Notes: server installs were not run. The first block is only a list of strings.

<a id="item-26"></a>

## 26. Debugging (decision)

For C# at work you have Rider, and `nvim-dap` plus `netcoredbg` means three more plugins and an adapter config for something you will not use there. For C and C++ at home, Neovim ships `termdebug`, a GDB front end, so no plugin is needed. If you later want DAP anyway, `netcoredbg`, `debugpy` and `codelldb` are all in the Mason registry.

<!-- snippet: termdebug -->
```lua
vim.cmd.packadd("termdebug")
```

Then use `:Termdebug <program>`. `:help termdebug` has the commands.

<a id="item-27"></a>

## 27. Small cleanups

- `vim.treesitter.start(args.buf)` in the markdown `FileType` autocmd is redundant: `ftplugin/markdown.lua` in 0.12 already calls it. Keep the `opt_local` lines.
- `pick_recent_files` runs `git diff --name-only` without `core.quotePath=false`, unlike your review code. A file such as `åäö.md` comes back quoted and escaped, the `fs_stat` fails, and it silently drops out of the picker. Verified with a temporary Git repository: the default output was `"\303\245\303\244\303\266.md"` and `fs_stat` failed on it; the fixed command returned the real name.
- `.luarc.json` `diagnostics.globals` lacks `MiniDiff`, `MiniVisits`, `MiniExtra`, `MiniIcons`, `MiniGit`, `MiniHipatterns`.
- Your header TODOs: `mini.git?` is item 6; "Replace mini.sessions with native" is item 21 with its verdict.
- The log shows mini.snippets "cannot find request with id N" errors (about 80). They are noise from its in-process server and harmless.
- `vim.wo.diff` check in your restore-cursor autocmd is a good detail. `MiniMisc.setup_restore_cursor()` would replace the rest, but it has no diff check, so keep yours.

<!-- snippet: quotepath -->
```lua
local files = root
    and vim.fn.systemlist({
        "git", "-c", "core.quotePath=false", "-C", root,
        "diff", "--name-only", "--merge-base", "origin/HEAD",
    })
```

Do the same for the `ls-files --others` call a few lines below: add `"-c", "core.quotePath=false"` after `"git"`.

<a id="item-28"></a>

## 28. Considered and not recommended

- **blink.cmp, nvim-cmp, copilot.vim, CopilotChat**: ruled out by your own rules, and the native path already works.
- **roslyn.nvim**: nvim-lspconfig's `roslyn_ls` plus your `on_init` covers solution choice. roslyn.nvim adds multi-solution switching, source-generated documents and a daemon mode. Revisit if you hit those.
- **easy-dotnet.nvim** and **neotest**: you have the `easydotnet` backend installed globally, so you probably tried it. Items 12-13 give you the part you actually use (build and test into quickfix) in one file of about 260 lines and no dependency.
- **A `checktime` autocmd**: not needed. `autoread` reloaded an externally edited file as soon as the buffer was re-entered (checked).
- **Terminal buffers in sessions**: I suspected restored terminals would respawn `copilot`. None of the 70 session files contains a terminal buffer.
- **Lazy-loading plugins**: startup is about 155 ms, and `vim.loader` gives more than lazy loading would.
- **mini.pairs, mini.statusline, mini.starter, mini.animate**: matters of taste. You wrote your own statusline, and I did not see a need for the others.
- **Splitting `init.lua`**: your rule is one file, and I respected it. If you ever relax it, MiniMax's `plugin/10_options.lua` to `40_plugins.lua` layout is the model.

## Verification notes

How the checks were run:

- Every block tagged `<!-- snippet: name -->` in this file, except the tree-sitter one (item 24), was extracted programmatically and either executed in headless Neovim 0.12.2 or, for the string list in item 25, parsed. So what is documented is what ran, and the extracted `lua/dotnet.lua` is byte for byte the file that was tested. The environments were: a clean `-u NONE` session with mini.nvim and nvim-lspconfig on the runtimepath; your real config (Roslyn and Copilot items, against a small sample C# project); a child Neovim driven over RPC (inline completion, because a headless Neovim does not process typed keys while a script is running); and a Neovim inside a terminal buffer of another Neovim, to read what the screen draws (items 1, 3 and 12-13).
- 41 checks in 9 scripts, all run again for this version. The last run of every check passed. All code blocks changed in this version that are whole Lua (items 3, 6, 8, 9 and 12-13) are also clean under `stylua` with your `.stylua.toml`.
- Nothing was installed. Native sessions ran with `XDG_DATA_HOME` pointed at a temporary folder, and `:SessionsPrune` ran in dry-run mode only. Your config, plugins and lock file were not touched.

Bugs and wrong claims the checks found in my own drafts (all fixed above):

- Quickfix type letters come back lowercase, so the error and warning counters read 0, and every diagnostic appeared twice (items 12-13).
- `return vim.notify_once(...)` in an autocmd callback deleted the autocmd, so later `.cs` buffers lost `compiler dotnet` (item 8).
- A formatter run with no changes still marked the buffer modified (item 16).
- `jump = { float = true }`, which I first wrote from memory, is not a 0.12 option (item 3).
- The first build code let a cancelled build clear the handle of the build that replaced it. A third press then could not cancel the second build, so both of those builds finished and wrote to quickfix. Reproduced against that draft (two completions, the older build's result last) and fixed (one completion, the newest result).
- "Re-run last test" in that draft kept only the filter, so from a file in another project it ran the old filter in the wrong project. It now remembers the project too (checked from a second project).
- "The nearest `.sln`" would pick the wrong solution in a folder that holds several. The build now uses your `on_init` rule (checked with one, three and two solutions).
- I wrote that mini.pick shows no icons without `MiniIcons`. It shows one fixed glyph (item 6).
- I called Visual-mode `an` and `in` a free bonus. In your config mini.ai owns them (item 9).

Not seen or not run:

- The Nerd Font glyphs of mini.icons on screen (a text capture cannot show them), the statusline in a real UI (only its evaluated string was checked), and `:restart`.
- Any change in Roslyn CPU or memory from item 11.
- The real `dotnet test`. Items 12-13 ran against a stand-in for `dotnet` that prints test output (VSTest and MTP forms), plus your real `test-output.log` for the errorformat and long frames. The `dotnet build` ran for real. The completion window in item 1 was drawn from a stand-in LSP server; the documentation text itself came from a live Roslyn.
- Item 8's "missing server" case was simulated by removing the tool from `PATH` for the test.
- Installing nvim-treesitter or any language server (items 24 and 25).

## Sources

- Neovim 0.12 runtime docs on your machine: `:help news`, `lsp.txt`, `diagnostic.txt`, `options.txt`, `pack.txt`; the Lua sources `lsp/completion.lua` and `lsp/inline_completion.lua` for the behavior cited in items 1 and 22.
- mini.nvim sources in your plugin folder (`pick.lua`, `files.lua`, `git.lua`, `extra.lua`): the behavior cited in items 3 and 6.
- Roslyn, "Performance considerations for large solutions": https://github.com/dotnet/roslyn/blob/main/docs/wiki/Performance-considerations-for-large-solutions.md
- roslyn.nvim README (file watching, daemon mode): https://github.com/seblyng/roslyn.nvim
- nvim-treesitter `main` README (requirements): https://github.com/nvim-treesitter/nvim-treesitter
- MiniMax `nvim-0.12` config (leader groups, LSP and diagnostic pickers): https://nvim-mini.org/MiniMax/configs/nvim-0.12/
- sidekick.nvim README (idea: send diagnostics and quickfix as Copilot CLI context): https://github.com/folke/sidekick.nvim
- VS Code GitHub Copilot docs (default `github.copilot.enable`): https://code.visualstudio.com/docs/editor/github-copilot
