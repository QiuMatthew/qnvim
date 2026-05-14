-- Core configurations
require("core.options") -- line number, indentation, language, etc.
require("core.keymaps") -- core keymaps, excluding plugins
require("core.yankhighlight") -- highlight yanked text
require("core.runcode") -- <leader>rc: run current file in a split
require("core.runonsave") -- <leader>ros: re-run current file on every save

-- Plugins
require("plugins.lazy") -- use lazy.nvim to manage all plugins
