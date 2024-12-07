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
local template_dir = vim.fn.stdpath ("config") .. "/templates"
local templates = io.popen ("ls -1 " .. template_dir)
if templates ~= nil then
    for filename in templates:lines () do
        if vim.startswith (filename, "LICENSE") then
            goto continue
        end
        local pattern = filename
        if vim.startswith (filename, "_.") then
            local extension = vim.fn.fnamemodify (filename, ":e")
            pattern = "*." .. extension
        end
        vim.api.nvim_create_autocmd ("BufNewFile", {
            pattern = { pattern },
            callback = function ()
                vim.cmd ("silent 0read " .. template_dir .. "/" .. filename)
                vim.cmd ("silent %s/\\$TEMPLATE_FILENAME_UPPER\\$/" .. vim.fn.toupper (vim.fn.expand ("%:t:r")) .. "/ge")
                vim.cmd ("norm Gddgg")
            end,
        })
        ::continue::
    end
    templates:close ()
end

-- license templates
vim.api.nvim_create_autocmd ("BufNewFile", {
    pattern = { "LICENSE" },
    callback = function ()
        local template_iter = io.popen ("ls -1 " .. template_dir .. "/LICENSE-*")
        if template_iter == nil then return end
        local licenses = {}
        for path in template_iter:lines () do
            local filename = vim.fn.fnamemodify (path, ":t")
            licenses[#licenses + 1] = string.sub (filename, 9)
        end
        template_iter:close ()
        local choice_string = ""
        for i, license in ipairs (licenses) do
            local append = ""
            if i > 1 then
                append = "\n"
            end
            choice_string = choice_string .. append .. license
        end
        local message = "Choose a license template (or ESC for no template):"
        local choice = vim.fn.confirm (message, choice_string)
        if choice == 0 then return end
        local chosen_license = licenses[choice]
        vim.cmd ("silent 0read " .. template_dir .. "/LICENSE-" .. chosen_license)
        vim.cmd ("norm Gddgg")
    end,
})
