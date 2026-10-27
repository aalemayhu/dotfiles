-- LSP using the native nvim 0.11+ API (vim.lsp.config / vim.lsp.enable),
-- mason for installing servers and nvim-cmp for completion.

local servers = { 'ts_ls', 'eslint', 'lua_ls', 'rust_analyzer', 'yamlls' }

-- completion capabilities for all servers
vim.lsp.config('*', {
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

vim.lsp.config('lua_ls', {
    settings = { Lua = { diagnostics = {
        -- Fix false positive undefined global '…'
        globals = {
            'vim',
            'P', 'RELOAD', 'R', -- from ../../lua/yogan/globals.lua
        }
    } } }
})

vim.lsp.config('yamlls', {
    -- https://github.com/redhat-developer/yaml-language-server#language-server-settings
    settings = { yaml = { keyOrdering = false } }
})

require('mason').setup()
require('mason-lspconfig').setup {
    ensure_installed = servers,
    -- enables every installed server with vim.lsp.enable()
    automatic_enable = true,
}

-- Completion
local cmp = require('cmp')
local luasnip = require('luasnip')

local cmp_select = { behavior = cmp.SelectBehavior.Select }
cmp.setup {
    snippet = {
        expand = function(args) luasnip.lsp_expand(args.body) end,
    },
    sources = cmp.config.sources {
        { name = 'nvim_lsp' }, -- lsp
        { name = 'luasnip' }, -- snippets
        { name = 'buffer' }, -- text within current buffer
        { name = 'path' }, -- file system paths
    },
    -- Do NOT use <Return> to confirm the menu entry, but use <Ctrl><y>.
    -- The reason for this is to allow abbreviation expansion with <Return>.
    -- <Tab> is left alone as well, it clashes with GitHub Copilot.
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
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local opts = function(desc) return { buffer = bufnr, remap = false, desc = desc } end

        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts('Hover'))
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts('Go to definition'))
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts('Go to declaration'))
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts('Go to implementation'))
        vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, opts('Go to type definition'))
        vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, opts('Signature help'))
        vim.keymap.set('n', 'gl', vim.diagnostic.open_float, opts('Show diagnostics'))
        vim.keymap.set('n', '[d', function() vim.diagnostic.jump { count = -1, float = true } end,
            opts('Previous diagnostic'))
        vim.keymap.set('n', ']d', function() vim.diagnostic.jump { count = 1, float = true } end,
            opts('Next diagnostic'))
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts('Rename'))
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts('Code action'))
        -- gr/grr (references) and gra/grn/gri are nvim defaults

        -- highlight all references to symbol under cursor
        if client and client.server_capabilities.documentHighlightProvider then
            local group = vim.api.nvim_create_augroup('lsp_document_highlight', { clear = false })
            vim.api.nvim_clear_autocmds { group = group, buffer = bufnr }

            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                callback = vim.lsp.buf.document_highlight,
                group = group,
                buffer = bufnr,
                desc = 'Highlight symbol under cursor',
            })

            vim.api.nvim_create_autocmd('CursorMoved', {
                callback = vim.lsp.buf.clear_references,
                group = group,
                buffer = bufnr,
                desc = 'Clear old highlights',
            })
        end
    end,
})

vim.diagnostic.config {
    virtual_text = true, -- show inline errors at the end of lines
}
