vim.g.mapleader = " "

-- insert mode

-- visual mode
-- move selected line
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- normal mode
-- split window
vim.keymap.set("n", "<leader>sv", "<C-w>v")
vim.keymap.set("n", "<leader>sh", "<C-w>s")
-- diagnostics
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "go to next [D]iagnostic message" })

-- plugins
-- neo-tree
vim.keymap.set("n", "<leader>e", ":Neotree reveal=true toggle=true position=left <CR>")
