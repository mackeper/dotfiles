local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local d = ls.dynamic_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

return {
   s("header", {
    d(1, function()
      return sn(nil, {
        f(function(args)
          local text = args[1][1]
          local total_width = 40
          local border = string.rep("=", total_width)
          local text_len = #text
          local padding = math.floor((total_width - text_len) / 2)
          local left_pad = string.rep(" ", padding)
          return {
            "# " .. border,
            "#" .. left_pad .. text,
            "# " .. border
          }
        end, {1}),
        t({"", ""}),
        i(1, "Text")
      })
    end)
  }),
  s("box", {
    d(1, function()
      return sn(nil, {
        f(function(args)
          local text = args[1][1]
          local len = #text
          return "┌" .. string.rep("─", len + 2) .. "┐"
        end, {1}),
        t({"", "│ "}),
        i(1, "Text"),
        t({" │", ""}),
        f(function(args)
          local text = args[1][1]
          local len = #text
          return "└" .. string.rep("─", len + 2) .. "┘"
        end, {1}),
        t({"", ""}),
        i(2)
      })
    end)
  })
}
