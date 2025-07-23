local M = {}

-- Function to get the git remote URL
local function get_git_remote_url()
	local handle = io.popen("git remote get-url origin 2>/dev/null")
	if not handle then
		return nil
	end
	local result = handle:read("*a")
	handle:close()

	if result and result ~= "" then
		return result:gsub("%s+", "") -- Remove whitespace
	end
	return nil
end

-- Function to convert git URL to GitHub web URL
local function git_url_to_github_url(git_url)
	if not git_url then
		return nil
	end

	-- Handle SSH URLs (git@github.com:user/repo.git)
	local ssh_match = git_url:match("git@github%.com:(.+)%.git")
	if ssh_match then
		return "https://github.com/" .. ssh_match
	end

	-- Handle HTTPS URLs (https://github.com/user/repo.git)
	local https_match = git_url:match("https://github%.com/(.+)%.git")
	if https_match then
		return "https://github.com/" .. https_match
	end

	-- Handle HTTPS URLs without .git suffix
	local https_no_git = git_url:match("https://github%.com/(.+)")
	if https_no_git then
		return "https://github.com/" .. https_no_git
	end

	return nil
end

-- Function to get the current file path relative to git root
local function get_relative_file_path()
	local file_path = vim.fn.expand("%:p")
	if file_path == "" then
		return nil
	end

	local handle = io.popen("git rev-parse --show-toplevel 2>/dev/null")
	if not handle then
		return nil
	end
	local git_root = handle:read("*a")
	handle:close()

	if git_root and git_root ~= "" then
		git_root = git_root:gsub("%s+", "")
		local relative_path = file_path:gsub("^" .. vim.pesc(git_root) .. "/", "")
		return relative_path
	end

	return nil
end

-- Function to get current git branch
local function get_current_branch()
	local handle = io.popen("git branch --show-current 2>/dev/null")
	if not handle then
		return "main"
	end
	local branch = handle:read("*a")
	handle:close()

	if branch and branch ~= "" then
		return branch:gsub("%s+", "")
	end
	return "main"
end

-- Function to get commit hash for current line using git blame
local function get_commit_for_line(file_path, line_number)
	local cmd = string.format("git blame -L%d,%d --porcelain %s 2>/dev/null", line_number, line_number, file_path)
	local handle = io.popen(cmd)
	if not handle then
		return nil
	end
	local result = handle:read("*a")
	handle:close()

	if result and result ~= "" then
		-- Extract commit hash from first line of porcelain output
		local commit_hash = result:match("^([a-f0-9]+)")
		return commit_hash
	end
	return nil
end

-- Function to find pull request for a commit
local function get_pr_for_commit(commit_hash)
	if not commit_hash then
		return nil
	end

	-- Try to find PR using git log with grep for GitHub merge patterns
	local cmd = string.format("git log --oneline --grep='Merge pull request' --grep='(#[0-9]*)' --extended-regexp %s 2>/dev/null", commit_hash)
	local handle = io.popen(cmd)
	if not handle then
		return nil
	end
	local result = handle:read("*a")
	handle:close()

	if result and result ~= "" then
		-- Extract PR number from merge commit message
		local pr_number = result:match("#(%d+)")
		return pr_number
	end

	-- Alternative: check if commit message contains PR reference
	local msg_cmd = string.format("git log -1 --pretty=format:%%s %s 2>/dev/null", commit_hash)
	local msg_handle = io.popen(msg_cmd)
	if msg_handle then
		local msg_result = msg_handle:read("*a")
		msg_handle:close()
		if msg_result then
			local pr_number = msg_result:match("%(#(%d+)%)")
			return pr_number
		end
	end

	return nil
end

-- Main function to open GitHub file in browser
function M.open_github_file()
	local git_url = get_git_remote_url()
	if not git_url then
		vim.notify("Not in a git repository or no remote origin found", vim.log.levels.ERROR)
		return
	end

	local github_url = git_url_to_github_url(git_url)
	if not github_url then
		vim.notify("Remote origin is not a GitHub repository", vim.log.levels.ERROR)
		return
	end

	local file_path = get_relative_file_path()
	if not file_path then
		vim.notify("Could not determine file path relative to git root", vim.log.levels.ERROR)
		return
	end

	local branch = get_current_branch()
	local line_number = vim.fn.line(".")

	local url = string.format("%s/blob/%s/%s#L%d", github_url, branch, file_path, line_number)

	-- Open URL in browser (Mac OS)
	vim.fn.jobstart({ "open", url })
	vim.notify("Opening: " .. url, vim.log.levels.INFO)
end

-- Function to open GitHub commit page for current line
function M.open_github_commit()
	local git_url = get_git_remote_url()
	if not git_url then
		vim.notify("Not in a git repository or no remote origin found", vim.log.levels.ERROR)
		return
	end

	local github_url = git_url_to_github_url(git_url)
	if not github_url then
		vim.notify("Remote origin is not a GitHub repository", vim.log.levels.ERROR)
		return
	end

	local file_path = get_relative_file_path()
	if not file_path then
		vim.notify("Could not determine file path relative to git root", vim.log.levels.ERROR)
		return
	end

	local line_number = vim.fn.line(".")
	local commit_hash = get_commit_for_line(file_path, line_number)
	
	if not commit_hash then
		vim.notify("Could not find commit for current line", vim.log.levels.ERROR)
		return
	end

	local url = string.format("%s/commit/%s", github_url, commit_hash)

	-- Open URL in browser (Mac OS)
	vim.fn.jobstart({ "open", url })
	vim.notify("Opening commit: " .. url, vim.log.levels.INFO)
end

-- Function to open GitHub pull request page for current line
function M.open_github_pr()
	local git_url = get_git_remote_url()
	if not git_url then
		vim.notify("Not in a git repository or no remote origin found", vim.log.levels.ERROR)
		return
	end

	local github_url = git_url_to_github_url(git_url)
	if not github_url then
		vim.notify("Remote origin is not a GitHub repository", vim.log.levels.ERROR)
		return
	end

	local file_path = get_relative_file_path()
	if not file_path then
		vim.notify("Could not determine file path relative to git root", vim.log.levels.ERROR)
		return
	end

	local line_number = vim.fn.line(".")
	local commit_hash = get_commit_for_line(file_path, line_number)
	
	if not commit_hash then
		vim.notify("Could not find commit for current line", vim.log.levels.ERROR)
		return
	end

	local pr_number = get_pr_for_commit(commit_hash)
	if not pr_number then
		vim.notify("Could not find pull request for this commit", vim.log.levels.WARN)
		return
	end

	local url = string.format("%s/pull/%s", github_url, pr_number)

	-- Open URL in browser (Mac OS)
	vim.fn.jobstart({ "open", url })
	vim.notify("Opening PR: " .. url, vim.log.levels.INFO)
end

return M