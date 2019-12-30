#!/bin/bash
set -e

readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"

# Set CYBER_DOJO_STARTER_BASE_TAG so we tunnel through
# cyberdojo -> cyber-dojo-inner -> cat-start-point-create.sh
readonly BASE_SHA=$(cd "${my_dir}" && cd .. && git rev-parse HEAD)
readonly TAG=${BASE_SHA:0:7}
export CYBER_DOJO_START_POINTS_BASE_TAG=${TAG}

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
