vim.api.nvim_create_autocmd ({ "BufRead", "BufNewFile" }, {
    pattern = { "*.fx"  },
    callback = function () vim.opt_local.filetype = "felix" end,
})
