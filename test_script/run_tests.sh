#!/bin/bash
set -e

readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"

root_dir()
{
  cd "${my_dir}" && cd .. && pwd
}

export COMMANDER_SCRIPT_NAME="$(root_dir)/cyber_dojo_start_points_create.sh"

#export COMMANDER_SCRIPT_NAME="$(root_dir)/../commander/cyber-dojo"
# "$(root_dir)/tmp/cyber-dojo-start-points-base.XXX")
# TODO:
# create tmp-dir for cyber-dojo script
# if tmp-dir does not contain cyber-dojo script curl it there from commander

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
