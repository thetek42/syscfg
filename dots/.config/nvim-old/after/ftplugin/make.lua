if vim.b.did_after_ftplugin then
    return
end

vim.opt_local.expandtab = false
vim.opt_local.shiftwidth = 8
vim.opt_local.softtabstop = 8
vim.opt_local.tabstop = 8

vim.b.did_after_ftplugin = true
