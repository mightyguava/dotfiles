-- Neovim-only configuration orchestrator
-- Loaded via require('user') from ~/.dotfiles/vim/init.lua

-- Always apply: Mason, LSP, CMP
require('user.mason')
require('user.cmp')
require('user.lsp')

-- Optional: DAP debugger (uncomment when delve debugging is needed)
-- require('user.dap')
