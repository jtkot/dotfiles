vim.filetype.add({
    extension = {
        hexpat = "hexpat"
    }
})

for name, value in pairs(require'config.opts') do
    vim.o[name] = value
end

for name, value in pairs(require'config.globals') do
    vim.g[name] = value
end

require'setup-lazy'

for keymap in vim.iter(require'config.keymaps') do
    vim.keymap.set(keymap.modes or 'n', keymap.keys, keymap.action, { desc = keymap.desc })
end

local lm = require('language-manager')

local success, result = pcall(lm.setup)
if (not success) then
    print(result)
end

for name, config in pairs(require'config.language-servers') do
    lm.load_lsp(name, config)
end

vim.diagnostic.config(require'config.diagnostic')

for name, definition in pairs(require'config.commands') do
    vim.api.nvim_create_user_command(name, definition.cmd, definition.opts)
end

for cmd in vim.iter(require'config.autostart') do
    vim.cmd(cmd)
end

_G.get_mode_name_short = function ()
    local mode_names = {
        ['n']   = 'NOR',
        ['i']   = 'INS',
        ['v']   = 'SEL',
        ['V']   = 'LIN',
        ['\22'] = 'BLK',
        ['c']   = 'CMD',
        -- TODO: missing terminal. anything else?
    }
    return mode_names[vim.api.nvim_get_mode().mode]
end
