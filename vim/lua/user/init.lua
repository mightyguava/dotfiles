-- Neovim-only configuration orchestrator
-- Loaded via require('user') from ~/.dotfiles/vim/init.lua

-- Always apply: Mason, LSP, CMP, Autopairs
require('user.mason')
require('user.cmp')
require('user.lsp')
require('user.autopairs')

-- Optional: DAP debugger (uncomment when delve debugging is needed)
-- require('user.dap')
