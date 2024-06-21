-- highlight the scope of yank (copy)
vim.api.nvim_create_autocmd(
	"TextYankPost", -- the event we are listening
	{
		desc = "highlight the scope of yank (copy)",
		callback = function() -- when the event happens, this function gets called
			vim.highlight.on_yank()
		end,
	}
)

-- vim.keymap.set("n", "<leader>rc", ":w <bar> exec '!python3 '.shellescape('%')<CR>")

-- Function to create a floating window
local function show_in_floating_window(output)
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)

	-- local width = vim.o.columns - 10
	-- local height = vim.o.lines - 10

	local width = vim.api.nvim_win_get_width(0)
	local height = vim.api.nvim_win_get_height(0)
	vim.api.nvim_open_win(buf, true, {
		relative = "win",
		row = 5,
		col = 5,
		width = width - 10,
		height = height - 10,
	})

	-- Close the window when <esc> or <ENTER> is pressed
	vim.api.nvim_buf_set_keymap(buf, "n", "<esc>", ":q<CR>", { noremap = true, silent = true })
	vim.api.nvim_buf_set_keymap(buf, "n", "<CR>", ":q<CR>", { noremap = true, silent = true })
end

-- Function to run the current Python file and display output
function RunCode()
	if vim.bo.filetype == "python" then
		vim.cmd("w")
		local output = vim.fn.systemlist("python " .. vim.fn.shellescape(vim.fn.expand("%")))
		show_in_floating_window(output)
	elseif vim.bo.filetype == "go" then
		vim.cmd("w")
		local output = vim.fn.systemlist("go run " .. vim.fn.shellescape(vim.fn.expand("%")))
		show_in_floating_window(output)
	else
		print("FileType Not Supported. Currently Support: Python, Golang")
	end
end

-- Map <leader>r to the RunPythonFile function
vim.api.nvim_set_keymap("n", "<leader>rc", ":lua RunCode()<CR>", { noremap = true, silent = true })
