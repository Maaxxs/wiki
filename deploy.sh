#!/bin/bash

set -e

git pull
pipenv run mkdocs build

rm -rf /var/www/html/wiki/*
cp -r ./site/* /var/www/html/wiki


