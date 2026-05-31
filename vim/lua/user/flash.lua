-- flash.nvim: search-based jump labels, enhanced f/t, treesitter jumps
local flash = require('flash')

flash.setup({
  labels = 'asdfghjklqwertyuiopzxcvbnm',
  modes = {
    -- Search mode (s): type chars, labels on matches, press label to jump
    search = {
      enabled = true,
    },
    -- Enhanced f/t: f + char → labels on all instances, no more ; cycling
    char = {
      enabled = true,
      jump_labels = true,
      -- Disable jump_labels in operator-pending mode so ct/dt/etc.
      -- work without needing an extra label keypress.
      config = function(opts)
        if vim.fn.mode(true):find("o") then
          opts.jump_labels = false
        end
      end,
    },
    -- Treesitter jump: S to jump to any parent node
    treesitter = {
      enabled = true,
      label = { before = true, after = true },
    },
  },
})

-- Keymaps to replace easymotion (<leader><leader>w, <leader><leader>f):
--   s  → search-based jump (normal/visual/operator-pending)
--   S  → treesitter node jump
--   f/t → enhanced with labels
-- These use flash's defaults, no explicit mapping needed
