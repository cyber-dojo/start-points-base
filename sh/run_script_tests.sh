#!/bin/bash -Eeu

readonly MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

"${MY_DIR}/../test_script/run_tests.sh" "$@"
