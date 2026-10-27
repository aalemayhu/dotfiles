require('bufferline').setup {
    highlights = {
        buffer_selected = { italic = true },
    },
    options = {
        separator_style = 'slant',
        modified_icon = '',
        show_buffer_close_icons = false,
        show_close_icon = false,
        offsets = {
            {
                filetype = 'NvimTree',
                text = function()
                    return '  ' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
                end,
                separator = true, -- uses offset_separator colors
                highlight = 'BufferLineFill',
            }
        },
    }
}

-- NOTE: we have to call this a second time (after colors.lua), otherwise stuff
-- is broken :-/
vim.cmd('colorscheme nightfox')

vim.keymap.set('n', '<leader>bb', '<cmd>BufferLinePick<cr>',
    { noremap = true, silent = true, desc = 'Jump to buffer' }
)
vim.keymap.set('n', '<leader>bj', '<cmd>BufferLineCycleNext<cr>',
    { noremap = true, silent = true, desc = 'Next buffer' }
)
vim.keymap.set('n', '<leader>bk', '<cmd>BufferLineCyclePrev<cr>',
    { noremap = true, silent = true, desc = 'Previous buffer' }
)
vim.keymap.set('n', '<leader>bl', '<cmd>BufferLineMoveNext<cr>',
    { noremap = true, silent = true, desc = 'Move buffer right' }
)
vim.keymap.set('n', '<leader>bh', '<cmd>BufferLineMovePrev<cr>',
    { noremap = true, silent = true, desc = 'Move buffer left' }
)
vim.keymap.set('n', '<leader>bp', '<cmd>BufferLineTogglePin<cr>',
    { noremap = true, silent = true, desc = 'Pin/unpin buffer' }
)
vim.keymap.set('n', '<leader>bc', '<cmd>BufferLinePickClose<cr>',
    { noremap = true, silent = true, desc = 'Close buffer' }
)
