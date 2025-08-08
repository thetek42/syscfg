vim.opt.backup = false
vim.opt.cinoptions:append { ":0", "l1", "g0", "t0", "(0" }
vim.opt.completeopt:append { "menu", "menuone" }
vim.opt.completeopt:remove { "preview" }
vim.opt.cursorline = true
vim.opt.diffopt:append { "algorithm:myers", "indent-heuristic" }
vim.opt.expandtab = true
vim.opt.fileencoding = "utf-8"
vim.opt.formatoptions:append "n"
vim.opt.formatoptions:append "1" -- break lines before one-letter words
vim.opt.laststatus = 3
vim.opt.lazyredraw = true
vim.opt.list = true
vim.opt.listchars = { tab = "> ", trail = "·" }
vim.opt.number = true
vim.opt.numberwidth = 4
vim.opt.pumheight = 15
vim.opt.relativenumber = true
vim.opt.shiftwidth = 4
vim.opt.shortmess:append "c"
vim.opt.showcmd = false
vim.opt.signcolumn = "yes"
vim.opt.spelllang = { "en_gb", "de_de" }
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.tabstop = 4
vim.opt.undofile = true
vim.opt.virtualedit = { "block" }
vim.opt.whichwrap:append "<,>,[,],h,l"
vim.opt.wrap = true
vim.opt.writebackup = false

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

vim.g.asmsyntax = "nasm"
vim.g.c_syntax_for_h = true
vim.g.tex_flavor = "latex"
