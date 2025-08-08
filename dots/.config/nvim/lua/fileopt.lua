local M = {}

function M.configure (config)
  if vim.b.did_after_ftplugin then
    return
  end

  if config.indent ~= nil then
    if config.indent.soft ~= nil then
      vim.opt_local.expandtab = config.indent.soft
      if not config.indent.soft then
        vim.opt_local.listchars:append { tab = "  " }
      end
    end
    if config.indent.width ~= nil then
      vim.opt_local.shiftwidth = config.indent.width
      vim.opt_local.softtabstop = config.indent.width
      vim.opt_local.tabstop = config.indent.width
    end
  end

  if config.width ~= nil then
    vim.opt_local.textwidth = config.width
    vim.opt_local.colorcolumn = "+1"
  end

  if config.opt ~= nil then
    for key, value in pairs (config.opt) do
      vim.opt_local[key] = value
    end
  end

  vim.b.did_after_ftplugin = true
end

return M
