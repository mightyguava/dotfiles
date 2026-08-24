if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Device-local overrides (mac vs linux, work vs personal)
if test -f ~/.config/fish/config.local.fish
    source ~/.config/fish/config.local.fish
end
