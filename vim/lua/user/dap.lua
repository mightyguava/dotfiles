-- DAP debugger configuration for Go
-- Requires plugins: nvim-dap, nvim-dap-go, nvim-dap-ui
-- Enable by uncommenting require('user.dap') in lua/user/init.lua
-- and adding these plugins to the NVIM() block in .vimrc:
--   Plug 'mfussenegger/nvim-dap'
--   Plug 'leoluz/nvim-dap-go'
--   Plug 'rcarriga/nvim-dap-ui'

local dap = require('dap')
local dapui = require('dapui')

-- DAP UI setup
dapui.setup()

-- Auto-open/close DAP UI with debug sessions
dap.listeners.after.event_initialized['dapui_config'] = dapui.open
dap.listeners.before.event_terminated['dapui_config'] = dapui.close
dap.listeners.before.event_exited['dapui_config'] = dapui.close

-- DAP keymaps
vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'Toggle breakpoint' })
vim.keymap.set('n', '<leader>dc', dap.continue, { desc = 'Continue' })
vim.keymap.set('n', '<leader>do', dap.step_over, { desc = 'Step over' })
vim.keymap.set('n', '<leader>di', dap.step_into, { desc = 'Step into' })
vim.keymap.set('n', '<leader>dO', dap.step_out, { desc = 'Step out' })
vim.keymap.set('n', '<leader>dr', dap.repl.toggle, { desc = 'Toggle REPL' })
vim.keymap.set('n', '<leader>du', dapui.toggle, { desc = 'Toggle DAP UI' })

-- nvim-dap-go: Go-specific DAP adapter (delve)
require('dap-go').setup({
  delve = {
    path = vim.fn.exepath('dlv') or 'dlv',
    initialize_timeout = 20,
  },
})
