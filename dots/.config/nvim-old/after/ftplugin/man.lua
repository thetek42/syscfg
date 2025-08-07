if vim.b.did_after_ftplugin then
    return
end

vim.opt_local.signcolumn = "no"

vim.b.did_after_ftplugin = true
