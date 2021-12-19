#!/usr/bin/env bash

################################################################################
# Functions
################################################################################

function fail(){
    echo "**Failed!**"
    exit 1
}

function confirm() {
    read -r -p "$1 [y/N] " response
    case "$response" in
        [yY][eE][sS]|[yY]) 
            true
            ;;
        *)
            false
            ;;
    esac
}


################################################################################
# Setup
################################################################################

DIR=$(realpath $(dirname $0))
pushd "$DIR" > /dev/null

VERSION=`head -1 ../res/version.txt`


################################################################################
# Compile UI and resources
################################################################################
echo "**Compiling QT Resources and UI**"
pushd ../ > /dev/null
python compile.py || fail
popd > /dev/null


################################################################################
# Create folder structure
################################################################################
echo "**Creating Package Structure**"
rm -rf build/ || fail
rm -rf dist/ExampleApp || fail

mkdir -p ./dist/ExampleApp/

cp -r ../src/ ./dist/ExampleApp/
cp ../requirements.txt ./dist/ExampleApp/
cp -r ../res/icon.png ./dist/ExampleApp/
cp ../COPYING ./dist/ExampleApp
cp linux_source/install.sh ./dist/ExampleApp
cp linux_source/uninstall.sh ./dist/ExampleApp
cp linux_source/start.sh ./dist/ExampleApp

# Remove pyinstaller from requirements.txt
sed -i "s/pyinstaller//g" ./dist/ExampleApp/requirements.txt

################################################################################
# Tarball package
################################################################################
if confirm "Create tar.gz package?"; then
    echo "**Creating tar.gz package**"
    pushd dist > /dev/null
    tar -zcvf ExampleApp-${VERSION}.tar.gz ./ExampleApp/ || fail
    popd > /dev/null
fi


################################################################################
# Deb package
################################################################################
if confirm "Create deb package?"; then
    echo "**Creating deb package**"

    pushd dist > /dev/null

    # Setup folder structure
    mkdir exampleapp_$VERSION
    mkdir exampleapp_$VERSION/DEBIAN
    mkdir exampleapp_$VERSION/opt
    mkdir exampleapp_$VERSION/opt/ExampleApp

    # Copy files
    cp -r ./ExampleApp/* ./exampleapp_$VERSION/opt/ExampleApp/
    cp ../linux_source/deb_control ./exampleapp_$VERSION/DEBIAN/control
    cp ../linux_source/deb_prerm ./exampleapp_$VERSION/DEBIAN/prerm
    cp ../linux_source/deb_postinst ./exampleapp_$VERSION/DEBIAN/postinst
    chmod 755 ./exampleapp_$VERSION/DEBIAN/*

    # Generate package
    dpkg-deb --build exampleapp_$VERSION || fail

    rm -rf ./exampleapp_$VERSION/

    popd > /dev/null
fi


################################################################################
# Cleanup
################################################################################

rm -rf build/
rm -rf dist/ExampleApp/

popd > /dev/null
