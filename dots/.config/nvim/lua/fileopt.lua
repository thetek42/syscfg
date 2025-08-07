local M = {}

function M.configure (config)
  if vim.b.did_after_ftplugin then
    return
  end

  if config.indent ~= nil then
    if config.indent.soft then
      vim.opt_local.expandtab = true
    end
    if config.indent.width ~= nil then
      vim.opt_local.shiftwidth = config.indent.width
      vim.opt_local.softtabstop = config.indent.width
      vim.opt_local.tabstop = config.indent.width
    end
  end

  if config.opt ~= nil then
    for key, value in pairs (config.opt) do
      vim.opt_local[key] = value
    end
  end

  if config.lsp ~= nil then
    local lsp_executable_exists = vim.fn.executable (config.lsp.cmd[1]) == 1
    if lsp_executable_exists then
      local root_dir = nil
      if type (config.lsp.root) == "table" then
        local buffer = vim.api.nvim_get_current_buf ()
        root_dir = vim.fs.root (buffer, config.lsp.root)
      else
        root_dir = config.lsp.root
      end
      vim.lsp.start {
        name = config.lsp.name,
        cmd = config.lsp.cmd,
        root_dir = root_dir,
        settings = config.lsp.opts,
      }
    end
  end

  vim.b.did_after_ftplugin = true
end

return M
