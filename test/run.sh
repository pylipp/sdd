#!/usr/bin/env bash

# Test runner for sdd test suites

# Usage: ./run.sh [--debug]
# Options:
#   --debug         Leave container alive after running the suite
# Environment variables:
#   NO_APP_TESTS    If non-empty, run only framework tests

container_id=$(docker run -d -it --rm --volume "$(pwd)":/opt/sdd --workdir /opt/sdd/test sdd:latest)

if [[ -z $NO_APP_TESTS ]]; then
    docker exec $container_id bats -r .
else
    docker exec $container_id bats -r framework
fi

test_outcome=$?

[ "$1" != "--debug" ] && docker kill $container_id
exit $test_outcome
