local function session_name()
    local session_ok, session = pcall(require, 'possession.session')
    if not session_ok then return '' end
    local name = session.get_session_name()
    if not name or name == '' then return '' end
    return ' ' .. name
end

local claude = require('yogan.claude')

require('lualine').setup {
    extensions = { 'nvim-tree', 'quickfix' },
    sections = {
        lualine_a = { session_name },
        lualine_c = {
            {
                'filename',
                path = 1,
                symbols = {
                    modified = '',
                    readonly = '󰷤',
                    unnamed = '',
                    newfile = '',
                },
            },
        },
        -- Claude sessions on this machine, e.g. "● 1 needs you ◐ 2 working"
        lualine_x = {
            { claude.statusline('waiting'), color = 'DiagnosticError' },
            { claude.statusline('idle'), color = 'DiagnosticWarn' },
            { claude.statusline('busy'), color = 'DiagnosticInfo' },
            'encoding',
            'fileformat',
            'filetype',
        },
    },
}
