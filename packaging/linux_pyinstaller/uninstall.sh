#!/usr/bin/env bash

DIR=$(realpath $(dirname $0))

pushd "$DIR" > /dev/null

echo "Removing desktop menu entry"
xdg-desktop-menu uninstall ExampleApp.desktop > /dev/null 2>&1
rm ExampleApp.desktop

popd > /dev/null
