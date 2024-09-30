return {
	-- status bar
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			vim.g.gitblame_display_virtual_text = 0 -- Disable virtual text
			local git_blame = require("gitblame")

			require("lualine").setup({
				sections = {
					lualine_c = {
						{ git_blame.get_current_blame_text, cond = git_blame.is_blame_text_available },
					},
					lualine_x = {
						"filename",
					},
					lualine_y = {
						"encoding",
						"fileformat",
						"filetype",
					},
					lualine_z = {
						"progress",
						"location",
					},
				},
			})

			require("lualine").setup({
				options = {
					theme = "auto",
				},
			})
		end,
	},
}
