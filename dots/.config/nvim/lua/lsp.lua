vim.lsp.enable {
  "clangd",
  "elm",
  "lua",
  "rust",
}

-- lsp: references in location list
-- TODO: find replacement for vim.lsp.with
vim.lsp.handlers["textDocument/references"] = vim.lsp.with (
  vim.lsp.handlers["textDocument/references"], {
    loclist = true,
  }
)

-- lsp: disable semantic highlighting
vim.api.nvim_create_autocmd ("LspAttach", {
    callback = function (args)
        local client = vim.lsp.get_client_by_id (args.data.client_id)
        if not client then return end
        client.server_capabilities.semanticTokensProvider = nil
    end,
})
