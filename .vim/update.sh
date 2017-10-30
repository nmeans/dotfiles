#!/usr/bin/env bash
#
# Usage: ./update.sh [pattern]
#
# Specify [pattern] to update only repos that match the pattern.
# 
# Copied from Ian Langworth's dotfiles repo: https://github.com/statico/dotfiles/blob/master/.vim/update.sh

repos=(

  AndrewRadev/splitjoin.vim
  airblade/vim-gitgutter
  altercation/vim-colors-solarized
  christoomey/vim-tmux-navigator
  ervandew/supertab
  godlygeek/tabular
  haya14busa/incsearch.vim
  itchyny/lightline.vim
  jgdavey/tslime.vim
  jgdavey/vim-turbux
  junegunn/fzf.vim
  justinmk/vim-sneak
  kana/vim-textobj-user
  mileszs/ack.vim
  milkypostman/vim-togglelist
  nathanaelkane/vim-indent-guides
  nelstrom/vim-textobj-rubyblock
  scrooloose/nerdtree
  sheerun/vim-polyglot
  tomasr/molokai
  tpope/vim-bundler
  tpope/vim-commentary
  tpope/vim-dispatch
  tpope/vim-endwise
  tpope/vim-eunuch
  tpope/vim-fugitive
  tpope/vim-pathogen
  tpope/vim-ragtag
  tpope/vim-rails
  tpope/vim-rake
  tpope/vim-repeat
  tpope/vim-rhubarb
  tpope/vim-sensible
  tpope/vim-sleuth
  tpope/vim-surround
  tpope/vim-unimpaired
  vim-scripts/IndexedSearch
  w0rp/ale
  wellle/targets.vim

)

set -e
dir=~/.dotfiles/.vim/bundle

if [ -d $dir -a -z "$1" ]; then
  temp="$(mktemp -d -t bundleXXXXX)"
  echo "▲ Moving old bundle dir to $temp"
  mv "$dir" "$temp"
fi

mkdir -p $dir

for repo in ${repos[@]}; do
  if [ -n "$1" ]; then
    if ! (echo "$repo" | grep -i "$1" &>/dev/null) ; then
      continue
    fi
  fi
  plugin="$(basename $repo | sed -e 's/\.git$//')"
  dest="$dir/$plugin"
  rm -rf $dest
  (
    git clone --depth=1 -q https://github.com/$repo $dest
    rm -rf $dest/.git
    echo "· Cloned $repo"
  ) &
done
wait
