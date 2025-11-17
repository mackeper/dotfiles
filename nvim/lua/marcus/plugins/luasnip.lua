return {
    "L3MON4D3/LuaSnip",
    enabled = true,
    -- event = { "BufReadPost", "BufNewFile" },
    event = { "VeryLazy" },
    config = function()
        require("luasnip")
        local ls_vs_loader = require("luasnip.loaders.from_vscode")
        local ls_lua_loader = require("luasnip.loaders.from_lua")
        ls_lua_loader.lazy_load({ paths = { "./lua/marcus/snippets" } })
        ls_vs_loader.lazy_load()
        ls_vs_loader.lazy_load({ paths = { "./lua/marcus/snippets" } })
    end,
}
