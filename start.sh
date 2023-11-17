#!/bin/bash

composer create-project pbaszak/skeleton --no-interaction

rm -rf skeleton/src
cp -r src skeleton/src
