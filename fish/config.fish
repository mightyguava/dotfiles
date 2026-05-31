if status is-interactive
    # Commands to run in interactive sessions can go here
end

# mise version manager
if command --query mise
    mise activate fish | source
end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# Device-local overrides (mac vs linux, work vs personal)
if test -f ~/.config/fish/config.local.fish
    source ~/.config/fish/config.local.fish
end
