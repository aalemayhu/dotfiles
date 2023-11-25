require('nightfox').setup {
    options = {
        transparent = false, -- Disable setting background
        dim_inactive = true, -- Non focused panes set to alternative background
        styles = {
            comments = 'italic',
            -- keywords = 'italic',
            -- functions = 'italic',
            -- strings = 'italic',
            -- variables = 'italic',
        },
    },
    groups = {
        nightfox = {
            ColorColumn         = { bg = 'bg0' },
            CursorLine          = { bg = 'bg2' },
            LineNr              = { fg = 'bg4', bg = 'bg0' },
            Substitute          = { bg = 'palette.yellow.dim' },
            NvimTreeSpecialFile = { fg = 'palette.green.dim' },
        },
    },
}

-- Setting a dimmed red (taken from color scheme) as backgroud for trailing
-- whitespace. Needs to be at the very end, any further call to 'colorscheme'
-- resets to the default full bright red. :-/
local spec = require('nightfox.spec').load('nightfox')
-- print(vim.inspect(spec.palette)) -- for finding stuff
vim.g.better_whitespace_guicolor = spec.palette.red.dim

vim.cmd('colorscheme nightfox')
