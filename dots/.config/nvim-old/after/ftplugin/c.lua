if vim.b.did_after_ftplugin then
    return
end

vim.opt_local.colorcolumn = "+1"
vim.opt_local.expandtab = false
vim.opt_local.shiftwidth = 8
vim.opt_local.softtabstop = 8
vim.opt_local.tabstop = 8
vim.opt_local.textwidth = 80
vim.opt_local.wrap = false

vim.api.nvim_buf_create_user_command (0, "Other", function ()
    local this_file_name = vim.fn.expand ("%:t")
    local this_file_dir = vim.fn.expand ("%:h")
    local other_file_name, search_paths
    if vim.endswith (this_file_name, ".c") then
        other_file_name = vim.fn.expand ("%:t:r") .. ".h"
        search_paths = { ".", "./inc", "./include", "../inc", "../include" }
    elseif vim.endswith (this_file_name, ".h") then
        other_file_name = vim.fn.expand ("%:t:r") .. ".c"
        search_paths = { ".", "../src", "../" }
    else return end
    for _, path in ipairs (search_paths) do
        local file = vim.fn.simplify (this_file_dir .. "/" .. path .. "/" .. other_file_name)
        if vim.fn.filereadable (file) == 1 then
            vim.cmd.edit (file)
        end
    end
end, {})

vim.keymap.set("n", "<leader>go", "<CMD>Other<CR>", { buffer = true, silent = true })

local function setup_lsp ()
    if vim.fn.executable "clangd" ~= 1 then return end
    local root_files = { ".clangd", ".clang-tidy", ".clang-format", "compile_commands.json", "compile_flags.txt", "configure.ac", ".git" }
    vim.lsp.start {
        cmd = { "clangd" },
        root_dir = vim.fs.dirname (vim.fs.find (root_files, { upward = true })[1]),
        single_file_support = true,
    }
end

setup_lsp ()

vim.b.did_after_ftplugin = true
