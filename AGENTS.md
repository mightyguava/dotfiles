# Dotfiles

Personal dotfiles for macOS and Linux, managed via symlinks (`install.sh`).

## Project structure

```
~/.dotfiles/
├── install.sh          # Bootstrap: symlinks dotfiles to $HOME
├── bash/               # Bash config
├── common/             # Shared shell config (aliases, profile)
├── zsh/                # Zsh config (powerlevel10k, autosuggestions, syntax-highlighting)
├── git/                # Git config
├── tmux/               # Tmux config
├── vim/                # Vim + Neovim config (shared)
│   ├── .vimrc          # Main config, backwards-compatible with Vim 8
│   ├── init.lua        # Neovim entry point: sources .vimrc, require('user')
│   ├── plug.vim        # vim-plug plugin manager (vendored)
│   └── lua/user/       # Neovim-only Lua modules
│       ├── init.lua    # Orchestrator (loads sub-modules)
│       ├── mason.lua   # LSP server management (mason + mason-lspconfig + gopls)
│       ├── cmp.lua     # Completion engine (nvim-cmp)
│       ├── lsp.lua     # LSP keymaps and events (LspAttach)
│       ├── autopairs.lua  # Auto-close pairs (nvim-autopairs)
│       ├── gitsigns.lua   # Git signs and blame (gitsigns.nvim)
│       ├── flash.lua      # Jump navigation (flash.nvim)
│       └── dap.lua        # Debugger (disabled by default)
└── zsh/                # Zsh config
```

## Symlink layout (runtime)

```
~/.vim/          → ~/.dotfiles/vim contents
~/.config/nvim/  → ~/.vim (symlink)
~/.config/nvim/lua  → ~/.dotfiles/vim/lua (symlink, for require() discovery)
~/.vimrc         → ~/.dotfiles/vim/.vimrc
```

## Plugin management

- **vim-plug** (`vim/plug.vim`) — installed via `install.sh` into `~/.vim/autoload/`
- Neovim-only plugins guarded by `if NVIM()` in `.vimrc`
- Vim 8 compatible: no Lua in `.vimrc`, uses `has('nvim')` guards
- Plugins are installed to `~/.vim/plugged/` (Vim) and `~/.config/nvim/plugged/` (Neovim, which resolves to `~/.vim/plugged/` via the symlink)

## Testing changes

```bash
# Test Vim 8 compatibility (must not error)
vim -u ~/.dotfiles/vim/.vimrc -c "qa!"

# Test Neovim Lua modules load
nvim --headless -c "lua require('user')" -c "qa!"

# Install/update plugins
nvim --headless -c "PlugInstall" -c "qa!"
nvim --headless -c "PlugUpdate" -c "qa!"
```

## Key conventions

- **Vim 8 backward compat**: `.vimrc` must always work with `vim -u`. No Lua or Neovim-only features in `.vimrc` itself.
- **Lua modules**: All Neovim-only config goes in `vim/lua/user/`. Loaded via `require('user')`.
- **vim-go + gopls**: vim-go handles build/test/run/coverage/tags. gopls (via LSP) handles code intelligence. `gD` is reserved for vim-go's go-def-vertical.
- **Don't push until asked**: User reviews changes locally. Commit, but wait for explicit instruction before `git push`.
- **Shell**: macOS and Linux. Zsh is the primary managed shell (configs in this repo). Fish is the primary interactive shell (config in `~/.config/fish/`, not in this repo). Bash is minimal — changes must not break bash, but don't need feature parity.
