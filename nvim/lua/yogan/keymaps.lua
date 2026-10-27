vim.g.mapleader = ' '

-- clear search highlight (<leader>/ is project search now, see telescope.lua)
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR><Esc>', { desc = 'Clear search highlight' })

-- move selected lines up and down, with correct indentation (visual J/K)
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

-- keep cursor in place when joining lines (J)
vim.keymap.set('n', 'J', 'mzJ`z', { desc = 'Join lines' })

-- keep cursor in the middle while scrolling (^U/^D) or searching (n/N)
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Scroll down' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Scroll up' })
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Next search result' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Previous search result' })

-- delete into blackhole register (keep current paste)
vim.keymap.set({ 'n', 'v' }, '<leader>d', [['_d]], { desc = 'Delete (keep yank register)' })
-- copy to system clipboard (works magically from WSL to Windows)
vim.keymap.set({ 'n', 'v' }, '<leader>y', [['+y]], { desc = 'Yank to system clipboard' })

-- code (<leader>c…, LSP adds ca/cr in lsp.lua)
vim.keymap.set(
    'n',
    '<leader>cf',
    function() require('conform').format { lsp_format = 'fallback' } end,
    { desc = 'Format file' }
)

-- quickfix/location list: use the built-in ]q [q ]l [l

-- replace current word under cursor (with live preview)
vim.keymap.set(
    'n',
    '<leader>cs',
    [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = 'Substitute word under cursor' }
)

-- make current file executable (shell scripts)
vim.keymap.set('n', '<leader>cx', '<cmd>!chmod +x %<CR>', { silent = true, desc = 'Make file executable' })

-- Q is left alone: in nvim it replays the last recorded macro

-- same as .vimrc: arrow keys disabled
for _, key in ipairs({ '<Up>', '<Down>', '<Left>', '<Right>' }) do
    vim.keymap.set({ 'n', 'v', 'o' }, key, '<nop>')
end

-- new tab (<C-t> is left alone: it pops the tag stack, e.g. back from gd)
vim.keymap.set('n', '<leader>T', '<cmd>tabnew<CR>', { desc = 'New tab' })

-- same as .vimrc: <F1>..<F10> jump to tab 1..10
for i = 1, 10 do
    vim.keymap.set('n', '<F' .. i .. '>', i .. 'gt', { desc = 'Go to tab ' .. i })
    vim.keymap.set('i', '<F' .. i .. '>', '<Esc>' .. i .. 'gta', { desc = 'Go to tab ' .. i })
    -- also from terminals, e.g. to hop between Claude session tabs
    vim.keymap.set('t', '<F' .. i .. '>', '<C-\\><C-n>' .. i .. 'gt', { desc = 'Go to tab ' .. i })
end

-- Ctrl+/ toggles comments with the built-in gc (terminals send it as <C-_>)
for _, key in ipairs({ '<C-/>', '<C-_>' }) do
    vim.keymap.set('n', key, 'gcc', { remap = true, desc = 'Toggle comment' })
    vim.keymap.set('v', key, 'gc', { remap = true, desc = 'Toggle comment' })
end

-- toggles
vim.keymap.set('n', '<leader>tn', '<cmd>set invnumber<CR>', { desc = 'Toggle line numbers' })
vim.keymap.set('n', '<leader>tl', '<cmd>set invlist<CR>', { desc = 'Toggle invisible char (list mode)' })
vim.keymap.set('n', '<leader>tw', '<cmd>set invwrap<CR>', { desc = 'Toggle line wrapping' })
vim.keymap.set('n', '<leader>ts', '<cmd>set invspell<CR>', { desc = 'Toggle spell checking' })

-- command line, map <C-p>/<C-n> to work like up/down (history /w matching prefix)
-- see https://stackoverflow.com/a/60355468/183582 for a good explanation
local cmd_history_opts = { expr = true, replace_keycodes = false }
vim.keymap.set('c', '<C-p>', 'wildmenumode() ? "\\<C-p>" : "\\<Up>"', cmd_history_opts)
vim.keymap.set('c', '<C-n>', 'wildmenumode() ? "\\<C-n>" : "\\<Down>"', cmd_history_opts)
