#!/usr/bin/env bash

# Test runner for sdd test suites

# Usage: ./run.sh [--debug]
# Options:
#   --debug     Leave container alive after running the suite

container_id=$(docker run -d -it --rm --volume "$(pwd)":/opt/sdd --workdir /opt/sdd/test sdd:latest)
docker exec $container_id bats -r .
[ "$1" != "--debug" ] && docker kill $container_id
