#!/usr/bin/env bash

# Copyright (c) 2017 Dustin Doloff
# Licensed under Apache License v2.0

set -e

BAZEL_FILE='bazel.sh'
BAZEL_CHECKSUM_FILE='bazel_checksum.txt'

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

# Ensure environment variables were set
if [ -z "${BAZEL_VERSION}" ]; then
    echo 'BAZEL_VERSION must be set as an environment variable.'
    exit 1
fi

if [ -z "${BAZEL_SHA256}" ]; then
    echo 'BAZEL_SHA256 must be set as an environment variable.'
    exit 1
fi

echo 'Input checks passed.'

# Add the necessary repositories
for repository in $APT_REPOSITORIES; do
    echo "Adding repository: ${repository}"
    sudo add-apt-repository "${repository}" -y
done

# Update the list of packages available
sudo apt-get update

# Install script and bazel apt deps
sudo apt-get install -y ${SCRIPT_APT_DEPS[@]} ${BAZEL_APT_DEPS[@]}

echo 'All packages installed.'

# Set java to be the installed Open JDK 8 package just installed
openjdk_8=$(update-java-alternatives --list | grep '1\.8.*-openjdk' | cut -d' ' -f1)
sudo update-java-alternatives --set "${openjdk_8}"

echo 'Correct java version set.'

# Download Bazel installer
wget --output-document "${BAZEL_FILE}" "https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-installer-linux-x86_64.sh"

echo 'Bazel downloaded.'

# Check checksum
echo "${BAZEL_SHA256}  ${BAZEL_FILE}" > "${BAZEL_CHECKSUM_FILE}"
sha256sum --check "${BAZEL_CHECKSUM_FILE}"

echo 'Downloaded file passed checksum passed checksum.'

# Install Bazel
chmod +x "${BAZEL_FILE}"
./"${BAZEL_FILE}" --user

echo 'Bazel installed.'
