-- highlight on yank
vim.api.nvim_create_autocmd ("TextYankPost", {
    callback = function ()
        vim.highlight.on_yank { higroup = "Visual" }
    end,
})

-- disable comment continuation
vim.api.nvim_create_autocmd ("BufEnter", {
    callback = function ()
        vim.opt.formatoptions:remove { "o", "r" }
    end,
})

-- disable undofile on temporary files
vim.api.nvim_create_autocmd ("BufWritePre", {
    pattern = "/tmp/*",
    callback = function ()
        vim.opt_local.undofile = false
    end,
})
