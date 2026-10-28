-- using this group for all autocmds here allows to re-source
-- this file without having to clear the autocmds first
local group = vim.api.nvim_create_augroup('yogan-autocmds', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
    group = group,
    pattern = { 'TelescopePrompt', 'help' },
    desc = 'Disable cursorline in TelescopePrompt and help',
    command = 'setlocal nocursorline',
})

vim.api.nvim_create_autocmd('VimResized', {
    group = group,
    desc = 'Resize windows when terminal size changes',
    command = 'wincmd =',
})

vim.api.nvim_create_autocmd('TermOpen', {
    group = group,
    desc = 'Setup defaults for new terminal windows',
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.cmd('DisableWhitespace')
        vim.cmd('startinsert')
    end,
})

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    group = group,
    desc = 'Enable spell checking for text files',
    pattern = { '*.txt', '*.md', '*.tex' },
    command = 'setlocal spell',
})

vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold' }, {
    group = group,
    desc = 'Reload files changed outside nvim (e.g. by Claude)',
    callback = function()
        -- :checktime is not allowed in the command-line window
        if vim.fn.getcmdwintype() == '' then vim.cmd('checktime') end
    end,
})

vim.api.nvim_create_autocmd('FileChangedShellPost', {
    group = group,
    desc = 'Say when a buffer was reloaded from disk',
    callback = function(args) vim.notify('Reloaded ' .. vim.fn.fnamemodify(args.file, ':.'), vim.log.levels.INFO) end,
})

-- apply config edits on save, without restarting nvim
local config_dir = vim.uv.fs_realpath(vim.fn.stdpath('config'))
vim.api.nvim_create_autocmd('BufWritePost', {
    group = group,
    pattern = '*.lua',
    desc = 'Reload nvim config files when saved',
    callback = function(args)
        local file = vim.uv.fs_realpath(args.file)
        if not (config_dir and file and vim.startswith(file, config_dir .. '/')) then return end
        local rel = file:sub(#config_dir + 2)

        if rel == 'init.lua' or rel == 'lua/yogan/plugins.lua' then
            vim.notify(rel .. ' saved: run :Lazy sync for plugin changes, other edits need a restart', vim.log.levels.WARN)
            return
        end

        local ok, err
        local module = rel:match('^lua/(.+)%.lua$')
        if module then
            module = module:gsub('/', '.')
            package.loaded[module] = nil
            ok, err = pcall(require, module)
        elseif rel:match('^after/') or rel:match('^ftplugin/') then
            ok, err = pcall(vim.cmd.source, file)
        else
            return
        end

        if ok then
            vim.notify('Reloaded ' .. rel, vim.log.levels.INFO)
        else
            vim.notify('Error reloading ' .. rel .. ':\n' .. tostring(err), vim.log.levels.ERROR)
        end
    end,
})
