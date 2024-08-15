return {
	-- file tree
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		configure = {
			vim.keymap.set("n", "<leader>e", ":Neotree reveal=true toggle=true position=left <CR>"),
		},
	},
}
