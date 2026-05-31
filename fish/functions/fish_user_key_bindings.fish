function fish_user_key_bindings
  if command --query fzf
    fzf --fish | source
  end
end
