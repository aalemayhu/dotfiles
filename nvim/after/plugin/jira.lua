local ok, jira = pcall(require, 'jira')
if not ok then return end

-- credentials are not kept here: run :Jira auth login once (stored in nvim's data dir)
jira.setup {}

-- :Jira <PROJECT_KEY> opens the board; the key is prompted for if left out
vim.keymap.set('n', '<leader>jj', '<cmd>Jira<cr>', { desc = 'jira: board' })
vim.keymap.set('n', '<leader>jc', '<cmd>Jira create<cr>', { desc = 'jira: create issue' })
vim.keymap.set('n', '<leader>ji', function()
    vim.ui.input({ prompt = 'Issue key: ' }, function(key)
        if key and key ~= '' then vim.cmd('Jira info ' .. key) end
    end)
end, { desc = 'jira: open issue' })
