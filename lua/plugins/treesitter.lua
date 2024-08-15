---@diagnostic disable: missing-fields
return {
	-- treesitter for syntax highlight
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "vim", "bash", "c", "cpp", "javascript", "json", "lua", "python", "go" },
				sync_install = false,
				auto_install = true,
				ignore_install = {},

				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},
}
