-- <C-h/j/k/l>: move between nvim splits. Inside zellij, hand focus over to the
-- neighbouring zellij pane (or tab, left/right) when at the edge of nvim.
if vim.env.ZELLIJ then
    require('zellij-nav').setup {}

    vim.keymap.set('n', '<C-h>', '<cmd>ZellijNavigateLeftTab<cr>', { silent = true, desc = 'Navigate left (or tab)' })
    vim.keymap.set('n', '<C-j>', '<cmd>ZellijNavigateDown<cr>', { silent = true, desc = 'Navigate down' })
    vim.keymap.set('n', '<C-k>', '<cmd>ZellijNavigateUp<cr>', { silent = true, desc = 'Navigate up' })
    vim.keymap.set('n', '<C-l>', '<cmd>ZellijNavigateRightTab<cr>', { silent = true, desc = 'Navigate right (or tab)' })

    -- make sure zellij is not left locked when nvim exits
    vim.api.nvim_create_autocmd('VimLeave', {
        group = vim.api.nvim_create_augroup('yogan_zellij', { clear = true }),
        command = 'silent !zellij action switch-mode normal',
    })
else
    for key, dir in pairs({ ['<C-h>'] = 'h', ['<C-j>'] = 'j', ['<C-k>'] = 'k', ['<C-l>'] = 'l' }) do
        vim.keymap.set('n', key, '<C-w>' .. dir, { desc = 'Move to window ' .. dir })
    end
end
