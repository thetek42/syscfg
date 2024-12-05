if vim.b.did_after_ftplugin then
    return
end

vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.tabstop = 2

vim.b.did_after_ftplugin = true
