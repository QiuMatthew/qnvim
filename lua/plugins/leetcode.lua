return {
	-- Leetcode
	{
		"kawre/leetcode.nvim",
		build = ":TSUpdate html",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"nvim-lua/plenary.nvim", -- required by telescope
			"MunifTanjim/nui.nvim",

			-- optional
			"nvim-treesitter/nvim-treesitter",
			"rcarriga/nvim-notify",
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			-- configuration goes here
			arg = "leetcode", -- run `nvim leetcode` to launch

			cn = { -- leetcode.cn
				enabled = false, ---@type boolean
				translator = true, ---@type boolean
				translate_problems = true, ---@type boolean
			},

			storage = {
				home = "~/Projects/LeetCode/nvim", -- where to save all written code
			},
		},
		configure = {
			vim.keymap.set("n", "<leader>lr", ":Leet run<CR>"),
			vim.keymap.set("n", "<leader>lt", ":Leet test<CR>"),
			vim.keymap.set("n", "<leader>ls", ":Leet submit<CR>"),
		},
	},
}
