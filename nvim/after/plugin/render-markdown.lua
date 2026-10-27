require('render-markdown').setup {
    latex = { enabled = false }, -- needs latex2text/utftex, which aren't installed
}

vim.keymap.set('n', '<leader>tm', '<cmd>RenderMarkdown toggle<cr>', { desc = 'Toggle markdown rendering' })
