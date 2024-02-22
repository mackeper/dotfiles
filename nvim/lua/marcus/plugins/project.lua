return {
	"ahmedkhalf/project.nvim",
	lazy = true,
	event = "VeryLazy",
	config = function()
		require("project_nvim").setup({
			patterns = {
				".git",
				"_darcs",
				".hg",
				".bzr",
				".svn",
				"Makefile",
				"package.json",
				"Cargo.toml",
				"Stack.yaml",
				".cabal",
			},
		})
	end,
}
