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

BUILD_TAR="ask"
BUILD_DEB="ask"

while true; do
  case "$1" in
    --tar ) BUILD_TAR="$2"; shift 2 ;;
    --deb ) BUILD_DEB="$2"; shift 2 ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done


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
# Create pyinstaller binary
################################################################################
echo "**Creating PyInstaller Binary**"
rm -rf build/ || fail
rm -rf dist/ExampleApp || fail
pyinstaller linux_pyinstaller/linux.spec || fail
cp ../res/icon.png ./dist/ExampleApp
cp ../COPYING ./dist/ExampleApp
cp linux_pyinstaller/install.sh ./dist/ExampleApp
cp linux_pyinstaller/uninstall.sh ./dist/ExampleApp


################################################################################
# Tarball package
################################################################################
if [ "$BUILD_TAR" == "ask" ]; then
    if confirm "Create tar.gz package?"; then
        BUILD_TAR="yes"
    fi
fi
if [ "$BUILD_TAR" == "yes" ]; then
    echo "**Creating tar.gz package**"
    pushd dist > /dev/null
    tar -zcvf ExampleApp-${VERSION}.tar.gz ./ExampleApp/ || fail
    popd > /dev/null
fi


################################################################################
# Deb package
################################################################################
if [ "$BUILD_DEB" == "ask" ]; then
    if confirm "Create deb package?"; then
        BUILD_DEB="yes"
    fi
fi
if [ "$BUILD_DEB" == "yes" ]; then
    echo "**Creating deb package**"

    pushd dist > /dev/null

    # Setup folder structure
    mkdir exampleapp_$VERSION
    mkdir exampleapp_$VERSION/DEBIAN
    mkdir exampleapp_$VERSION/opt
    mkdir exampleapp_$VERSION/opt/ExampleApp

    # Copy files
    cp -r ./ExampleApp/* ./exampleapp_$VERSION/opt/ExampleApp/
    cp ../linux_pyinstaller/deb_control ./exampleapp_$VERSION/DEBIAN/control
    cp ../linux_pyinstaller/deb_prerm ./exampleapp_$VERSION/DEBIAN/prerm
    cp ../linux_pyinstaller/deb_postinst ./exampleapp_$VERSION/DEBIAN/postinst
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