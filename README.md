# Welcome to the Bazel Travis Toolbox ![Travis CI Build Status](https://travis-ci.org/quittle/bazel_travis_toolbox.svg?branch=master)

The goal of this repository is to make it as simple as possible to add [Travis CI](https://travis-ci.org) build support for Bazel projects on Travis.

## Why use this?

Travis is a great tool for automatically building and testing changes to projects, but can be tedious and fickle to set up for every project. The intention of this repository is to consolidate as much of the work and duplicate code between projects as possible and reduce the complexity of the `.travis.yml` as much as possible.

## Integration

1. Add this as a submodule
```bash
    git submodule add https://github.com/quittle/bazel_travis_toolbox
```
2. Create the `.travis.yml` file in the root of the repository
3. Add the following to `.travis.yml`
```yml
env:
    # Environment variables are where input to the travis toolbox goes. Add the version of Bazel
    # required for the project.
    - BAZEL_VERSION='0.4.3'

dist: trusty # Bazel requires a version of LIBSTDC that's not available in precise

sudo: required # Required to allow this package to handle installing required packages.

before_install:
    # Install required packages, and download and install Bazel.
    - ./bazel_travis_toolbox/before_install.sh

script:
    # Performs `bazel build //...` with neccessary flags set. Use this script if the repository does
    # not have any tests.
    - ./bazel_travis_toolbox/bazel_build.sh
    # Performs `bazel build //... && bazel test //...` with necessary flags set. Use this script if
    # the repository does have tests. No need to use `bazel_build.sh` if using this script.
    - ./bazel_travis_toolbox/bazel_build_and_test.sh
```