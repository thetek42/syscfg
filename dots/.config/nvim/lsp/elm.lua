return {
  cmd = { "elm-language-server" },
  filetypes = { "elm" },

  root_dir = function (bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name (bufnr)
    local filetype = vim.api.nvim_buf_get_option (0, "filetype")
    if filetype == "elm" or (filetype == "json" and fname:match "elm%.json$") then
      on_dir (vim.fs.root (fname, "elm.json"))
      return
    end
    on_dir (nil)
  end,

  init_options = {
    elmReviewDiagnostics = "off", -- "off" | "warning" | "error"
    skipInstallPackageConfirmation = false,
    disableElmLSDiagnostics = false,
    onlyUpdateDiagnosticsOnSave = false,
  },

  capabilities = {
    offsetEncoding = { "utf-8", "utf-16" },
  },
}
