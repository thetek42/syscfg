if vim.b.did_after_ftplugin then
    return
end

vim.cmd [[ silent execute "!mpv " . shellescape(expand("%:p")) . " &>/dev/null &" | buffer # | bdelete # | redraw! ]]

vim.b.did_after_ftplugin = true
