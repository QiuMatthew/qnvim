return {
	{
		"xeluxee/competitest.nvim",
		dependencies = "MunifTanjim/nui.nvim",
		config = function()
			require("competitest").setup({
				template_file = {
					cpp = "~/Projects/CompetitiveProgramming/Templates/template.cpp",
					py = "~/Projects/CompetitiveProgramming/Templates/template.py",
				},
			})
			vim.keymap.set("n", "<leader>cr", ":CompetiTest run<CR>")
			vim.keymap.set("n", "<leader>cp", ":CompetiTest receive problem<CR>")
			vim.keymap.set("n", "<leader>cc", ":CompetiTest receive contest<CR>")
		end,
	},
}
