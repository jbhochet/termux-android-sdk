#!/bin/bash

#######################
# Install Android SDK #
#######################

# Variables
DEST=~/Android/Sdk

CMD_LINE_TOOLS="https://dl.google.com/android/repository/commandlinetools-linux-10406996_latest.zip"

SDK_TOOLS="https://github.com/Lzhiyong/android-sdk-tools/releases/download/33.0.3/android-sdk-tools-static-aarch64.zip"

SDKMANAGER=$DEST/cmdline-tools/latest/bin/sdkmanager

echo "Installation script of the Android sdk for termux"

# Cleaning the folder 
echo "All data in $DEST will be deleted !"
read -p "Are you sure ? " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
fi

mkdir -p $DEST
rm -rf $DEST/*
cd $DEST

# Install dependencies
yes | pkg up
yes | pkg i wget openjdk-17 gradle

# Install cmdline-tools
wget $CMD_LINE_TOOLS -O cmdline-tools.zip
unzip cmdline-tools.zip
rm cmdline-tools.zip
mv cmdline-tools latest
mkdir cmdline-tools
mv latest cmdline-tools

# Update sdk
$SDKMANAGER --update

# Setup binary for aarch64
wget $SDK_TOOLS -O sdk_tools.zip
unzip sdk_tools.zip
rm sdk_tools.zip
mkdir -p build-tools
mv aarch64/build-tools build-tools/latest
mv aarch64/platform-tools platform-tools-latest
rm -rf aarch64

# Install platform-tools
yes | $SDKMANAGER "platform-tools"
ln -sf $(pwd)/platform-tools-latest/* $(pwd)/platform-tools/

# Setup environment variables
cat <<EOT > $PREFIX/etc/profile.d/android-sdk.sh
export ANDROID_HOME=$DEST
export PATH=\$PATH:\$ANDROID_HOME/cmdline-tools/latest/bin
EOT

# Setup gradle
mkdir -p ~/.gradle
cat <<EOT > ~/.gradle/gradle.properties
org.gradle.console=rich
android.aapt2FromMavenOverride=$DEST/build-tools/latest/aapt2
EOT

echo "Installation completed !"
echo "Restart termux now !"

