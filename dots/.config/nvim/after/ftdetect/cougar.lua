vim.api.nvim_create_autocmd ({ "BufRead", "BufNewFile" }, {
    pattern = { "*.cg"  },
    callback = function () vim.opt_local.filetype = "cougar" end,
})
