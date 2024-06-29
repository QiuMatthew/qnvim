local attach_to_buffer = function(buffer, pattern, run_command, compile_command)
	vim.api.nvim_create_autocmd("BufWritePost", {
		group = vim.api.nvim_create_augroup("RunOnSave", { clear = true }),
		pattern = pattern,
		callback = function()
			local append_data = function(_, data)
				if data then
					vim.api.nvim_buf_set_lines(buffer, -1, -1, false, data)
				end
			end

			local execution_process = function()
				-- run the code
				-- vim.fn.jobstart({ "echo", "Hello", "World" }, {
				-- vim.fn.jobstart({ "python", "pytest.py" }, {
				vim.fn.jobstart(run_command, {
					-- Note: Get the result lines as soon as it appears. If this is set as true, we will not get any output until the command finishes.
					stdout_buffered = true,
					on_stdout = append_data,
					on_stderr = append_data,
					on_exit = function()
						vim.api.nvim_buf_set_lines(buffer, -1, -1, false, { "========Execute End========" })
					end,
				})
			end

			vim.api.nvim_open_win(buffer, false, { split = "right" })

			if compile_command then
				-- if compilation is needed
				vim.api.nvim_buf_set_lines(buffer, 0, -1, false, { "=======Compile Start=======" })
				vim.fn.jobstart(compile_command, {
					-- Note: Get the result lines as soon as it appears. If this is set as true, we will not get any output until the command finishes.
					stdout_buffered = true,
					on_stdout = append_data,
					on_stderr = append_data,
					on_exit = function()
						vim.api.nvim_buf_set_lines(buffer, -1, -1, false, { "========Compile End========" })
						vim.api.nvim_buf_set_lines(buffer, -1, -1, false, { "=======Execute Start=======" })
						execution_process()
					end,
				})
			else
				vim.api.nvim_buf_set_lines(buffer, 0, -1, false, { "=======Execute Start=======" })
				execution_process()
			end
		end,
	})
end

-- attach_to_buffer(16, "*.go", { "go", "run", "gotest.go" })

vim.api.nvim_create_user_command("RunOnSave", function()
	print("AutoRun Starts Now...")
	local buffer = vim.api.nvim_create_buf(false, true)
	local pattern, compile_command, run_command
	if vim.bo.filetype == "python" then
		pattern = "*.py"
		compile_command = nil
		run_command = { "python", vim.fn.expand("%") }
	elseif vim.bo.filetype == "cpp" then
		pattern = "*.cpp"
		compile_command = { "g++", vim.fn.expand("%") }
		run_command = { "./a.out" }
	elseif vim.bo.filetype == "go" then
		pattern = "*.go"
		compile_command = nil
		run_command = { "go", "run", vim.fn.expand("%") }
	end

	attach_to_buffer(tonumber(buffer), pattern, run_command, compile_command)
end, {})

vim.api.nvim_set_keymap(
	"n",
	"<leader>ros",
	":RunOnSave<CR>",
	{ desc = "[R]un current code [O]n [S]ave, open a new window to monitor" }
)
