#!/bin/bash
set -e
readonly MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"
rm -rf "${MY_DIR}/tmp" && mkdir "${MY_DIR}/tmp"

# Set this env-var to prevent example derived image
# (and script tests) from re-pulling base image
# (after creating local base image)
export DONT_PULL_START_POINTS_BASE=true

"${MY_DIR}/sh/pipe_build_up.sh"
"${MY_DIR}/sh/run_tests_in_containers.sh"
"${MY_DIR}/sh/run_script_tests.sh"
