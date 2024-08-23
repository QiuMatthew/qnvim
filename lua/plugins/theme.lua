return {
	-- theme
	-- {
	-- 	"folke/tokyonight.nvim",
	-- 	lazy = false, -- load this plugin immediately when neovim starts
	-- 	priority = 1000, -- start early since other plugins might depend on it
	-- 	init = function() -- run this function when the plugin is loaded
	-- 		vim.cmd([[colorscheme tokyonight-night]])
	-- 	end,
	-- },
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		init = function()
			vim.cmd.colorscheme("catppuccin-mocha")
		end,
		config = function()
			require("catppuccin").setup({
				transparent_background = false,
				integrations = {
					telescope = true,
					harpoon = true,
					mason = true,
					neotest = true,
				},
				color_overrides = {
					-- mocha = {
					-- 	base = "#1c1917",
					-- 	blue = "#22d3ee",
					-- 	green = "#86efac",
					-- 	flamingo = "#D6409F",
					-- 	lavender = "#DE51A8",
					-- 	pink = "#f9a8d4",
					-- 	red = "#fda4af",
					-- 	maroon = "#f87171",
					-- 	mauve = "#D19DFF",
					-- 	text = "#E8E2D9",
					-- 	sky = "#7ee6fd",
					-- 	yellow = "#fde68a",
					-- 	rosewater = "#f4c2c2",
					-- 	peach = "#fba8c4",
					-- 	teal = "#4fd1c5",
					-- },
					--
					mocha = {
						base = "#000000",
						mantle = "#000000",
						crust = "#000000",
					},
					--
					-- mocha = {
					-- 	rosewater = "#ffc9c9",
					-- 	flamingo = "#ff9f9a",
					-- 	pink = "#ffa9c9",
					-- 	mauve = "#df95cf",
					-- 	lavender = "#a990c9",
					-- 	red = "#ff6960",
					-- 	maroon = "#f98080",
					-- 	peach = "#f9905f",
					-- 	yellow = "#f9bd69",
					-- 	green = "#b0d080",
					-- 	teal = "#a0dfa0",
					-- 	sky = "#a0d0c0",
					-- 	sapphire = "#95b9d0",
					-- 	blue = "#89a0e0",
					-- 	text = "#e0d0b0",
					-- 	subtext1 = "#d5c4a1",
					-- 	subtext0 = "#bdae93",
					-- 	overlay2 = "#928374",
					-- 	overlay1 = "#7c6f64",
					-- 	overlay0 = "#665c54",
					-- 	surface2 = "#504844",
					-- 	surface1 = "#3a3634",
					-- 	surface0 = "#252525",
					-- 	base = "#151515",
					-- 	mantle = "#0e0e0e",
					-- 	crust = "#080808",
					-- },
				},
			})
		end,
	},
}
