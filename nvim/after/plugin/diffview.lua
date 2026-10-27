require('diffview').setup {}

-- toggle: open a review of all uncommitted changes, or close the open one
vim.keymap.set('n', '<leader>gv', function()
    if require('diffview.lib').get_current_view() then
        vim.cmd('DiffviewClose')
    else
        vim.cmd('DiffviewOpen')
    end
end, { desc = 'git: review changes (diffview)' })
vim.keymap.set('n', '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', { desc = 'git: file history (diffview)' })
vim.keymap.set('n', '<leader>gH', '<cmd>DiffviewFileHistory<cr>', { desc = 'git: branch history (diffview)' })
