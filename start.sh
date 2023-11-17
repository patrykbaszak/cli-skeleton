#!/bin/bash

composer create-project pbaszak/skeleton --no-interaction

rm -rf skeleton/src
cp -r src skeleton/src

rm -rf node_modules src .gitignore CHANGELOG.md composer.json composer.lock README.md LICENSE .git vendor start.sh package.json package-lock.json

mv skeleton/{,.[^.]}* ./

rm -rf skeleton
