#!/bin/bash
set -e
readonly MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"
rm -rf "${MY_DIR}/tmp" && mkdir "${MY_DIR}/tmp"
"${MY_DIR}/sh/pipe_build_up.sh"
"${MY_DIR}/sh/run_tests_in_containers.sh"
"${MY_DIR}/sh/run_script_tests.sh"
