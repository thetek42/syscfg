if vim.b.did_after_ftplugin then
    return
end

vim.opt_local.colorcolumn = "+1"
vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.spell = true
vim.opt_local.tabstop = 2
vim.opt_local.textwidth = 100

vim.b.did_after_ftplugin = true
