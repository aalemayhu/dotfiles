local function session_name()
    local session_ok, session = pcall(require, 'possession.session')
    if not session_ok then
        return ''
    end
    local name = session.get_session_name()
    if not name or name == '' then
        return ''
    end
    return ' ' .. name
end

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
                    unnamed  = '',
                    newfile  = '',
                }
            }
        },
    },
}
