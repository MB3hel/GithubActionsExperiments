#!/usr/bin/env bash

DIR=$(realpath $(dirname $0))

pushd "$DIR" > /dev/null

if touch test.txt; then
    rm test.txt
else
    echo "Run as root."
    exit 2
fi

# Desktop menu entry
xdg-desktop-menu uninstall ExampleApp.desktop > /dev/null 2>&1
echo "Adding desktop menu entry"
printf "[Desktop Entry]\nVersion=1.1\nType=Application\nTerminal=false\nName=ExampleApp\nComment=\nIcon=$DIR/icon.png\nExec=$DIR/ExampleApp\nActions=\nCategories=Development;\nStartupNotify=true\nStartupWMClass=com-example-app\n" > ExampleApp.desktop
xdg-desktop-menu install --novendor ExampleApp.desktop

popd > /dev/null
