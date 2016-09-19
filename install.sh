#!/bin/bash
set -e

USAGE="
$0 [copy] [<target_dir>]

If run without arguments, symlinks the dotfiles to ${HOME}
If "copy" is provided, copies instead of symlinks, but skips the git submodules
If a <target_dir> is provided, symlinks/copies to target_dir instead of ${HOME}
"

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

if [ "$1" ]; then
  TARGET="$1"
else
  TARGET="${HOME}"
fi

HERE=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
${LINK} ${HERE}/zsh/.zshrc ${TARGET}/.zshrc
${LINK} ${HERE}/common/.aliases ${TARGET}/.aliases
${LINK} ${HERE}/common/.profile ${TARGET}/.profile
${LINK} ${HERE}/bash/.bashrc ${TARGET}/.bashrc
${LINK} ${HERE}/bash/.git-completion.bash ${TARGET}/.git-completion.bash

rm -rf ${TARGET}/.zsh
if [ -z "$COPY" ]; then
  # Initialize submodules if using symlinks
  git submodule init
  git submodule update

  ${LINK} ${HERE}/zsh ${TARGET}/.zsh
else
  # Copy the non-submodules
  mkdir -p ${TARGET}/.zsh
  ${LINK} ${HERE}/zsh/.git-completion.zsh ${TARGET}/.zsh/.git-completion.zsh
fi
