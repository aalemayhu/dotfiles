-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Use a protected call so we don't error out on first use
local status_ok, lazy = pcall(require, 'lazy')
if not status_ok then return end

-- Load the actual plugins
lazy.setup({
    -- Color scheme, status line, icons, indent guides, trailing whitespace
    {
        'EdenEast/nightfox.nvim',
        priority = 1000, -- load before everything that derives colors from it
        config = function() require('yogan.colors') end,
    },
    'nvim-lualine/lualine.nvim',
    'nvim-tree/nvim-web-devicons', -- also used by nvim-tree
    'lukas-reineke/indent-blankline.nvim',
    'ntpeters/vim-better-whitespace',

    -- File explorer
    { 'nvim-tree/nvim-tree.lua', version = '*' },

    -- Git
    'lewis6991/gitsigns.nvim',

    -- Start screen
    { 'goolord/alpha-nvim', dependencies = { 'nvim-tree/nvim-web-devicons' } },

    -- Session management
    { 'jedrzejboczar/possession.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },

    -- Telescope fuzzy thingy
    { 'nvim-telescope/telescope.nvim', branch = 'master', dependencies = { 'nvim-lua/plenary.nvim' } },
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },

    -- Treesitter
    {
        'nvim-treesitter/nvim-treesitter',
        branch = 'main', -- the rewrite; no more nvim-treesitter.configs
        lazy = false,
        build = ':TSUpdate',
    },
    -- (playground is obsolete: use the built-in :InspectTree / :Inspect)

    -- Render markdown (headings, tables, code blocks) in the buffer
    'MeanderingProgrammer/render-markdown.nvim',

    -- Shows not only key mappings, but also registers, marks, etc.
    {
        'folke/which-key.nvim',
        event = 'VeryLazy',
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 500
        end,
        config = function()
            local wk = require('which-key')
            wk.setup {
                -- groups first, then single keys (the default puts groups last)
                sort = { 'local', 'order', function(item) return item.group and 0 or 1 end, 'alphanum', 'mod' },
            }
            -- group names also pick which-key's icons (ai, buffer, find, git, …)
            wk.add {
                { '<leader>a', group = 'ai (claude)' },
                { '<leader>b', group = 'buffers' },
                { '<leader>f', group = 'find' },
                { '<leader>g', group = 'git' },
                { '<leader>j', group = 'jira' },
                { '<leader>t', group = 'toggles' },
            }
        end,
    },

    -- Review changes across files (e.g. everything Claude touched)
    'sindrets/diffview.nvim',

    -- GitHub PRs and issues inside nvim (needs `gh auth login`)
    {
        'pwntester/octo.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope.nvim',
            'nvim-tree/nvim-web-devicons',
        },
    },

    -- Jira board, tasks and JQL queries (:Jira auth login to sign in)
    'letieu/jira.nvim',

    -- snacks.nvim: small QoL modules (bigfile, notifier, bufdelete, words, ...)
    { 'folke/snacks.nvim', priority = 1000, lazy = false },

    -- Zellij: <C-h/j/k/l> moves between nvim splits and zellij panes
    'swaits/zellij-nav.nvim',

    -- Claude Code integration
    { 'coder/claudecode.nvim', dependencies = { 'folke/snacks.nvim' } },
}, {
    rocks = { enabled = false }, -- no plugin needs luarocks
    display = {
        open_fn = function() return require('lazy.util').float { border = 'rounded' } end,
    },
})
