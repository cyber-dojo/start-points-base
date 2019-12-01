#!/bin/bash
set -e

readonly MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"

# pull starter-base image so its stdout/stderr messages
# do not interfere with test assertions
export $(docker run --rm cyberdojo/versioner:latest sh -c 'cat /app/.env')
docker pull cyberdojo/starter-base:${CYBER_DOJO_STARTER_BASE_TAG}

"${MY_DIR}/../test_script/run_tests.sh" ${*}
