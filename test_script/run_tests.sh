#!/bin/bash
set -e

readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"

for glob in "$@"; do
  for test_file in ${my_dir}/test_*${glob}*; do
    ${test_file}
  done
done
