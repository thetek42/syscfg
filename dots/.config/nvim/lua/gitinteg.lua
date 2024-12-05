vim.api.nvim_create_user_command ("GitBlame", function (args)
    local dir = vim.fn.shellescape (vim.fn.expand "%:p:h")
    local command = "git -C " .. dir .. " blame -L " .. args.line1 .. "," .. args.line2 .. " " .. args.args .. " -- " .. vim.fn.expand "%:t"
    print (vim.fn.join (vim.fn.systemlist (command), "\n"))
end, { nargs = "?", range = true })
