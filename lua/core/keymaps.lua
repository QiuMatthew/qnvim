vim.g.mapleader = " "

-- visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv") -- move selected line downward
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv") -- move selected line upward

-- normal mode
vim.keymap.set("n", "<leader>sv", "<C-w>v") -- split window vertically
vim.keymap.set("n", "<leader>sh", "<C-w>s") -- split window horizontally

-- diagnostics
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>dd", function()
	if not vim.diagnostic.is_enabled() then
		vim.diagnostic.enable()
	else
		vim.diagnostic.enable(false)
	end
end, { desc = "toggle [D]iagnostics" })

-- github
vim.keymap.set("n", "<leader>gh", function()
	require("core.github").open_github_file()
end, { desc = "open current file in [G]it[H]ub browser" })

vim.keymap.set("n", "<leader>gc", function()
	require("core.github").open_github_commit()
end, { desc = "open [G]it [C]ommit for current line in GitHub" })

vim.keymap.set("n", "<leader>gp", function()
	require("core.github").open_github_pr()
end, { desc = "open [G]it [P]ull request for current line in GitHub" })
