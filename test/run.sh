#!/usr/bin/env bash

# Test runner for sdd test suites

# Usage: ./run.sh [--debug] [--open]
# Options:
#   --debug         Attach to container after running tests
#   --open          Attach to container instead of running tests
# Environment variables:
#   NO_APP_TESTS    If non-empty, run only framework tests

container_id=$(docker run -d -it --rm --volume "$(pwd)":/opt/sdd --workdir /opt/sdd/test pylipp/sdd:latest)

if [ "$1" = "--open" ]; then
    docker attach $container_id
    exit
fi


if [[ -z $NO_APP_TESTS ]]; then
    docker exec $container_id bats -r .
else
    docker exec $container_id bats -r framework
fi

test_outcome=$?

if [ "$1" = "--debug" ]; then
    docker attach $container_id
else
    docker kill $container_id
fi

exit $test_outcome
