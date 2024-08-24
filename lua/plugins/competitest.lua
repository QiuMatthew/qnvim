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
            vim.keymap.set("n", "<leader>cr", ":CompetiTest run")
            vim.keymap.set("n", "<leader>cgp", ":CompetiTest receive problem")
            vim.keymap.set("n", "<leader>cgc", ":CompetiTest receive contest")
		end,
	},
}
