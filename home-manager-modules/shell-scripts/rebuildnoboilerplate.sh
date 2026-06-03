#!/bin/bash
set -e
#nvim
pushd ~/.dotfiles/
if git diff --quiet '*.nix' || git diff --quiet '*.sh' ; then
    echo "No changes detected, exiting."
    popd
    exit 0
fi
alejandra . &>/dev/null \
  || ( alejandra . ; echo "formatting failed!" && exit 1)
git diff -U0 *.nix
echo "HomeManager Rebuilding..."
home-manager switch --flake ~/.dotfiles/#laptop &>home-manager-switch.log || (
 cat home-manager-switch.log | grep --color error && false)
gen=$(home-manager list-generations | grep current)
git add -A
git commit -m "$1"
echo "change test"
popd
