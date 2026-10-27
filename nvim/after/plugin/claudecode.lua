-- Machine-specific settings live in lua/yogan/local.lua (git-ignored, optional).
-- It may return { claude_cmd = '/path/to/claude-or-wrapper' }.
local ok, localcfg = pcall(require, 'yogan.local')
if not ok or type(localcfg) ~= 'table' then localcfg = {} end

require('claudecode').setup {
    terminal_cmd = localcfg.claude_cmd, -- nil: use `claude` from $PATH
}

vim.keymap.set('n', '<leader>ac', '<cmd>ClaudeCode<cr>', { desc = 'Claude: toggle' })
vim.keymap.set('n', '<leader>af', '<cmd>ClaudeCodeFocus<cr>', { desc = 'Claude: focus' })
vim.keymap.set('v', '<leader>as', '<cmd>ClaudeCodeSend<cr>', { desc = 'Claude: send selection' })
vim.keymap.set('n', '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', { desc = 'Claude: add current buffer' })
vim.keymap.set('n', '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', { desc = 'Claude: accept diff' })
vim.keymap.set('n', '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', { desc = 'Claude: deny diff' })

-- in the file tree, <leader>as adds the file under the cursor (or selection)
vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('yogan_claudecode', { clear = true }),
    pattern = 'NvimTree',
    callback = function(args)
        vim.keymap.set(
            'n',
            '<leader>as',
            '<cmd>ClaudeCodeTreeAdd<cr>',
            { buffer = args.buf, desc = 'Claude: add file from tree' }
        )
    end,
})
