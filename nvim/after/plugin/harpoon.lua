local mark = require('harpoon.mark')
local ui   = require('harpoon.ui')

vim.keymap.set('n', '<leader>ha', mark.add_file, { desc = 'Harpoon: add file' })

vim.keymap.set('n', '<leader>h1', function() ui.nav_file(1) end, { desc = 'Harpoon: file 1' })
vim.keymap.set('n', '<leader>h2', function() ui.nav_file(2) end, { desc = 'Harpoon: file 2' })
vim.keymap.set('n', '<leader>h3', function() ui.nav_file(3) end, { desc = 'Harpoon: file 3' })
vim.keymap.set('n', '<leader>h4', function() ui.nav_file(4) end, { desc = 'Harpoon: file 4' })

vim.keymap.set('n', '<leader>hh', ui.toggle_quick_menu, { desc = 'Harpoon: menu' })

local telescope_ok, telescope = pcall(require, 'telescope')
if telescope_ok then
    telescope.load_extension('harpoon')
    vim.keymap.set('n', '<leader>hm', '<cmd>Telescope harpoon marks<cr>', { desc = 'Harpoon: marks (telescope)' })
end
