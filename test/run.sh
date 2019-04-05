#!/usr/bin/env bash

# Test runner for sdd test suites

set -e

container_id=$(docker run -d -it --rm --volume "$(pwd)":/opt/sdd --workdir /opt/sdd/test sdd:latest)
docker exec $container_id bats -r .
docker kill $container_id
