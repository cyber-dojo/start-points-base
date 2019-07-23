#!/bin/bash
set -e

readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"

readonly BASE_SHA=$(docker run --rm cyberdojo/starter-base:latest sh -c 'echo -n ${BASE_SHA}')
readonly TAG=${BASE_SHA:0:7}

export STARTER_BASE_TAG=${TAG}

if [ "$1" = '' ]; then
  for test_file in ${my_dir}/test_*; do
    ${test_file}
  done
else
  for glob in "$@"; do
    for test_file in ${my_dir}/test_*${glob}*; do
      ${test_file}
    done
  done
fi
