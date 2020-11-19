#!/usr/bin/env bash

# Test runner for sdd test suites

# Usage: ./run.sh [--debug] [--open] [test [test ...]]
# Options:
#   --debug         Attach to container after running tests
#   --open          Attach to container instead of running tests
#   --style         Run style check (linting and formatting)
#
# Arguments:
#   test            Arbitrary bats test files; relative to repository root
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
    # Assume container environment using repository root as working directory
    # e.g. in the context of DockerHub Autobuild/test
    bats -r test
    exit $?
fi

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ROOT_DIR="$( cd "$SCRIPT_DIR"/.. && pwd )"

container_id=$(docker run -d -it --rm --volume "$ROOT_DIR":/opt/sdd --workdir /opt/sdd pylipp/sdd:latest)

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
    docker exec "$container_id" bats -r test
else
    docker exec "$container_id" bats -r test/framework
fi

test_outcome=$?

if $DEBUG; then
    docker attach "$container_id"
else
    docker kill "$container_id"
fi

exit $test_outcome
