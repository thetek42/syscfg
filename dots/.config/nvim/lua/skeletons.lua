local skeleton_dir = vim.fn.stdpath ("config") .. "/skeletons"

local code_skeletons = io.popen ("ls -1 " .. skeleton_dir .. "/code")
if code_skeletons ~= nil then
  for filename in code_skeletons:lines () do
    local pattern = filename
    if vim.startswith (filename, "_.") then
      local extension = vim.fn.fnamemodify (filename, ":e")
      pattern = "*." .. extension
    end
    vim.api.nvim_create_autocmd ("BufNewFile", {
      pattern = { pattern },
      callback = function ()
        vim.cmd ("silent 0read " .. skeleton_dir .. "/code/" .. filename)
        vim.cmd ("silent %s/\\$TEMPLATE_DIR_NAME\\$/" .. vim.fn.expand ("%:p:h:t") .. "/ge")
        vim.cmd ("silent %s/\\$TEMPLATE_FILE_NAME\\$/" .. vim.fn.expand ("%:t:r") .. "/ge")
        vim.cmd ("silent %s/\\$TEMPLATE_FILE_NAME_UPPER\\$/" .. vim.fn.toupper (vim.fn.expand ("%:t:r")) .. "/ge")
        vim.cmd ("norm Gddgg")
      end,
    })
  end
  code_skeletons:close ()
end

local function selection_skeleton (folder, pattern)
  vim.api.nvim_create_autocmd ("BufNewFile", {
    pattern = pattern,
    callback = function ()
      local skeleton_iter = io.popen ("ls -1 " .. skeleton_dir .. "/" .. folder)
      if skeleton_iter == nil then return end
      local options = {}
      for path in skeleton_iter:lines () do
        local option = vim.fn.fnamemodify (path, ":t:r")
        options[#options + 1] = { option, path }
      end
      skeleton_iter:close ()
      local choice_string = ""
      for i, option in ipairs (options) do
        local append = i > 1 and "\n" or ""
        choice_string = choice_string .. append .. option[1]
      end
      local message = "Choose a template (or ESC for no template):"
      local choice_index = vim.fn.confirm (message, choice_string)
      if choice_index == 0 then return end
      local choice = options[choice_index]
      vim.cmd ("silent 0read " .. skeleton_dir .. "/" .. folder .. "/" .. choice[2])
      vim.cmd ("norm Gddgg")
    end,
  })
end

selection_skeleton ("license", "LICENSE")
selection_skeleton ("makefile", { "makefile", "Makefile", "*.mk" })
selection_skeleton ("gitignore", ".gitignore")
