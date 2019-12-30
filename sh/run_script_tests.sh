#!/bin/bash -Eeu

readonly MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"

# pull start-points-base image so its stdout/stderr messages
# do not interfere with test assertions

#readonly BASE_SHA=$(docker run --rm cyberdojo/start-points-base:latest sh -c 'echo -n ${BASE_SHA}')
#readonly TAG=${BASE_SHA:0:7}
#if ! docker inspect --type=image "cyberdojo/start-points-base:${TAG}" ; then
#  docker pull cyberdojo/start-points-base:${TAG}
#fi

"${MY_DIR}/../test_script/run_tests.sh" "$@"
