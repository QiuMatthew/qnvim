local command = string.format("/Users/matthew/miniconda3/bin/python")
require("dap-python").setup(command)

return {
	-- Debugging
	{
		"mfussenegger/nvim-dap",
		config = function(_, _)
			vim.keymap.set("n", "<leader>db", "<cmd> DapToggleBreakpoint <CR>")
			vim.keymap.set("n", "<leader>dr", "<cmd> DapContinue <CR>")
		end,
	},
	{
		"jay-babu/mason-nvim-dap.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"mfussenegger/nvim-dap",
		},
		opts = {
			handlers = {},
		},
	},
	{
		"mfussenegger/nvim-dap-python",
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
		},
		config = function()
			local dap = require("dap")
			dap.adapters.lldb = {
				type = "server",
				port = "${port}",
				executable = {
					command = "/Users/matthew/.local/share/nvim/mason/bin/codelldb", -- Use the path where mason installs codelldb
					args = { "--port", "${port}" },
				},
			}
			dap.configurations.cpp = {
				{
					name = "Launch",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/a.out", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
					args = {},
					runInTerminal = false,
				},
			}
			local dapui = require("dapui")
			dapui.setup()
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			require("dap").set_log_level("DEBUG")
		end,
	},
}
