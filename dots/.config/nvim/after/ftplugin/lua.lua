local current_dir = vim.fs.dirname (vim.fn.expand "%:p")
local is_vim_config = vim.fn.stridx (current_dir, ".config/nvim") >= 0
local root_files = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git" }
local lsp_root = is_vim_config and vim.fn.stdpath ("config") or root_files
local lsp_opts = { Lua = { telemetry = { enable = false } } }
if is_vim_config then
  lsp_opts.Lua.runtime = { version = "LuaJIT" }
  lsp_opts.Lua.workspace = { library = { vim.env.VIMRUNTIME } }
end

require "fileopt".configure {
  indent = {
    soft = true,
    width = 2,
  },
  lsp = {
    name = "lua-language-server",
    cmd = { "lua-language-server" },
    root = lsp_root,
    opts = lsp_opts,
  },
}
