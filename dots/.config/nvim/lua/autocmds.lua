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

-- file templates
local template_dir = "~/.config/nvim/templates"
local templates = io.popen ("ls -1 " .. template_dir)
if templates ~= nil then
    for filename in templates:lines () do
        local extension = vim.fn.fnamemodify (filename, ":e")
        vim.api.nvim_create_autocmd ("BufNewFile", {
            pattern = { "*." .. extension },
            callback = function ()
                vim.cmd ("0read " .. template_dir .. "/template." .. extension)
                vim.cmd ("%s/\\$TEMPLATE_FILENAME_UPPER\\$/" .. vim.fn.toupper (vim.fn.expand ("%:t:r")) .. "/ge")
                vim.cmd ("norm Gddgg")
            end,
        })
    end
    templates:close ()
end
