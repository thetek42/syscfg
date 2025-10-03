vim.pack.add {
  "https://github.com/aktersnurra/no-clown-fiesta.nvim",
  "https://github.com/chomosuke/typst-preview.nvim",
  "https://github.com/echasnovski/mini.pick",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/stevearc/oil.nvim",
}

require "nvim-treesitter.configs".setup {
  ensure_installed = { "lua", "vimdoc" },
  auto_install = true,
  highlight = { enable = true },
  indent = {
    enable = true,
    disable = { "c" },
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      node_incremental = "+",
      node_decremental = "-",
    },
  },
}

require "oil".setup {
  columns = {
    { "permissions", highlight = "Comment" },
    { "size",        highlight = "Function" },
    { "mtime",       highlight = "Keyword" },
  },
}

require "typst-preview".setup {
  open_cmd = "chromium %%U --start-maximized --app=%s",
  invert_colors = "always",
  dependencies_bin = {
    tinymist = "tinymist",
    websocat = "websocat",
  },
}

require "mini.pick".setup {
  mappings = {
    move_down = "<C-j>",
    move_up = "<C-k>",
  },
  window = {
    config = {
      height = 15,
      width = 70,
      border = "solid",
    },
  },
}

vim.cmd.packadd "cfilter"

vim.cmd.colorscheme "no-clown-fiesta"
vim.cmd [[ hi! link @keyword.import @keyword ]]
vim.cmd [[ hi! link @markup.raw markdownCodeBlock ]]
vim.cmd [[ hi! link @markup.quote Comment ]]
vim.cmd [[ hi! link @punctuation.special.markdown Comment ]]
vim.cmd [[ hi link OilLink @function ]]
vim.cmd [[ hi! @boolean guifg=NONE ]]
vim.cmd [[ hi! @markup.strong guifg=NONE gui=bold ]]
vim.cmd [[ hi! @number guifg=NONE ]]
vim.cmd [[ hi! @number.float guifg=NONE ]]
vim.cmd [[ hi! Number guifg=NONE ]]
vim.cmd [[ hi! Float guifg=NONE ]]
vim.cmd [[ hi CursorLine guibg=#252525 ]]
vim.cmd [[ hi CursorLineNr guibg=#252525 ]]
vim.cmd [[ hi CursorLineSign guibg=#252525 ]]
vim.cmd [[ hi DiagnosticUnderlineError guibg=#401515 ]]
vim.cmd [[ hi DiagnosticUnderlineWarn guibg=#403015 ]]
vim.cmd [[ hi StatusLine guifg=#707070 ]]
