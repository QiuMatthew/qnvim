return {
	-- status bar
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		require("lualine").setup({
			options = {
				theme = "auto",
			},
		}),
	},
}
