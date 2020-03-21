#!/usr/bin/env bash

# Test runner for sdd test suites

# Usage: ./run.sh [--debug] [--open] [test [test ...]]
# Options:
#   --debug         Attach to container after running tests
#   --open          Attach to container instead of running tests
#   --style         Run style check (linting and formatting)
#
# Arguments:
#   test            Arbitrary bats test files; relative to test/
#                   If omitted, all tests are run
#
# Environment variables:
#   NO_APP_TESTS    If non-empty, run only framework tests. Only
#                   effective if no tests specified

if [ "$1" = "--style" ]; then
    ~/.virtualenvs/sdd/bin/pre-commit run --all-files
    exit $?
fi

if ! command -v docker &>/dev/null; then
    # Assume container environment; e.g. in the context of DockerHub Autobuild/test
    cd /opt/sdd/test || exit 1 # workaround for relative framework/ paths in tests
    bats -r .
    exit $?
fi

container_id=$(docker run -d -it --rm --volume "$(pwd)":/opt/sdd --workdir /opt/sdd/test pylipp/sdd:latest)

if [ "$1" = "--open" ]; then
    docker attach "$container_id"
    exit
fi

DEBUG=false
if [ "$1" = "--debug" ]; then
    DEBUG=true
    shift
fi

if [ $# -gt 0 ]; then
    docker exec "$container_id" bats -r "$@"
elif [[ -z $NO_APP_TESTS ]]; then
    docker exec "$container_id" bats -r .
else
    docker exec "$container_id" bats -r framework
fi

test_outcome=$?

if $DEBUG; then
    docker attach "$container_id"
else
    docker kill "$container_id"
fi

exit $test_outcome
