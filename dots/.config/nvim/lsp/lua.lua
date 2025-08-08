return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },

  settings = {
    Lua = {
      telemetry = { enable = false },
      format = {
        defaultConfig = {
          space_before_closure_open_parenthesis = "true",
          space_before_function_call_open_parenthesis = "true",
          space_before_function_open_parenthesis = "true",
          quote_style = "double",
        },
      },
    },
  },

  root_markers = {
    ".luarc.json",
    ".luarc.jsonc",
    ".luacheckrc",
    ".stylua.toml",
    "stylua.toml",
    "selene.toml",
    "selene.yml",
    ".git",
  },

  on_init = function (client)
    if client.workspace_folders then
      local current_dir = client.workspace_folders[1].name
      local is_vim_config = vim.fn.stridx (current_dir, ".config/nvim") >= 0
      local is_vim_library = vim.fn.stridx (current_dir, "nvim/runtime") >= 0
      local include_vim = is_vim_config or is_vim_library
      if not include_vim then
        return
      end
    end
    client.config.settings.Lua = vim.tbl_deep_extend ("force", client.config.settings.Lua, {
      runtime = {
        version = "LuaJIT",
        path = {
          "lua/?.lua",
          "lua/?/init.lua",
        },
      },
      workspace = {
        checkThirdParty = false,
        library = { vim.env.VIMRUNTIME },
      }
    })
  end,
}
