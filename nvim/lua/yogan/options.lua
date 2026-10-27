vim.opt.number = false
vim.opt.relativenumber = false

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true

-- search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.showbreak = ' ↪  '
vim.opt.listchars = {
    nbsp = '␣',
    tab = '»┄',
    trail = '·',
    eol = '↵',
    extends = '›',
    precedes = '‹',
}

vim.opt.scrolloff = 8
vim.opt.signcolumn = 'yes'

vim.opt.foldmethod = 'indent' -- treesitter.lua switches to expr when a parser exists
vim.opt.foldlevelstart = 99

vim.opt.updatetime = 250 -- CursorHold delay (no swapfile, so only that)

vim.opt.wrap = true
vim.opt.textwidth = 80
vim.opt.colorcolumn = '+1,+20'

vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.laststatus = 3 -- one global status line at the bottom

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.spelllang = 'en_us'
vim.opt.spellsuggest = 'best,9'

-- vim-better-whitespace: no <leader>s operator (use :StripWhitespace instead)
vim.g.better_whitespace_operator = ''

-- no plugin here uses the remote-plugin hosts; skip loading them
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
