local ok, octo = pcall(require, 'octo')
if not ok then return end

octo.setup { picker = 'telescope' }

-- same as: gh search prs --author @me --state open
vim.keymap.set('n', '<leader>gP', '<cmd>Octo search is:pr is:open author:@me<cr>', { desc = 'git: my open PRs (octo)' })
vim.keymap.set('n', '<leader>gQ', '<cmd>Octo search is:pr is:open review-requested:@me<cr>', { desc = 'git: PRs to review (octo)' })
