local lsp = require('lsp-zero')
local lspconfig = require('lspconfig')

lsp.preset('recommended')

lsp.ensure_installed {
    'tsserver',
    'eslint',
    'lua_ls',
    'rust_analyzer',
}

lsp.configure('lua_ls', {
    settings = { Lua = { diagnostics = {
        -- Fix false positive undefined global '…'
        globals = {
            'vim',
            'P', 'RELOAD', 'R', -- from ../../lua/yogan/globals.lua
        }
    } } }
})

-- NOTE: lspconfig seems to be the v2 way of configuring LSPs, but lsp.configure()
-- seems to work as well. Found here:
-- https://old.reddit.com/r/neovim/comments/12kxhkw/neovim_lsp_yamlls_key_ordering_issue/
lspconfig.yamlls.setup({
    -- https://github.com/redhat-developer/yaml-language-server#language-server-settings
    settings = { yaml = { keyOrdering = false } }
})

local cmp = require('cmp')

local cmp_config = lsp.defaults.cmp_config {
    sources = cmp.config.sources {
        { name = 'nvim_lsp' }, -- lsp
        { name = 'luasnip' }, -- snippets
        { name = 'buffer' }, -- text within current buffer
        { name = 'path' }, -- file system paths
    }
}

local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings {
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm { select = true },
    ['<C-Space>'] = cmp.mapping.complete(),
}

-- Do NOT use <Return> to confirm the menu entry, but use <Ctrl><y> (see above)
-- The reason for this is to allow abbreviation expansion with <Return>.
cmp_mappings['<CR>'] = nil

-- Disable completion with <Tab>, those clash with GitHub Copilot.
cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

lsp.setup_nvim_cmp {
    config  = cmp_config,
    mapping = cmp_mappings,
}

lsp.on_attach(function(client, bufnr)
    -- for default key mappings, see:
    -- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/api-reference.md#lsp-actions
    lsp.default_keymaps({
        buffer = bufnr,
        preserve_mappings = false
    })

    local opts = { buffer = bufnr, remap = false }
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)

    -- typescript specific keymaps (e.g. rename file and update imports)
    if client.name == 'tsserver' then
        vim.keymap.set('n', '<leader>rf', ':TypescriptRenameFile<CR>')
        vim.keymap.set('n', '<leader>oi', ':TypescriptOrganizeImports<CR>')
        vim.keymap.set('n', '<leader>ru', ':TypescriptRemoveUnused<CR>')
    end

    -- highlight all references to symbol under cursor
    if client.server_capabilities.documentHighlightProvider then
        local LspDocumentHighlight = vim.api.nvim_create_augroup(
            "lsp_document_highlight", { clear = true })

        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            callback = vim.lsp.buf.document_highlight,
            group = LspDocumentHighlight,
            buffer = bufnr,
            desc = "Highlight symbol under cursor",
        })

        vim.api.nvim_create_autocmd("CursorMoved", {
            callback = vim.lsp.buf.clear_references,
            group = LspDocumentHighlight,
            buffer = bufnr,
            desc = "Clear old highlights",
        })
    end
end)

lsp.setup()

vim.diagnostic.config {
    virtual_text = true, -- show inline errors at the end of lines
}
