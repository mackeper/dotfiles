local ls = require("luasnip")
local snippets = {}
local snippet = ls.snippet
local text = ls.text_node
local insert = ls.insert_node
local func = ls.function_node

return {
    snippet("fnlua", {
        text("function "),
        insert(1, "name"),
        text("("),
        insert(2),
        text({ ") ", "\t" }),
        insert(0),
        text({ "", "end" }),
    }),
}
