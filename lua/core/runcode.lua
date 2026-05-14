-- Open a scratch buffer in a right split and fill it with `output`.
local function show_result(output)
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)

	vim.api.nvim_open_win(buf, true, {
		split = "right",
	})

	-- Close the window when <esc> or <ENTER> is pressed
	vim.api.nvim_buf_set_keymap(buf, "n", "<esc>", ":q<CR>", { noremap = true, silent = true })
	vim.api.nvim_buf_set_keymap(buf, "n", "<CR>", ":q<CR>", { noremap = true, silent = true })
end

-- Function to run the current file and display output
function RunCode()
	if vim.bo.filetype == "python" then
		vim.cmd("w")
		local output = vim.fn.systemlist("python " .. vim.fn.shellescape(vim.fn.expand("%")))
		show_result(output)
	elseif vim.bo.filetype == "go" then
		vim.cmd("w")
		local output = vim.fn.systemlist("go run " .. vim.fn.shellescape(vim.fn.expand("%")))
		show_result(output)
	elseif vim.bo.filetype == "cpp" then
		vim.cmd("w")
		local compile_info = vim.fn.systemlist("g++ " .. vim.fn.shellescape(vim.fn.expand("%")))
		if compile_info == "" then -- error
			show_result(compile_info)
		else
			local output = vim.fn.systemlist("./a.out")
			show_result(output)
		end
	else
		print("FileType not supported. Currently supports: Python, Go, C++")
	end
end

-- Map <leader>r to the RunPythonFile function
vim.api.nvim_set_keymap(
	"n",
	"<leader>rc",
	":lua RunCode()<CR>G$o==========Execution Finished==========<ESC>",
	{ noremap = true, silent = true, desc = "[R]un current [C]ode file" }
)
