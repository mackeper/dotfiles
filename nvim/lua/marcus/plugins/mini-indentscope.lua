return {
    'echasnovski/mini.indentscope',
    version = '*',
    lazy = true,
    event = 'VeryLazy',
    config = function()
        require('mini.indentscope').setup({
            symbol = '▏',
        })
    end,
}
