if vim.b.did_after_ftplugin then
    return
end

vim.opt_local.colorcolumn = "+1"
vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.tabstop = 4
vim.opt_local.textwidth = 120
vim.opt_local.wrap = false

local function setup_lsp ()
    if vim.fn.executable "rust-analyzer" ~= 1 then return end

    local cargo_toml_dir = vim.fs.dirname (vim.fs.find ({ "Cargo.toml" }, { upward = true })[1])
    local metadata_cmd = "cargo metadata --no-deps --format-version 1"
    if cargo_toml_dir ~= nil then
        metadata_cmd = metadata_cmd .. "  --manifest-path " .. vim.fs.joinpath (cargo_toml_dir, "Cargo.toml")
    end
    local cargo_metadata = vim.fn.system (metadata_cmd)
    local cargo_workspace_dir = nil
    if vim.v.shell_error == 0 then
        cargo_workspace_dir = vim.fn.json_decode (cargo_metadata)["workspace_root"]
    end
    local root_dir = cargo_workspace_dir or cargo_toml_dir or vim.fs.dirname (vim.fs.find ({ ".git" }, { upward = true })[1])

    vim.lsp.start {
        cmd = { "rust-analyzer" },
        root_dir = root_dir,
    }
end

setup_lsp ()

vim.b.did_after_ftplugin = true
