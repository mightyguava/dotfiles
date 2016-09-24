#!/bin/bash
set -e

USAGE="
$0 [copy] [<target_dir>]

If run without arguments, symlinks the dotfiles to ${HOME}
If 'copy' is provided, copies instead of symlinks, but skips the git submodules
If a <target_dir> is provided, symlinks/copies to target_dir instead of ${HOME}

If run via 'curl <url_to_script> | bash', will try to download and bootstrap the
repo to ${HOME}/.dotfiles and run the symlink strategy.
"

BOOTSTRAP_DIR="${HOME}/.dotfiles"

# Use rsync if copying, ln -sf if symlinking
if [ -n "$1" ]; then
  if [ "$1" == "copy" ]; then
    shift
    COPY=1
    LINK="rsync -a --delete -L"
  else
    echo "${USAGE}"
    exit 1
  fi
else
  LINK="ln -sf"
fi

# Set alternate target dir if provided
if [ "$1" ]; then
  TARGET="$1"
  shift
else
  TARGET="${HOME}"
fi

if [ -z "${BASH_SOURCE[0]}" ]; then
  # Eval'ed into bash, not run as script. Check for repo at ~/.dotfiles or
  # bootstrap.
  if [ ! -d "${BOOTSTRAP_DIR}" ]; then
    git clone https://github.com/mightyguava/dotfiles.git ${HOME}/.dotfiles
    cd "${BOOTSTRAP_DIR}"
  else
    cd "${BOOTSTRAP_DIR}"
    git fetch origin
    git reset --hard origin/master
  fi

  SRC="${BOOTSTRAP_DIR}"
  SHOULD_EXIT=1
else
  HERE=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
  SRC="${HERE}"
fi

${LINK} ${SRC}/zsh/.zshrc ${TARGET}/.zshrc
${LINK} ${SRC}/common/.aliases ${TARGET}/.aliases
${LINK} ${SRC}/common/.git-prompt.sh ${TARGET}/.git-prompt.sh
${LINK} ${SRC}/common/.profile ${TARGET}/.profile
${LINK} ${SRC}/bash/.bashrc ${TARGET}/.bashrc
${LINK} ${SRC}/bash/.git-completion.bash ${TARGET}/.git-completion.bash
${LINK} ${SRC}/git/.gitconfig ${TARGET}/.gitconfig
${LINK} ${SRC}/tmux/.tmux.conf ${TARGET}/.tmux.conf

# Attempt to install cmake if needed for VIM YouCompleteMe plugin
if [ -z "${NO_INSTALL_CMAKE}" ] && ! type cmake &>/dev/null; then
  os=$(uname -s)
  case "$os" in
    Darwin)
      type brew &>/dev/null && brew install cmake || echo "Could not install cmake"
      ;;
    Linux)
      echo "Installing cmake for vim YouCompleteMe plugin. Sudo password may be needed"
      sudo apt-get --assume-yes install cmake || echo "Could not install cmake"
      ;;
    *)
      echo "Unknown OS, don't know how to install cmake"
      ;;
  esac
fi


# VIM stuff
mkdir -p ${TARGET}/.vim
mkdir -p ${TARGET}/.vim/autoload
${LINK} ${SRC}/vim/plug.vim ${TARGET}/.vim/autoload/plug.vim
${LINK} ${SRC}/vim/.vimrc ${TARGET}/.vimrc

rm -rf ${TARGET}/.zsh
if [ -z "$COPY" ]; then
  # Initialize submodules if using symlinks
  git submodule init
  git submodule update
  ${LINK} ${SRC}/zsh ${TARGET}/.zsh

  # Install vim plugins, clean, and quit
  vim +PlugInstall +PlugClean +qa!

  # Link binaries, not part of copy
  mkdir -p ${TARGET}/bin
  ${LINK} ${SRC}/bin/csearch_rel ${TARGET}/bin/csearch_rel
else
  # Copy the non-submodules
  mkdir -p ${TARGET}/.zsh
  ${LINK} ${SRC}/zsh/.git-completion.zsh ${TARGET}/.zsh/.git-completion.zsh
fi

if [ -n "$SHOULD_EXIT" ]; then
  exit 0
fi
