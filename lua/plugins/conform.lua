return {
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
				cpp = { "my_cpp_formatter" },
				go = {
					"gofmt",
					-- "goimports-reviser",
				},
			},
			formatters = {
				my_cpp_formatter = {
					command = "clang-format",
					args = '--style="{BasedOnStyle: Google, UseTab: Always, IndentWidth: 4, TabWidth: 4}"',
				},
			},
		},
	},
}
