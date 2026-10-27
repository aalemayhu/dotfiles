vim.api.nvim_set_hl(0, 'NvimTreeNormal', { link = 'BufferInactive' })
vim.api.nvim_set_hl(0, 'NvimTreeOpenedFile', { link = 'BufferVisible' })
vim.api.nvim_set_hl(0, 'NvimTreeModifiedFile', { link = 'BufferVisibleMod' })

require('nvim-tree').setup {
    hijack_unnamed_buffer_when_opening = true,
    hijack_cursor = true,
    actions = {
        open_file = {
            quit_on_open = true,
        },
    },
    modified = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = false,
    },
    filters = {
        custom = { '^\\.git', '^node_modules' },
    },
    renderer = {
        group_empty = true, -- show foo/bar/quz/ in single line
        symlink_destination = false,
        highlight_opened_files = 'all',
        highlight_modified = 'all',
        highlight_git = true,
        icons = {
            git_placement = 'before',
            show = {
                modified = true,
            },
            glyphs = {
                modified = '',
            },
        },
    },
    update_focused_file = {
        enable = true,
    },
    view = {
        adaptive_size = true,
        width = 8, -- with adaptive_size, we can use a very low minimum
        side = 'right',
        signcolumn = 'no', -- only useful with e.g. diagnostics.enable = true
    },
}

vim.keymap.set('n', '<leader>n', ':NvimTreeToggle<CR>', { desc = 'Toggle file tree' })

-- :q in the last real window should exit nvim, not leave the tree open on its own
vim.api.nvim_create_autocmd('BufEnter', {
    group = vim.api.nvim_create_augroup('yogan_nvimtree_autoclose', { clear = true }),
    nested = true,
    desc = 'Quit nvim when the file tree is the only window left',
    callback = function()
        if #vim.api.nvim_list_wins() == 1 and vim.bo.filetype == 'NvimTree' then vim.cmd('quit') end
    end,
})
