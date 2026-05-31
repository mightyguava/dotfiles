-- gitsigns.nvim: async git signs, hunk operations, blame, word diff
local gs = require('gitsigns')

gs.setup({
  signs = {
    add          = { text = '+' },
    change       = { text = '~' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~' },
    untracked    = { text = '┆' },
  },
  signs_staged_enable = true,
  current_line_blame = true,              -- show blame inline at end of line
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol',
    delay = 1000,
  },
  current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> — <summary>',
  on_attach = function(bufnr)
    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    -- Navigation (same as gitgutter defaults)
    map('n', ']c', gs.next_hunk, 'Next hunk')
    map('n', '[c', gs.prev_hunk, 'Prev hunk')

    -- Stage / undo (same as gitgutter defaults)
    map('n', '<leader>hs', gs.stage_hunk, 'Stage hunk')
    map('v', '<leader>hs', function() gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, 'Stage selection')
    map('n', '<leader>hu', gs.reset_hunk, 'Undo hunk')

    -- Preview
    map('n', '<leader>hp', gs.preview_hunk, 'Preview hunk')

    -- Blame (new)
    map('n', '<leader>hb', function() gs.blame_line({ full = true }) end, 'Blame line')

    -- Text object
    map({ 'o', 'x' }, 'ih', gs.select_hunk, 'Select hunk')
  end,
})
