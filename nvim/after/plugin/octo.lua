local ok, octo = pcall(require, 'octo')
if not ok then return end

-- timeout: octo's sync gh calls die after 5s by default, too short for slow GitHub responses
octo.setup { picker = 'telescope', timeout = 20000 }

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

-- my open PRs that are part of a GitHub stack, grouped by repo, top of stack first.
-- octo has no stack filter, so run its own search query and keep stacked results.
local function show_stacked(output)
    local ok_json, nodes = pcall(vim.json.decode, output or '')
    if not ok_json then
        vim.notify('octo: could not load PRs', vim.log.levels.ERROR)
        return
    end

    local stacked = vim.tbl_filter(function(pr)
        return pr.stackEntry and pr.stackEntry ~= vim.NIL
    end, nodes)
    if #stacked == 0 then
        vim.notify('No open PRs in a stack', vim.log.levels.INFO)
        return
    end
    table.sort(stacked, function(a, b)
        local ra, rb = a.repository.nameWithOwner, b.repository.nameWithOwner
        if ra ~= rb then return ra < rb end
        return a.stackEntry.position > b.stackEntry.position
    end)

    local actions = require 'telescope.actions'
    local action_state = require 'telescope.actions.state'
    require('telescope.pickers').new({}, {
        prompt_title = 'My stacked PRs',
        finder = require('telescope.finders').new_table {
            results = stacked,
            entry_maker = require('octo.pickers.telescope.entry_maker').gen_from_issue(6, true),
        },
        sorter = require('telescope.config').values.generic_sorter {},
        previewer = require('octo.pickers.telescope.previewers').issue.new {},
        attach_mappings = function()
            actions.select_default:replace(function(prompt_bufnr)
                local entry = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                if entry then require('octo.utils').get(entry.kind, entry.value, entry.repo) end
            end)
            return true
        end,
    }):find()
end

-- fetched async: a sync call is killed after 5s, which a slow GitHub response can exceed
local function stacked_prs()
    vim.notify('Loading stacked PRs…', vim.log.levels.INFO)
    require('octo.gh').api.graphql {
        query = require('octo.gh.queries').search,
        fields = { prompt = 'is:pr is:open author:@me', type = 'ISSUE' },
        jq = '.data.search.nodes',
        opts = {
            mode = 'async',
            cb = function(output, stderr, status)
                if status ~= 0 then
                    vim.notify('octo: ' .. (stderr ~= '' and stderr or 'gh failed'), vim.log.levels.ERROR)
                    return
                end
                show_stacked(output)
            end,
        },
    }
end
vim.keymap.set('n', '<leader>gT', stacked_prs, { desc = 'git: my stacked PRs (octo)' })
