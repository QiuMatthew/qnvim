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
