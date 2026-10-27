require('render-markdown').setup {}

vim.keymap.set('n', '<leader>tm', '<cmd>RenderMarkdown toggle<cr>', { desc = 'Toggle markdown rendering' })
