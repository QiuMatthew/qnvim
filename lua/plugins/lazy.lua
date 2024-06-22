-- install lazy if not exist
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- install plugins
require("lazy").setup({
	-- "gc" to comment/uncomment visual lines
	{ "numToStr/Comment.nvim", opts = {} },
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
					mocha = {
						rosewater = "#ffc9c9",
						flamingo = "#ff9f9a",
						pink = "#ffa9c9",
						mauve = "#df95cf",
						lavender = "#a990c9",
						red = "#ff6960",
						maroon = "#f98080",
						peach = "#f9905f",
						yellow = "#f9bd69",
						green = "#b0d080",
						teal = "#a0dfa0",
						sky = "#a0d0c0",
						sapphire = "#95b9d0",
						blue = "#89a0e0",
						text = "#e0d0b0",
						subtext1 = "#d5c4a1",
						subtext0 = "#bdae93",
						overlay2 = "#928374",
						overlay1 = "#7c6f64",
						overlay0 = "#665c54",
						surface2 = "#504844",
						surface1 = "#3a3634",
						surface0 = "#252525",
						base = "#151515",
						mantle = "#0e0e0e",
						crust = "#080808",
					},
				},
			})
		end,
	},
	-- status bar
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	-- Adds git related signs to the gutter, as well as utilities for managing changes
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},
	-- Useful plugin to show you pending keybinds.
	{
		"folke/which-key.nvim",
		event = "VimEnter", -- Sets the loading event to 'VimEnter'
		config = function() -- This is the function that runs, AFTER loading
			require("which-key").setup()

			-- Document existing key chains
			require("which-key").register({
				["<leader>c"] = { name = "[C]ode", _ = "which_key_ignore" },
				["<leader>d"] = { name = "[D]ocument", _ = "which_key_ignore" },
				["<leader>r"] = { name = "[R]ename", _ = "which_key_ignore" },
				["<leader>s"] = { name = "[S]earch", _ = "which_key_ignore" },
				["<leader>w"] = { name = "[W]orkspace", _ = "which_key_ignore" },
				["<leader>t"] = { name = "[T]oggle", _ = "which_key_ignore" },
				["<leader>h"] = { name = "Git [H]unk", _ = "which_key_ignore" },
			})
			-- visual mode
			require("which-key").register({
				["<leader>h"] = { "Git [H]unk" },
			}, { mode = "v" })
		end,
	},
	-- file tree
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
	},
	-- navigate between splits
	{
		"alexghergh/nvim-tmux-navigation",
	},
	-- treesitter for syntax highlight
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
	},
	-- colorful parentheses, brackets and braces
	{
		"p00f/nvim-ts-rainbow",
	},

	-- Fuzzy Finder (files, lsp, etc)
	{
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",

				-- `cond` is a condition used to determine whether this plugin should be installed and loaded.
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },
			{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
		},
	},

	-- lsp
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
			{ "folke/neodev.nvim", opts = {} },
		},
	},

	-- autocomplete
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			-- Snippet Engine & its associated nvim-cmp source
			{
				"L3MON4D3/LuaSnip",
				build = "make install_jsregexp",
				dependencies = {
					-- `friendly-snippets` contains a variety of premade snippets.
					--    See the README about individual language/framework/plugin snippets:
					--    https://github.com/rafamadriz/friendly-snippets
					{
						"rafamadriz/friendly-snippets",
						config = function()
							require("luasnip.loaders.from_vscode").lazy_load()
						end,
					},
				},
			},
			"saadparwaiz1/cmp_luasnip",

			-- Adds other completion capabilities.
			--  nvim-cmp does not ship with all sources by default. They are split
			--  into multiple repos for maintenance purposes.
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
		},
	},

	-- autoformat
	{
		"stevearc/conform.nvim",
		lazy = false,
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = false,
			format_on_save = function(bufnr)
				local disable_filetypes = { c = true, cpp = true }
				-- local disable_filetypes = {}
				return {
					timeout_ms = 500,
					lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
				}
			end,
			formatters_by_ft = {
				lua = { "stylua" },
				-- cpp = { "clang-format" },
				go = { "goimports-reviser" },
			},
			-- formatters = {
			-- 	clang_format = {
			-- 		env = {
			-- 			style = "{UseTab: Always, IndentWidth: 4, TabWidth: 4}",
			-- 		},
			-- 	},
			-- },
		},
	},
	-- Highlight todo, notes, etc in comments
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},

	-- Debugging
	{
		"mfussenegger/nvim-dap",
		config = function(_, _)
			vim.keymap.set("n", "<leader>db", "<cmd> DapToggleBreakpoint <CR>")
			vim.keymap.set("n", "<leader>dr", "<cmd> DapContinue <CR>")
		end,
	},
	{
		"jay-babu/mason-nvim-dap.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"mfussenegger/nvim-dap",
		},
		opts = {
			handlers = {},
		},
	},
	{
		"mfussenegger/nvim-dap-python",
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
		},
		config = function()
			local dap = require("dap")
			dap.adapters.lldb = {
				type = "server",
				port = "${port}",
				executable = {
					command = "/Users/matthew/.local/share/nvim/mason/bin/codelldb", -- Use the path where mason installs codelldb
					args = { "--port", "${port}" },
				},
			}
			dap.configurations.cpp = {
				{
					name = "Launch",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/a.out", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
					args = {},
					runInTerminal = false,
				},
			}
			local dapui = require("dapui")
			dapui.setup()
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			require("dap").set_log_level("DEBUG")
		end,
	},
})
