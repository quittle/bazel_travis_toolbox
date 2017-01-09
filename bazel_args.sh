# Copyright (c) 2017 Dustin Doloff
# Licensed under Apache License v2.0

# Sandbox is currently broken when run on travis so disable it
# https://groups.google.com/d/msg/bazel-discuss/ddymoZ_Ed_g/Ap4LvSD-DQAJ
_DISABLE_SANDBOX='--spawn_strategy=standalone'

_JOBS='--jobs=4'

export BAZEL_ARGS="$_DISABLE_SANDBOX $_JOBS"
