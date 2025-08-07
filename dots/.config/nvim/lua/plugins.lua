vim.pack.add {
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/stevearc/oil.nvim",
}

require "nvim-treesitter.configs".setup {
  ensure_installed = { "lua", "vimdoc" },
  auto_install = true,
  highlight = { enable = true },
  indent = { enable = true },
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
    { "size", highlight = "Blue" },
    { "mtime", highlight = "Green" },
  },
}

vim.cmd.packadd "cfilter"
