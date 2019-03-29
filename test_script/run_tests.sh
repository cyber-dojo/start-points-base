#!/bin/bash
set -e

readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"

root_dir()
{
  cd "${my_dir}" && cd .. && pwd
}

export COMMANDER_SCRIPT_NAME="$(root_dir)/cyber-dojo"

# TODO:
# create tmp-dir for cyber-dojo script
# cd ${TMP_DIR}
# curl -O --silent "${GITHUB_ORG}/commander/master/cyber-dojo"
# chmod 700 ./cyber-dojo
# export COMMANDER_SCRIPT_NAME="${TMP_DIR}/cyber-dojo"

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
