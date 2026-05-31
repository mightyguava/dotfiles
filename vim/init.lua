-- Source the shared .vimrc (backward compatible with Vim 8)
vim.cmd('source ~/.vimrc')

-- Load Neovim-only Lua configuration modules
require('user')