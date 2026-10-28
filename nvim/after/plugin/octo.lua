local ok, octo = pcall(require, 'octo')
if not ok then return end

octo.setup { picker = 'telescope' }

-- same as: gh search prs --author @me --state open
vim.keymap.set('n', '<leader>gP', '<cmd>Octo search is:pr is:open author:@me<cr>', { desc = 'git: my open PRs (octo)' })
vim.keymap.set('n', '<leader>gQ', '<cmd>Octo search is:pr is:open review-requested:@me<cr>', { desc = 'git: PRs to review (octo)' })

-- my open PRs in one org (or user): prompts for the name, e.g. storebrand-digital
vim.keymap.set('n', '<leader>gO', function()
    vim.ui.input({ prompt = 'Org/user: ' }, function(org)
        if not org or org == '' then return end
        vim.cmd('Octo search is:pr is:open author:@me org:' .. org)
    end)
end, { desc = 'git: my open PRs in an org (octo)' })
