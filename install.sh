#!/bin/bash
set -e

HERE=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
ln -sf ${HERE}/zsh/.zshrc ${HOME}/.zshrc
ln -sf ${HERE}/common/.aliases ${HOME}/.aliases
ln -sf ${HERE}/common/.profile ${HOME}/.profile
ln -sf ${HERE}/bash/.bashrc ${HOME}/.bashrc
ln -sf ${HERE}/zsh ${HOME}/.zsh

git submodule init
git submodule update
