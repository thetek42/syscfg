local pluginmgr = require "pluginmgr"

pluginmgr.init ()

-- color scheme
pluginmgr.add "https://github.com/neanias/everforest-nvim"
require "theme".setup ()

-- treesitter
pluginmgr.add "https://github.com/nvim-treesitter/nvim-treesitter"
require "nvim-treesitter.configs".setup {
    ensure_installed = { "lua", "vimdoc" },
    auto_install = true,
    ignore_install = { "html" }, -- html is broken lmao
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

-- oil
pluginmgr.add "https://github.com/stevearc/oil.nvim"
require "oil".setup {
    columns = {
        { "permissions", highlight = "Grey" },
        { "size", highlight = "Blue" },
        { "mtime", highlight = "Green" },
    },
}

-- cfilter
vim.cmd.packadd "cfilter"
