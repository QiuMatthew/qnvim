-- line number
vim.opt.number = true
vim.opt.relativenumber = true

-- indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true

-- allow contents exceed the window border
vim.opt.wrap = false

-- highlight cursor line
vim.opt.cursorline = true

-- enable mouse operations, e.g. resizing splits
vim.opt.mouse = "a"

-- enable vim to use system clipboard
vim.opt.clipboard = "unnamedplus"

-- color
vim.opt.termguicolors = true

-- one more column on the left, reserve for debug, etc.
vim.opt.signcolumn = "yes"

-- do not show mode, since it is already in status bar
vim.opt.showmode = false

-- save undo history
vim.opt.undofile = true

-- position of new splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- max line length 80
vim.opt.colorcolumn = "81"
