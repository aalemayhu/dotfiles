-- Keep track of all Claude sessions (see lua/yogan/claude.lua)
local claude = require('yogan.claude')

claude.start_watching()

-- <leader><space> is the most used one: what are my sessions doing?
vim.keymap.set('n', '<leader><space>', claude.pick_live, { desc = 'Claude sessions' })
vim.keymap.set('n', '<leader>an', function() claude.open() end, { desc = 'Claude: new session (tab)' })
vim.keymap.set('n', '<leader>al', claude.pick_live, { desc = 'Claude: running sessions' })
vim.keymap.set('n', '<leader>ar', claude.pick_history, { desc = 'Claude: resume session' })

vim.api.nvim_create_user_command(
    'ClaudeNew',
    function(opts) claude.open(opts.args ~= '' and opts.args or nil) end,
    { nargs = '?', complete = 'dir', desc = 'Start Claude in a new tab (in DIR or cwd)' }
)
vim.api.nvim_create_user_command('ClaudeSessions', claude.pick_live, { desc = 'Pick a running Claude session' })
vim.api.nvim_create_user_command('ClaudeResume', claude.pick_history, { desc = 'Resume a past Claude session' })

local group = vim.api.nvim_create_augroup('yogan_claude_sessions', { clear = true })

vim.api.nvim_create_autocmd('BufEnter', {
    group = group,
    desc = 'Type straight into Claude when entering its tab',
    callback = function(args)
        if vim.b[args.buf].claude then vim.cmd.startinsert() end
    end,
})

vim.api.nvim_create_autocmd('TermClose', {
    group = group,
    desc = 'Close the tab of a Claude session that exited cleanly',
    callback = function(args)
        -- another TermClose handler (e.g. snacks/claudecode terminals) may
        -- already have deleted the buffer
        if not vim.api.nvim_buf_is_valid(args.buf) then return end
        if vim.b[args.buf].claude and vim.v.event.status == 0 then
            vim.schedule(function()
                if vim.api.nvim_buf_is_valid(args.buf) then vim.api.nvim_buf_delete(args.buf, { force = true }) end
            end)
        end
    end,
})
