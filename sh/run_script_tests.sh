#!/bin/bash
set -e
readonly MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"
export DONT_PULL_START_POINTS_BASE=true
"${MY_DIR}/../test_script/run_tests.sh" ${*}
