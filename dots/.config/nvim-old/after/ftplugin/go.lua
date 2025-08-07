if vim.b.did_after_ftplugin then
    return
end

vim.opt_local.expandtab = false
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.tabstop = 4

local function setup_lsp ()
    if vim.fn.executable "gopls" ~= 1 then return end
    local root_files = { "go.mod", ".git" }
    vim.lsp.start {
        name = "gopls",
        cmd = { "gopls" },
        root_dir = vim.fs.dirname (vim.fs.find (root_files, { upward = true })[1]),
    }
end

setup_lsp ()

vim.b.did_after_ftplugin = true
