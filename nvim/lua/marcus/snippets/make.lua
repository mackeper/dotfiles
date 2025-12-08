local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s("header", {
    t("@echo \"\\n=== "), i(1, "Title"), t(" ===\"")
  }),
}
