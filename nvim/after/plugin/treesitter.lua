-- nvim-treesitter `main` branch: it only installs parsers, highlighting is
-- started by neovim itself (vim.treesitter.start).
local ts = require('nvim-treesitter')
ts.setup {}

local ensure_installed = { 'vimdoc', 'javascript', 'typescript', 'c', 'lua', 'vim', 'rust', 'python' }
ts.install(ensure_installed)

-- like the old `auto_install`: install a missing parser when opening a buffer
vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('yogan_treesitter', { clear = true }),
    callback = function(args)
        local lang = vim.treesitter.language.get_lang(args.match)
        if not lang then return end
        if not pcall(vim.treesitter.start, args.buf, lang) then
            -- parser missing: install in the background, highlight next time
            if vim.tbl_contains(ts.get_available(), lang) then
                ts.install({ lang })
            end
        end
    end,
})
