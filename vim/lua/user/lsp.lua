-- LSP keymaps and events, attached per-buffer when an LSP client connects
-- gD is intentionally NOT mapped here — preserved for vim-go's go-def-vertical

local lsp_group = vim.api.nvim_create_augroup('UserLspConfig', { clear = true })

vim.api.nvim_create_autocmd('LspAttach', {
  group = lsp_group,
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end

    -- Buffer-local keymap options
    local opts = { buffer = bufnr, silent = true }

    -- Navigation
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)

    -- Hover and signature help
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('i', '<C-s>', vim.lsp.buf.signature_help, opts)

    -- Code actions and rename
    vim.keymap.set({ 'n', 'x' }, '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)

    -- Manual LSP format (async)
    vim.keymap.set('n', '<leader>fo', function()
      vim.lsp.buf.format({ async = true })
    end, opts)

    -- Format on save via LSP (skip Go files — vim-go handles formatting)
    if client.server_capabilities.documentFormattingProvider
        and vim.bo[bufnr].filetype ~= 'go' then
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = bufnr,
        group = lsp_group,
        callback = function()
          vim.lsp.buf.format({ async = false })
        end,
      })
    end

    -- Highlight symbol under cursor on idle
    if client.server_capabilities.documentHighlightProvider then
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = bufnr,
        group = lsp_group,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd('CursorMoved', {
        buffer = bufnr,
        group = lsp_group,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})
