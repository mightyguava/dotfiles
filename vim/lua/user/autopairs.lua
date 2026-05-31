-- nvim-autopairs: auto-close pairs with LSP-aware behavior
local npairs = require('nvim-autopairs')

npairs.setup({
  disable_filetype = { 'TelescopePrompt' },
})

-- Integrate with nvim-cmp: handle auto-pairing during completion
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp = require('cmp')
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
