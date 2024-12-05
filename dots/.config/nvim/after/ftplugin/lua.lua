if vim.b.did_after_ftplugin then
    return
end

vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.tabstop = 4

local function setup_lsp ()
    if vim.fn.executable "lua-language-server" ~= 1 then return end

    local buf = vim.api.nvim_get_current_buf ()
    local is_vim_config = vim.fn.stridx (vim.fs.dirname (vim.fn.expand "%:p"), ".config/nvim") >= 0
    local root_files = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git" }
    local root_dir = is_vim_config and tostring (vim.fn.stdpath ("config")) or vim.fs.root (buf, root_files)
    local settings = { Lua = { telemetry = { enable = false } } }

    if is_vim_config then
        settings.Lua.runtime = { version = "LuaJIT" }
        settings.Lua.workspace = {
            checkThirdParty = false,
            library = { vim.env.VIMRUNTIME },
        }
    end

    vim.lsp.start {
        name = "lua-language-server",
        cmd = { "lua-language-server" },
        root_dir = root_dir,
        settings = settings,
    }
end

setup_lsp ()

vim.b.did_after_ftplugin = true
