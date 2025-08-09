vim.pack.add {
  "https://github.com/chomosuke/typst-preview.nvim",
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
    { "permissions", highlight = "Grey" },
    { "size",        highlight = "Blue" },
    { "mtime",       highlight = "Green" },
  },
}

require "typst-preview".setup {
  invert_colors = "always",
  dependencies_bin = {
    tinymist = "tinymist",
    websocat = "websocat",
  },
}

vim.cmd.packadd "cfilter"
