-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Use a protected call so we don't error out on first use
local status_ok, lazy = pcall(require, 'lazy')
if not status_ok then
    return
end

-- Load the actual plugins
lazy.setup({
    -- Color scheme, status line, icons, indent guides, trailing whitespace
    'EdenEast/nightfox.nvim',
    'nvim-lualine/lualine.nvim',
    'kyazdani42/nvim-web-devicons', -- also used by nvim-tree
    'lukas-reineke/indent-blankline.nvim',
    'ntpeters/vim-better-whitespace',

    -- Comments.nvim
    'numToStr/Comment.nvim',
    'JoosepAlviste/nvim-ts-context-commentstring', -- for jsx/tsx support

    -- Bufferline and close buffers
    { 'akinsho/bufferline.nvim', version = '*', dependencies = 'nvim-tree/nvim-web-devicons' },
    'kazhala/close-buffers.nvim',

    -- File explorer
    { 'nvim-tree/nvim-tree.lua', version = '*' },

    -- Git
    'lewis6991/gitsigns.nvim',

    -- Automatically set indentation settings
    'nmac427/guess-indent.nvim',

    -- Start screen
    { 'goolord/alpha-nvim', dependencies = { 'nvim-tree/nvim-web-devicons' } },

    -- Session management
    { 'jedrzejboczar/possession.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },

    -- Telescope fuzzy thingy
    { 'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' } },
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    'nvim-telescope/telescope-symbols.nvim',

    -- Todo comments
    { 'folke/todo-comments.nvim', dependencies = 'nvim-lua/plenary.nvim' },

    -- Treesitter
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
    },
    'nvim-treesitter/playground',
    'nvim-treesitter/nvim-treesitter-context',

    -- Harpoon (jump around and shit)
    'theprimeagen/harpoon',

    -- Surround
    {
        'kylechui/nvim-surround',
        version = '*',
        config = function()
            require('nvim-surround').setup()
        end
    },

    -- Leap (similar to EasyMotion)
    'ggandor/leap.nvim',

    -- Shows not only key mappings, but also registers, marks, etc.
    {
        'folke/which-key.nvim',
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 500
        end,
        config = function()
            require('which-key').setup()
        end
    },

    -- Undo tree
    'mbbill/undotree',

    -- LSP & Friends
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        dependencies = {
            -- LSP Support
            'neovim/nvim-lspconfig',
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',

            -- Autocompletion
            'hrsh7th/nvim-cmp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'saadparwaiz1/cmp_luasnip',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-nvim-lua',

            -- Snippets
            'L3MON4D3/LuaSnip',
            'rafamadriz/friendly-snippets',
        }
    },
    -- additional functionality for typescript server
    'jose-elias-alvarez/typescript.nvim',

    -- Trouble: project wide diagnostics
    { 'folke/trouble.nvim', dependencies = 'nvim-tree/nvim-web-devicons' },

    -- GitHub Copilot
    'github/copilot.vim',

    -- Find and display URLs
    'axieax/urlview.nvim',

    -- Zen mode
    'folke/zen-mode.nvim',
    'folke/twilight.nvim',

    -- Just for fun
    'eandrju/cellular-automaton.nvim',
}, {
    display = {
        open_fn = function()
            return require('lazy.util').float { border = 'rounded' }
        end
    }
})
