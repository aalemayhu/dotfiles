-- Machine-specific settings live in lua/yogan/local.lua (git-ignored, optional).
-- It may return { claude_cmd = '/path/to/claude-or-wrapper' }.
local ok, localcfg = pcall(require, 'yogan.local')
if not ok or type(localcfg) ~= 'table' then
    localcfg = {}
end

require('claudecode').setup {
    terminal_cmd = localcfg.claude_cmd, -- nil: use `claude` from $PATH
}

vim.keymap.set('n', '<leader>ac', '<cmd>ClaudeCode<cr>', { desc = 'Claude: toggle' })
vim.keymap.set('n', '<leader>af', '<cmd>ClaudeCodeFocus<cr>', { desc = 'Claude: focus' })
vim.keymap.set('v', '<leader>as', '<cmd>ClaudeCodeSend<cr>', { desc = 'Claude: send selection' })
vim.keymap.set('n', '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', { desc = 'Claude: accept diff' })
vim.keymap.set('n', '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', { desc = 'Claude: deny diff' })
