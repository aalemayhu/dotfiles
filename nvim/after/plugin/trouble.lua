require('trouble').setup { padding = false }

vim.keymap.set('n', '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>',
    { silent = true, noremap = true, desc = 'Trouble: toggle diagnostics window' }
)
vim.keymap.set('n', '<leader>xw', '<cmd>Trouble diagnostics toggle<cr>',
    { silent = true, noremap = true, desc = 'Trouble: workspace mode' }
)
vim.keymap.set('n', '<leader>xd', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
    { silent = true, noremap = true, desc = 'Trouble: document mode' }
)

-- Different from <leader>x? scheme, instead similar to LSP's gr (go to refs)
vim.keymap.set('n', 'gR', '<cmd>Trouble lsp_references toggle<cr>',
    { silent = true, noremap = true, desc = 'Trouble: LSP references' }
)
