return {
	'nvim-telescope/telescope.nvim', tag = '0.1.4',
	dependencies = { 'nvim-lua/plenary.nvim'},
	config = function()
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>jf', builtin.find_files, { desc = 'Find files' })
        vim.keymap.set('n', '<leader>jg', builtin.live_grep, { desc = 'Live grep' })
        vim.keymap.set('n', '<leader>jr', builtin.git_files, { desc = 'Git files' })
        vim.keymap.set('n', '<leader>jm', builtin.oldfiles, { desc = 'Recent files' })
        vim.keymap.set('n', '<leader>jb', builtin.buffers, { desc = 'Buffers' })
    end
}
