vim.keymap.set('n', '<leader>gg', '<cmd>Git<cr>', { desc = 'git: status (fugitive)' })
vim.keymap.set('n', '<leader>gc', '<cmd>Git commit<cr>', { desc = 'git: commit' })

-- Flog needs the buffer (or, for nameless ones, the working directory) to be in a git repo;
-- say so instead of dumping a "not a fugitive buffer" stack trace
vim.keymap.set('n', '<leader>gl', function()
    if vim.fn.FugitiveIsGitDir(vim.fn.FugitiveGitDir()) ~= 1 then
        vim.notify('Not in a git repository (cwd: ' .. vim.uv.cwd() .. '). :cd into one first.', vim.log.levels.WARN)
        return
    end
    vim.cmd('Flog')
end, { desc = 'git: log graph (flog)' })
