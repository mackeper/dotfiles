return {
    'gelguy/wilder.nvim',
    config = function()
        local wilder = require('wilder')
        wilder.setup({modes = {':', '/', '?'}})
        wilder.set_option('use_python_remote_plugin', 0)

        wilder.set_option('pipeline', {
            wilder.branch(
                wilder.cmdline_pipeline(),
                wilder.search_pipeline()
            ),
        })

        wilder.set_option('renderer', wilder.popupmenu_renderer(
            wilder.popupmenu_border_theme({
                highlighter = wilder.basic_highlighter(),
                border = "rounded",
                left = {' ', wilder.popupmenu_devicons()},
                right = {' ', wilder.popupmenu_scrollbar()},
            })
        ))
    end,
}
