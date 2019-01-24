#!/bin/bash
set -e
readonly SH_DIR="$( cd "$( dirname "${0}" )/sh" && pwd )"
"${SH_DIR}/pipe_build_up.sh"
"${SH_DIR}/run_tests_in_containers.sh"
"${SH_DIR}/run_script_tests.sh"
