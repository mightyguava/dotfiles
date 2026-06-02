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

## The `switch_repos` tool

`switch_repos` is a script for quickly jumping between git repositories.
It ships in two flavours — a fish function and a bash/zsh script — both with
the same interface:

- `g <repo_name>` — cd into the named repo
- `g` — cd to the root of the current git repo
- `g -ls` — list all known repos

### Aliasing

**Fish** — the alias `g` is set automatically (`fish/conf.d/switch_repos.fish`).

**Bash / Zsh** — add to your `.bashrc` or `.zshrc`:

```sh
alias g="source ~/bin/switch_repos"
```

The script must be *sourced* (not executed) so it can `cd` the calling shell.

### Configuration

Search roots are controlled by the variable `SWITCH_REPOS_ROOTS`.
It defaults to `~/Projects ~/Development`.  Override it in your shell's rc:

**Fish** (`~/.config/fish/config.local.fish`):

```fish
set -g SWITCH_REPOS_ROOTS ~/Projects ~/src ~/work/repos
```

**Bash / Zsh** (`.bashrc` or `.zshrc`):

```sh
export SWITCH_REPOS_ROOTS="$HOME/Projects $HOME/Development $HOME/src"
```

The script searches up to 3 levels deep under each root, looking for `.git`
directories.  It prefers [`fd`](https://github.com/sharkdp/fd) when installed;
otherwise falls back to `find`.
