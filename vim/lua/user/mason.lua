-- Mason: manages LSP servers, formatters, linters
require('mason').setup()

-- mason-lspconfig: bridges Mason-installed servers to lspconfig
require('mason-lspconfig').setup({
  automatic_installation = true,
  ensure_installed = { 'gopls' },
})

-- Default capabilities from nvim-cmp for rich LSP features
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- gopls: the official Go language server
require('lspconfig').gopls.setup({
  capabilities = capabilities,
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
