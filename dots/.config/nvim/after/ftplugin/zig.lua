if vim.b.did_after_ftplugin then
    return
end

vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.tabstop = 4

vim.g.zig_fmt_autosave = false

local function setup_lsp ()
    if vim.fn.executable "zls" ~= 1 then return end
    local root_files = { "build.zig", ".git" }
    vim.lsp.start {
        cmd = { "zls" },
        root_dir = vim.fs.dirname (vim.fs.find (root_files, { upward = true })[1]),
    }
end

setup_lsp ()

vim.b.did_after_ftplugin = true
