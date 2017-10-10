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
    - BAZEL_VERSION='0.6.1'

sudo: required # Required to allow this package to handle installing required packages.

before_install:
    # Install required packages, and download and install Bazel.
    - ./bazel_travis_toolbox/before_install.sh

script:
    # Builds all targets
    - bazel build //...
    # Runs all tests
    - bazel test //...
```
