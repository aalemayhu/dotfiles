require('conform').setup {
    formatters_by_ft = {
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        typescript = { 'prettierd', 'prettier', stop_after_first = true },
        javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        json = { 'prettierd', 'prettier', stop_after_first = true },
        yaml = { 'prettierd', 'prettier', stop_after_first = true },
        markdown = { 'prettierd', 'prettier', stop_after_first = true },
        css = { 'prettierd', 'prettier', stop_after_first = true },
        html = { 'prettierd', 'prettier', stop_after_first = true },
        rust = { 'rustfmt' },
        go = { 'gofmt' },
        sh = { 'shfmt' },
        bash = { 'shfmt' },
        python = { 'ruff_format', 'black', stop_after_first = true },
        lua = { 'stylua' },
    },
    -- format on save with whatever formatter is installed, else the LSP
    format_on_save = { timeout_ms = 1000, lsp_format = 'fallback' },
}
