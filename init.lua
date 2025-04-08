-- init.lua
---------------------------------------------

---via u/pseudometapseudo
---@param module string
function safe_require(module)
    local success, req = pcall(require, module)
    if success then
        return req
    end
    print('Error loading ' .. module)
end

-- Options
safe_require('core.options')

-- Keymaps
safe_require('core.keymaps')

-- Plugins
local plugins = safe_require('plugins')
if plugins == nil then
    return
end

-- Enable module loader
vim.loader.enable()

-- Load plugins
plugins.add('colorscheme')
plugins.add('lsp')
plugins.add('treesitter')
plugins.add('telescope')
plugins.add('editing')
plugins.add('ui')

plugins.load()

-- Custom Commands
safe_require('custom_commands.BufOnly')

-- Colorscheme
vim.cmd.colorscheme 'catppuccin'

-------------------------------------------
