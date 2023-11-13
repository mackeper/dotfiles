return {
    'echasnovski/mini.comment',
    version = '*',
    lazy = true,
    event = 'VeryLazy',
    config = function()
        require('mini.comment').setup({
            mappings = {
                comment = '<C-_>',
                comment_line = '<C-_>',
                comment_visual = '<C-_>',
                textobject = '',
            },
        })
    end,
}
