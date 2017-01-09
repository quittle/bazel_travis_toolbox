#!/usr/bin/env sh

# Copyright (c) 2017 Dustin Doloff
# Licensed under Apache License v2.0

BAZEL_FILE='bazel.sh'
BAZEL_CHECKSUM_FILE='bazel_checksum.txt'

# Ensure environment variables were set
if [ -z "${BAZEL_VERSION}" ]; then
    echo 'BAZEL_VERSION must be set as an environment variable.'
    exit 1
fi

if [ -z "${BAZEL_SHA256}" ]; then
    echo 'BAZEL_SHA256 must be set as an environment variable.'
    exit 1
fi

# Download Bazel installer
wget --quiet --output-document "${BAZEL_FILE}" "https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-installer-linux-x86_64.sh"

# Check checksum
echo "${BAZEL_SHA256}  ${BAZEL_FILE}" > "${BAZEL_CHECKSUM_FILE}"
sha256sum --check "${BAZEL_CHECKSUM_FILE}"

# Install Bazel
chmod +x "${BAZEL_FILE}"
./"${BAZEL_FILE}" --user