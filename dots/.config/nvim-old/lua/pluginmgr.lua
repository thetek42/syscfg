local M = {}

local pack_path = vim.fn.stdpath ("data") .. "/site/pack/plugins/start/"

---@param url string
function M.add (url)
    local url_components = vim.split (url, "/", { trimempty = true })
    local plugin_name = url_components[#url_components]
    local plugin_path = pack_path .. plugin_name
    if vim.fn.isdirectory (plugin_path) == 0 then
        print ("Installing plugin " .. plugin_name .. "...")
        local result = vim.system { "git", "-C", pack_path, "clone", url, "--depth=1" }:wait ()
        if result.code == 0 then
            print ("Successfully installed plugin " .. plugin_name)
            vim.cmd.packadd (plugin_name)
        else
            error ("Failed to install plugin " .. plugin_name .. ": " .. result.stderr)
        end
    end
end

function M.update_all ()
    local plugins = vim.split (vim.fn.glob (pack_path .. "*"), "\n", { trimempty = true })
    for _, plugin in ipairs (plugins) do
        local plugin_name = vim.fs.basename (plugin)
        print ("Updating plugin " .. plugin_name .. "...")
        local result = vim.system { "git", "-C", plugin, "pull" }:wait ()
        if result.code == 0 then
            print ("Successfully updated plugin " .. plugin_name)
        else
            error ("Failed to update plugin " .. plugin_name .. ": " .. result.stderr)
        end
    end
end

function M.init ()
    vim.fn.mkdir (pack_path, "p")
    vim.api.nvim_create_user_command ("PluginUpdate", M.update_all, {})
end

return M
