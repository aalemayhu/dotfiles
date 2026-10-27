-- Only the modules that do not overlap with telescope / zen-mode / ibl / alpha.
require('snacks').setup {
    bigfile = { enabled = true }, -- disable heavy features on huge files
    quickfile = { enabled = true }, -- render the first file before plugins load
    notifier = { enabled = true }, -- nicer vim.notify popups
    input = { enabled = true }, -- nicer vim.ui.input (e.g. LSP rename)
    words = { enabled = true }, -- highlight/jump between LSP references
    rename = { enabled = true },
    gitbrowse = { enabled = true },
    scratch = { enabled = true },
    lazygit = { enabled = true },
}

local snacks = require('snacks')

-- buffers (replaces the old close-buffers maps)
vim.keymap.set('n', '<leader>bd', function() snacks.bufdelete() end, { desc = 'Delete buffer' })
vim.keymap.set('n', '<leader>bo', function() snacks.bufdelete.other() end, { desc = 'Delete other buffers' })

-- jump between references of the word under cursor
vim.keymap.set('n', ']]', function() snacks.words.jump(vim.v.count1) end, { desc = 'Next reference' })
vim.keymap.set('n', '[[', function() snacks.words.jump(-vim.v.count1) end, { desc = 'Previous reference' })

-- git
vim.keymap.set({ 'n', 'v' }, '<leader>go', function() snacks.gitbrowse() end, { desc = 'git: open in browser' })
if vim.fn.executable('lazygit') == 1 then
    vim.keymap.set('n', '<leader>gL', function() snacks.lazygit() end, { desc = 'git: lazygit' })
end

-- scratch buffer
vim.keymap.set('n', '<leader>.', function() snacks.scratch() end, { desc = 'Scratch buffer' })
