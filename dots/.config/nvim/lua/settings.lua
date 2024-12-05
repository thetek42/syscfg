local opts = {
    clipboard = "unnamedplus",
    cursorline = true,
    expandtab = true,
    laststatus = 3,
    number = true,
    numberwidth = 4,
    pumheight = 10,
    shiftwidth = 4,
    showcmd = false,
    signcolumn = 'yes',
    spelllang = { "de", "en" },
    splitbelow = true,
    splitright = true,
    swapfile = false,
    tabstop = 4,
    termguicolors = true,
    undofile = true,
    virtualedit = { "block" },
    writebackup = false,
}

for key, value in pairs (opts) do
    vim.opt[key] = value
end

vim.opt.completeopt:append { "menu", "menuone" }
vim.opt.completeopt:remove { "preview" }
vim.opt.diffopt:append { "algorithm:myers", "indent-heuristic" }
vim.opt.formatoptions:append "n"
vim.opt.runtimepath:append (vim.fn.stdpath ("data") .. "/site")
vim.opt.shortmess:append "c"
vim.opt.whichwrap:append "<,>,[,],h,l"

vim.opt.statusline = " " ..
    "%#StatusLineGrey#%n " ..
    "%#StatusLineFilename#%f " ..
    "%#StatusLineGrey#%y%q%w " ..
    "%#StatusLineModified#%m" ..
    "%#StatusLineGrey#%r" ..
    "%=" ..
    "%#StatusLineGrey#%3P " ..
    "%#StatusLineGrey#%5L " ..
    "%#StatusLineLocation#%5l:%-6(%c%V%)" ..
    "%#StatusLine#"

vim.cmd [[ colorscheme everforest ]]

vim.g.c_syntax_for_h = true
vim.g.tex_flavor = "latex"

-- lsp: references in location list
vim.lsp.handlers["textDocument/references"] = vim.lsp.with (
    vim.lsp.handlers["textDocument/references"], {
        loclist = true,
    }
)

-- lsp: disable semantic highlighting
vim.api.nvim_create_autocmd ("LspAttach", {
    callback = function (args)
        local client = vim.lsp.get_client_by_id (args.data.client_id)
        if not client then return end
        client.server_capabilities.semanticTokensProvider = nil
    end,
})
