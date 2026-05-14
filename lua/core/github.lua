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

-- Run `git -C <dir> <args>` so git resolves against the current file's repo
-- instead of nvim's working directory.
local function git(dir, args)
	return read_command(string.format("git -C %s %s 2>/dev/null", vim.fn.shellescape(dir), args))
end

local function get_git_remote_url(dir)
	return git(dir, "remote get-url origin")
end

local function git_url_to_github_url(git_url)
	if not git_url then
		return nil
	end

	-- SSH: <any-user>@github.com:owner/repo[.git]
	-- The user part is usually "git" but can be an alias for multi-account setups
	-- (e.g. "org-3324601@github.com:...").
	local ssh_path = git_url:match("^[^@]+@github%.com:(.+)$")
	if ssh_path then
		return "https://github.com/" .. ssh_path:gsub("%.git$", "")
	end

	-- HTTPS: https://github.com/owner/repo[.git]
	local https_path = git_url:match("^https://github%.com/(.+)$")
	if https_path then
		return "https://github.com/" .. https_path:gsub("%.git$", "")
	end

	return nil
end

local function get_relative_file_path(dir, file_path)
	local git_root = git(dir, "rev-parse --show-toplevel")
	if not git_root then
		return nil
	end

	return (file_path:gsub("^" .. vim.pesc(git_root) .. "/", ""))
end

local function get_current_branch(dir)
	return git(dir, "branch --show-current") or "main"
end

local function get_commit_for_line(dir, file_path, line_number)
	local result = git(dir, string.format("blame -L%d,%d --porcelain %s", line_number, line_number, file_path))
	if not result then
		return nil
	end
	return result:match("^([a-f0-9]+)")
end

local function get_pr_for_commit(dir, commit_hash)
	if not commit_hash then
		return nil
	end

	-- Look for GitHub merge-commit patterns referencing the commit.
	local result = git(
		dir,
		string.format(
			"log --oneline --grep='Merge pull request' --grep='(#[0-9]*)' --extended-regexp %s",
			commit_hash
		)
	)
	if result then
		local pr_number = result:match("#(%d+)")
		if pr_number then
			return pr_number
		end
	end

	-- Fallback: squash-merge commits often end with "(#123)".
	local msg = git(dir, string.format("log -1 --pretty=format:%%s %s", commit_hash))
	if msg then
		return msg:match("%(#(%d+)%)")
	end

	return nil
end

-- Resolve the GitHub repo URL, current file path relative to repo root, the
-- current line number, and the file's directory (used as cwd for git commands).
-- Notifies and returns nil if any step fails.
local function get_context()
	local file_path = vim.fn.expand("%:p")
	if file_path == "" then
		vim.notify("Buffer has no file on disk", vim.log.levels.ERROR)
		return nil
	end
	local dir = vim.fn.expand("%:p:h")

	local git_url = get_git_remote_url(dir)
	if not git_url then
		vim.notify("Not in a git repository or no remote origin found", vim.log.levels.ERROR)
		return nil
	end

	local github_url = git_url_to_github_url(git_url)
	if not github_url then
		vim.notify("Remote origin is not a GitHub repository", vim.log.levels.ERROR)
		return nil
	end

	local rel_path = get_relative_file_path(dir, file_path)
	if not rel_path then
		vim.notify("Could not determine file path relative to git root", vim.log.levels.ERROR)
		return nil
	end

	return github_url, rel_path, vim.fn.line("."), dir, file_path
end

local function open_url(url, message)
	vim.fn.jobstart({ "open", url })
	vim.notify(message .. url, vim.log.levels.INFO)
end

function M.open_github_file()
	local github_url, file_path, line_number, dir = get_context()
	if not github_url then
		return
	end

	local url = string.format("%s/blob/%s/%s#L%d", github_url, get_current_branch(dir), file_path, line_number)
	open_url(url, "Opening: ")
end

function M.open_github_commit()
	local github_url, _, line_number, dir, abs_path = get_context()
	if not github_url then
		return
	end

	local commit_hash = get_commit_for_line(dir, abs_path, line_number)
	if not commit_hash then
		vim.notify("Could not find commit for current line", vim.log.levels.ERROR)
		return
	end

	open_url(string.format("%s/commit/%s", github_url, commit_hash), "Opening commit: ")
end

function M.open_github_pr()
	local github_url, _, line_number, dir, abs_path = get_context()
	if not github_url then
		return
	end

	local commit_hash = get_commit_for_line(dir, abs_path, line_number)
	if not commit_hash then
		vim.notify("Could not find commit for current line", vim.log.levels.ERROR)
		return
	end

	local pr_number = get_pr_for_commit(dir, commit_hash)
	if not pr_number then
		vim.notify("Could not find pull request for this commit", vim.log.levels.WARN)
		return
	end

	open_url(string.format("%s/pull/%s", github_url, pr_number), "Opening PR: ")
end

return M
