-- Shared LSP capabilities from nvim-cmp (applies to all servers)
vim.lsp.config('*', {
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

-- gopls: the official Go language server
vim.lsp.config('gopls', {
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
        shadow = true,
      },
      staticcheck = true,
      -- gofumpt = true,       -- requires: go install mvdan.cc/gofumpt@latest
      usePlaceholders = true,  -- parameter placeholders from fillstruct
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  },
})

-- Mason: manages LSP server binaries
require('mason').setup()

-- mason-lspconfig v2: bridges Mason-installed servers to vim.lsp.enable()
-- automatic_enable = true is the default — calls vim.lsp.enable('gopls') for us
require('mason-lspconfig').setup({
  ensure_installed = { 'gopls' },
})
