vim.api.nvim_create_autocmd ({ "BufRead", "BufNewFile" }, {
    pattern = { "*.avi", "*.flac", "*.mkv", "*.mov", "*.mp3", "*.mp4", "*.mpg", "*.ogg", "*.wav", "*.wmv"  },
    callback = function () vim.opt_local.filetype = "mpv" end,
})
