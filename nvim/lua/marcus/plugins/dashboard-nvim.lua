return {
    'nvimdev/dashboard-nvim',
    lazy = true,
    event = 'VimEnter',
    dependencies = {
        { 'nvim-tree/nvim-web-devicons' },
    },
    config = function()
        require('dashboard').setup {
            theme = 'hyper',
            disable_move = true,
            config = {
                week_header = {
                    enable = true,
                },
                shortcut = {
                    {
                        desc = 'Update',
                        group = '@property',
                        action = 'Lazy update',
                        key = 'u',
                        icon = '󰊳',
                    },
                    {
                        icon_hl = '@variable',
                        desc = 'Files',
                        group = 'Label',
                        action = 'Telescope find_files',
                        key = 'f',
                        icon = ' ',
                    },
                    {
                        desc = 'Apps',
                        group = 'DiagnosticHint',
                        action = 'Telescope app',
                        key = 'a',
                        icon = ' ',
                    },
                    {
                        desc = 'dotfiles',
                        group = 'Number',
                        action = 'Telescope dotfiles',
                        key = 'd',
                        icon = ' ',
                    },
                    {
                        desc = 'Config',
                        group = 'Number',
                        action = function()
                            vim.cmd('cd ' .. vim.fn.stdpath('config'))
                            require('telescope.builtin').find_files({cwd = vim.fn.stdpath('config')});
                        end,
                        key = 'c',
                        icon = ' ',
                    },
                },
                footer = {
                    '❤',
                },
            },
        }
    end,
}
