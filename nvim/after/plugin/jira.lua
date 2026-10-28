local ok, jira = pcall(require, 'jira')
if not ok then return end

-- credentials are not kept here: run :Jira auth login once (stored in nvim's data dir)
jira.setup {
    -- our boards are Kanban (no sprints), so the default openSprints() query is empty:
    -- the "Active Sprint" view shows everything not done instead
    active_sprint_query = "project = '%s' AND statusCategory != Done ORDER BY Rank ASC",
}

-- :Jira <PROJECT_KEY> opens the board; the key is prompted for if left out
vim.keymap.set('n', '<leader>jj', '<cmd>Jira<cr>', { desc = 'jira: board' })
vim.keymap.set('n', '<leader>jc', '<cmd>Jira create<cr>', { desc = 'jira: create issue' })
vim.keymap.set('n', '<leader>ji', function()
    vim.ui.input({ prompt = 'Issue key: ' }, function(key)
        if key and key ~= '' then vim.cmd('Jira info ' .. key) end
    end)
end, { desc = 'jira: open issue' })

-- my open tasks across all projects: the board's "My Tasks" saved JQL query.
-- load_view needs a project key even though this query ignores it; remember the last one.
vim.keymap.set('n', '<leader>jm', function()
    local board = require 'jira.board'
    local state = require 'jira.board.state'
    local queries = require('jira.common.config').options.queries or {}
    local jql = queries['My Tasks']
    if not jql then
        vim.notify("jira: no saved query named 'My Tasks'", vim.log.levels.ERROR)
        return
    end
    vim.ui.input({ prompt = 'Jira project key: ', default = state.project_key or '' }, function(key)
        if not key or key == '' then return end
        state.current_query = 'My Tasks'
        state.custom_jql = jql:format(key)
        board.load_view(key, 'JQL')
    end)
end, { desc = 'jira: my tasks' })
