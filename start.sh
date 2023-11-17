#!/bin/bash

composer create-project pbaszak/skeleton --no-interaction

rm -rf skeleton/src
cp -r src skeleton/src

rm -rf .gitignore composer.json composer.lock README.md LICENSE .git vendor start.sh

mv skeleton/{,.[^.]}* ./

rm -rf skeleton
