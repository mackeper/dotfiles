return {
	'nvim-telescope/telescope.nvim', tag = '0.1.4',
	dependencies = { 'nvim-lua/plenary.nvim'},
	config = function()
		local builtin = require('telescope.builtin')
		vim.keymap.set('n', '<leader>jf', builtin.find_files, {})
		vim.keymap.set('n', '<leader>jg', builtin.live_grep, {})
		vim.keymap.set('n', '<C-j>', builtin.git_files, {})
		vim.keymap.set('n', '<leader>js', function()
			builtin.grep_string({ search = vim.fn.input("grep > ") })
		end)
	end
}
