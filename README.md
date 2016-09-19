## Installation

### Option 1 - Install via cURL

`curl https://raw.githubusercontent.com/mightyguava/dotfiles/master/install.sh | bash`

The repo is bootstrapped to `$HOME/.dotfiles`.

### Option 2 - Check out repo and then run install

```
./install.sh [copy] [<target_dir>]

If run without arguments, symlinks the dotfiles to ${HOME}
If 'copy' is provided, copies instead of symlinks, but skips the git submodules
If a <target_dir> is provided, symlinks/copies to target_dir instead of ${HOME}
```

