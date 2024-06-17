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
