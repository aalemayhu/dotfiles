-- LSP using the native nvim 0.11+ API (vim.lsp.config / vim.lsp.enable),
-- mason for installing servers and nvim-cmp for completion.

local servers = {
    'ts_ls',
    'eslint',
    'lua_ls',
    'rust_analyzer',
    'yamlls',
    'basedpyright',
    'bashls',
    'jsonls',
    -- 'gopls', -- needs a Go toolchain to install
}

-- formatters used by conform.lua, plus shellcheck for bashls diagnostics
local tools = { 'prettierd', 'stylua', 'shfmt', 'ruff', 'shellcheck' }

-- completion capabilities for all servers
vim.lsp.config('*', {
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            diagnostics = {
                -- Fix false positive undefined global '…'
                globals = {
                    'vim',
                    'P',
                    'RELOAD',
                    'R', -- from ../../lua/yogan/globals.lua
                },
            },
        },
    },
})

vim.lsp.config('yamlls', {
    -- https://github.com/redhat-developer/yaml-language-server#language-server-settings
    settings = { yaml = { keyOrdering = false } },
})

require('mason').setup()
require('mason-lspconfig').setup {
    ensure_installed = servers,
    -- enables every installed server with vim.lsp.enable()
    automatic_enable = true,
}
require('mason-tool-installer').setup { ensure_installed = tools }

-- Completion
local cmp = require('cmp')

local cmp_select = { behavior = cmp.SelectBehavior.Select }
cmp.setup {
    snippet = {
        expand = function(args) vim.snippet.expand(args.body) end,
    },
    sources = cmp.config.sources {
        { name = 'nvim_lsp' }, -- lsp
        { name = 'buffer' }, -- text within current buffer
        { name = 'path' }, -- file system paths
    },
    -- Do NOT use <Return> to confirm the menu entry, but use <Ctrl><y>.
    -- The reason for this is to allow abbreviation expansion with <Return>.
    -- <Tab> is left alone as well.
    mapping = cmp.mapping.preset.insert {
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-y>'] = cmp.mapping.confirm { select = true },
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = nil,
        ['<Tab>'] = nil,
        ['<S-Tab>'] = nil,
    },
}

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('yogan_lsp_attach', { clear = true }),
    callback = function(args)
        local bufnr = args.buf
        local opts = function(desc) return { buffer = bufnr, remap = false, desc = desc } end

        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts('Hover'))
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts('Go to definition'))
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts('Go to declaration'))
        vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, opts('Go to type definition'))
        vim.keymap.set('n', 'gl', vim.diagnostic.open_float, opts('Show diagnostics'))
        vim.keymap.set(
            'n',
            '[d',
            function() vim.diagnostic.jump { count = -1, float = true } end,
            opts('Previous diagnostic')
        )
        vim.keymap.set(
            'n',
            ']d',
            function() vim.diagnostic.jump { count = 1, float = true } end,
            opts('Next diagnostic')
        )
        vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, opts('Rename symbol'))
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts('Code action'))
        -- nvim defaults: grr (references), gri (implementation), grt (type
        -- definition), gra/grn, gO (symbols), <C-s> in insert (signature help).
        -- gi (insert at last position) stays untouched.
        -- References under the cursor are highlighted by snacks.words.
    end,
})

vim.diagnostic.config {
    virtual_text = true, -- show inline errors at the end of lines
}
