#!/usr/bin/env sh

# Copyright (c) 2017 Dustin Doloff
# Licensed under Apache License v2.0

. ./bazel_args.sh

bazel build $BAZEL_ARGS //...
bazel test $BAZEL_ARGS //...
