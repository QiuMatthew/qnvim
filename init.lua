-- Core configurations
require("core.options") -- line number, indentation, etc
require("core.keymaps") -- core keymaps, excluding plugins
require("core.misc") -- other settings, language
require("core.autocommands") -- user configured autocommands

-- Plugins
require("plugins.lazy") -- use lazy to manage all plugins
