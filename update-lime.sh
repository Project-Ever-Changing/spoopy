#!/bin/sh

git rm --cached lime-project
rm -rf lime-project
rm -rf .git/modules/lime-project

git commit -m "Removed lime-project submodule"
git push

git submodule add https://github.com/Project-Ever-Changing/lib-lime-project lime-project
git submodule update --init --recursive