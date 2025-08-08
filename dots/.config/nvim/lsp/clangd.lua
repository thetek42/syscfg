return {
  cmd = { "clangd" },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },

  root_markers = {
    ".clangd",
    ".clang-tidy",
    ".clang-format",
    "compile_commands.json",
    "compile_flags.txt",
    "configure.ac",
    ".git",
  },

  capabilities = {
    textDocument = {
      completion = {
        editsNearCursor = true,
      },
    },
    offsetEncoding = { "utf-8", "utf-16" },
  },

  on_init = function (client, init_result)
    if init_result.offsetEncoding then
      client.offset_encoding = init_result.offsetEncoding
    end
  end,

  ---on_attach = function (_, bufnr)
  ---  vim.api.nvim_buf_create_user_command (bufnr, "LspClangdSwitchSourceHeader", function ()
  ---    switch_source_header (bufnr)
  ---  end, { desc = "Switch between source/header" })
  ---  vim.api.nvim_buf_create_user_command (bufnr, "LspClangdShowSymbolInfo", function ()
  ---    symbol_info ()
  ---  end, { desc = "Show symbol info" })
  ---end,
}
