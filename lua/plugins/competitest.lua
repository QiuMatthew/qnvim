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
		end,
	},
}
