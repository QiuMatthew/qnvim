require("nvim-treesitter.configs").setup({
	ensure_installed = { "vim", "bash", "c", "cpp", "javascript", "json", "lua", "python" },
	auto_install = true,

	highlight = { enable = true },
	indent = { enable = true },
})
