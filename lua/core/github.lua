local M = {}

-- Run a shell command and return its stripped stdout, or nil if empty/failed.
local function read_command(cmd)
	local handle = io.popen(cmd)
	if not handle then
		return nil
	end
	local result = handle:read("*a")
	handle:close()

	if result and result ~= "" then
		return result:gsub("%s+", "")
	end
	return nil
end

local function get_git_remote_url()
	return read_command("git remote get-url origin 2>/dev/null")
end

local function git_url_to_github_url(git_url)
	if not git_url then
		return nil
	end

	-- SSH: git@github.com:user/repo.git
	local ssh_match = git_url:match("git@github%.com:(.+)%.git")
	if ssh_match then
		return "https://github.com/" .. ssh_match
	end

	-- HTTPS with .git suffix
	local https_match = git_url:match("https://github%.com/(.+)%.git")
	if https_match then
		return "https://github.com/" .. https_match
	end

	-- HTTPS without .git suffix
	local https_no_git = git_url:match("https://github%.com/(.+)")
	if https_no_git then
		return "https://github.com/" .. https_no_git
	end

	return nil
end

local function get_relative_file_path()
	local file_path = vim.fn.expand("%:p")
	if file_path == "" then
		return nil
	end

	local git_root = read_command("git rev-parse --show-toplevel 2>/dev/null")
	if not git_root then
		return nil
	end

	return (file_path:gsub("^" .. vim.pesc(git_root) .. "/", ""))
end

local function get_current_branch()
	return read_command("git branch --show-current 2>/dev/null") or "main"
end

local function get_commit_for_line(file_path, line_number)
	local cmd = string.format("git blame -L%d,%d --porcelain %s 2>/dev/null", line_number, line_number, file_path)
	local handle = io.popen(cmd)
	if not handle then
		return nil
	end
	local result = handle:read("*a")
	handle:close()

	if result and result ~= "" then
		return result:match("^([a-f0-9]+)")
	end
	return nil
end

local function get_pr_for_commit(commit_hash)
	if not commit_hash then
		return nil
	end

	-- Look for GitHub merge-commit patterns referencing the commit.
	local cmd = string.format(
		"git log --oneline --grep='Merge pull request' --grep='(#[0-9]*)' --extended-regexp %s 2>/dev/null",
		commit_hash
	)
	local handle = io.popen(cmd)
	if handle then
		local result = handle:read("*a")
		handle:close()
		if result and result ~= "" then
			local pr_number = result:match("#(%d+)")
			if pr_number then
				return pr_number
			end
		end
	end

	-- Fallback: squash-merge commits often end with "(#123)".
	local msg_cmd = string.format("git log -1 --pretty=format:%%s %s 2>/dev/null", commit_hash)
	local msg_handle = io.popen(msg_cmd)
	if msg_handle then
		local msg_result = msg_handle:read("*a")
		msg_handle:close()
		if msg_result then
			return msg_result:match("%(#(%d+)%)")
		end
	end

	return nil
end

-- Resolve the GitHub repo URL, current file path relative to repo root, and the
-- current line number. Notifies and returns nil if any step fails.
local function get_context()
	local git_url = get_git_remote_url()
	if not git_url then
		vim.notify("Not in a git repository or no remote origin found", vim.log.levels.ERROR)
		return nil
	end

	local github_url = git_url_to_github_url(git_url)
	if not github_url then
		vim.notify("Remote origin is not a GitHub repository", vim.log.levels.ERROR)
		return nil
	end

	local file_path = get_relative_file_path()
	if not file_path then
		vim.notify("Could not determine file path relative to git root", vim.log.levels.ERROR)
		return nil
	end

	return github_url, file_path, vim.fn.line(".")
end

local function open_url(url, message)
	vim.fn.jobstart({ "open", url })
	vim.notify(message .. url, vim.log.levels.INFO)
end

function M.open_github_file()
	local github_url, file_path, line_number = get_context()
	if not github_url then
		return
	end

	local url = string.format("%s/blob/%s/%s#L%d", github_url, get_current_branch(), file_path, line_number)
	open_url(url, "Opening: ")
end

function M.open_github_commit()
	local github_url, file_path, line_number = get_context()
	if not github_url then
		return
	end

	local commit_hash = get_commit_for_line(file_path, line_number)
	if not commit_hash then
		vim.notify("Could not find commit for current line", vim.log.levels.ERROR)
		return
	end

	open_url(string.format("%s/commit/%s", github_url, commit_hash), "Opening commit: ")
end

function M.open_github_pr()
	local github_url, file_path, line_number = get_context()
	if not github_url then
		return
	end

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

	open_url(string.format("%s/pull/%s", github_url, pr_number), "Opening PR: ")
end

return M
