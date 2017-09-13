## Installation

### Option 1 - Install via cURL

`curl https://raw.githubusercontent.com/mightyguava/dotfiles/master/install.sh | bash`

The repo is bootstrapped to `$HOME/.dotfiles`.

To disable slow YCM and cmake install for VIM, first run

```
export NO_INSTALL_CMAKE=1
export NO_INSTALL_YCM=1
```

### Option 2 - Check out repo and then run install

```
./install.sh [copy] [<target_dir>]

If run without arguments, symlinks the dotfiles to ${HOME}
If 'copy' is provided, copies instead of symlinks, but skips the git submodules
If a <target_dir> is provided, symlinks/copies to target_dir instead of ${HOME}
```

## The `switch_repos` tool

`switch_repos` is a script for switching between git repositories that follow the Go workspace
convention. You code does not have to be Go, but just that it follows the same directory scheme. See
[How to Write Go Code](https://golang.org/doc/code.html#Workspaces) for details.

`switch_repos` consists of:
- A short bash script
- An alias `g` for activating the script (it cannot be invoked directly as a command)

In addition to switching repos, it also supports entering `virtualenvs` if it detects a Python repo,
and you have previously created a virtualenv using `virtualenvwrapper` with the same name as the repo
root folder.

Finally, it also supports `zsh` autocompletions.

### Installation

First make sure you have
[`virtualenvwrapper`](http://virtualenvwrapper.readthedocs.io/en/latest/install.html) installed.

1. Place `bin/switch_repos` on your `$PATH`, like in `/usr/local/bin`
2. Add this your `.zshrc` or `.bashrc`
```
alias g="source ~/bin/switch_repos"
```
3. If you use zsh, put `zsh/_switch_repos` under `~/.zsh`. (This assumes you have zsh configured to
   support autocompletion at all)
4. Source `.zshrc` or `.bashrc`, or open a new shell.

### Usage

`g <repo_name>` switches to the repo and activates the virtualenv if one exists with the same name
as the repo

`g` at any subfolder in the repo tree will switch to the root.
