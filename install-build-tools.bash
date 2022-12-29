#!/bin/bash

#######################
# Install build-tools #
#######################

# Variables
DEST=~/Android/Sdk

BUILD_TOOLS="https://dl.google.com/android/repository/build-tools_r30.0.3-linux.zip"
BUILD_TOOLS_VERSION="30.0.3"


cd $DEST

# Setup build-tools
wget $BUILD_TOOLS -O build-tools.zip
unzip build-tools.zip -d build-tools/$BUILD_TOOLS_VERSION
rm build-tools.zip
cd build-tools/$BUILD_TOOLS_VERSION
mv android-*/* .
rm -rf android-*

# Patch build-tools
cd ..
ln -sf $(pwd)/latest/* $(pwd)/$BUILD_TOOLS_VERSION/

