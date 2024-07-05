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

local function load_plugins()
	-- local plugin_namelist = {}
	local plugins = {}

	local plugin_config = require("plugins.theme")
	vim.list_extend(plugins, plugin_config)
	plugin_config = require("plugins.leetcode")
	vim.list_extend(plugins, plugin_config)
	plugin_config = require("plugins.todo-comments")
	vim.list_extend(plugins, plugin_config)
	plugin_config = require("plugins.neo-tree")
	vim.list_extend(plugins, plugin_config)
	plugin_config = require("plugins.comment")
	vim.list_extend(plugins, plugin_config)
	plugin_config = require("plugins.gitsigns")
	vim.list_extend(plugins, plugin_config)
	plugin_config = require("plugins.tmux-navigation")
	vim.list_extend(plugins, plugin_config)
	plugin_config = require("plugins.which-key")
	vim.list_extend(plugins, plugin_config)
	plugin_config = require("plugins.treesitter")
	vim.list_extend(plugins, plugin_config)
	plugin_config = require("plugins.telescope")
	vim.list_extend(plugins, plugin_config)
	plugin_config = require("plugins.lsp")
	vim.list_extend(plugins, plugin_config)
	plugin_config = require("plugins.cmp")
	vim.list_extend(plugins, plugin_config)
	plugin_config = require("plugins.conform")
	vim.list_extend(plugins, plugin_config)
	return plugins
end

-- install plugins
require("lazy").setup(load_plugins())
