#!/usr/bin/env bash

# Copyright (c) 2017 Dustin Doloff
# Licensed under Apache License v2.0

set -e

TMP_FOLDER='/tmp/.bazel_travis_toolbox'
BAZEL_FILE="${TMP_FOLDER}/bazel.sh"
BAZEL_SIGNATURE_FILE="${TMP_FOLDER}/bazel.sh.sig"

RELATIVE_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
BAZEL_PUBLIC_KEY="${RELATIVE_ROOT}/bazel-release.pub.gpg"

# Apt repositories needed
APT_REPOSITORIES=(
    ppa:openjdk-r/ppa
    ppa:ubuntu-toolchain-r/test
)

# Package list from http://bazel.io/docs/install.html
BAZEL_APT_DEPS=(
    openjdk-8-jdk
    pkg-config
    unzip
    zip
    zlib1g-dev
)

# Packages necessary to run setup and install scripts
SCRIPT_APT_DEPS=(
    wget
)

# Call before starting an action that doesn't print any output
action_start() {
    message=$1

    echo -n "${message}... "
}

# Call after an action was completed successfully
action_end() {
    echo 'Done'
}

action_start 'Checking inputs'

# Ensure environment variables were set
if [ -z "${BAZEL_VERSION}" ]; then
    echo 'BAZEL_VERSION must be set as an environment variable.'
    exit 1
fi

action_end

action_start 'Creating temp folder'

# Create and clean temp folder
mkdir -p "${TMP_FOLDER}"
rm -rf "${TMP_FOLDER}/*"

action_end

# Add the necessary repositories
for repository in $APT_REPOSITORIES; do
    echo "Adding repository: ${repository}"
    sudo add-apt-repository "${repository}" -y
done

echo 'Updating apt repositories.'

# Update the list of packages available
sudo apt-get update

echo 'Installing dependencies.'

# Install script and bazel apt deps
sudo apt-get install -y ${SCRIPT_APT_DEPS[@]} ${BAZEL_APT_DEPS[@]}

echo 'All packages installed.'

echo 'Updating java alternatives.'

# Set java to be the installed Open JDK 8 package just installed
openjdk_8=$(update-java-alternatives --list | grep '1\.8.*-openjdk' | cut -d' ' -f1)
sudo update-java-alternatives --set "${openjdk_8}"

echo 'Correct java version set.'

echo 'Downloading Bazel installer and signature files.'

bazel_installer_sh="https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-installer-linux-x86_64.sh"
# Download Bazel installer
wget --output-document "${BAZEL_FILE}" "${bazel_installer_sh}"
# Download Bazel installer signature
wget --output-document "${BAZEL_SIGNATURE_FILE}" "${bazel_installer_sh}.sig"

echo 'Bazel downloads complete.'

echo 'Checking Bazel installer signature.'

# Check signature
gpg --import "${BAZEL_PUBLIC_KEY}"
gpg --verify "${BAZEL_SIGNATURE_FILE}" "${BAZEL_FILE}"

echo 'Installer signature verified.'

echo 'Installing Bazel.'

# Install Bazel
chmod +x "${BAZEL_FILE}"
"${BAZEL_FILE}" --user

echo 'Bazel installed.'
