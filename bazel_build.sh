#!/usr/bin/env sh

# Copyright (c) 2017 Dustin Doloff
# Licensed under Apache License v2.0

parent_dir=$(dirname "$0")
. "${parent_dir}/bazel_args.sh"

bazel build $BAZEL_ARGS //...
