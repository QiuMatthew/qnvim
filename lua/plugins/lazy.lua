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
	local plugins = {}
	vim.list_extend(plugins, require("plugins.theme"))
	vim.list_extend(plugins, require("plugins.todo-comments"))
	vim.list_extend(plugins, require("plugins.neo-tree"))
	vim.list_extend(plugins, require("plugins.tmux-navigation"))
	vim.list_extend(plugins, require("plugins.comment"))
	vim.list_extend(plugins, require("plugins.gitsigns"))
	vim.list_extend(plugins, require("plugins.autopairs"))
	vim.list_extend(plugins, require("plugins.which-key"))
	vim.list_extend(plugins, require("plugins.treesitter")) -- syntax highlight
	vim.list_extend(plugins, require("plugins.telescope")) -- fuzzy finder
	vim.list_extend(plugins, require("plugins.lsp")) -- lsp related
	vim.list_extend(plugins, require("plugins.cmp")) -- auto complete
	vim.list_extend(plugins, require("plugins.conform")) -- auto format
	vim.list_extend(plugins, require("plugins.leetcode"))
	vim.list_extend(plugins, require("plugins.competitest"))
	vim.list_extend(plugins, require("plugins.obsidian"))
	return plugins
end

-- install plugins
require("lazy").setup(load_plugins())
